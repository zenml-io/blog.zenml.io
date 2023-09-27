---
layout: post
author: Ayush Singh
title: Predicting how a customer will feel about a product before they even ordered it
description: "We built an end to end continuous deployment pipeline using ZenML for a customer satisfaction model that uses historical data of the customer predict the review score for the next order or purchase."
publish_date: April 20, 2022
date: 2022-04-20T10:20:00Z
tags: machine-learning mlops evergreen applied-zenml pipelines zenml-project
category: zenml
thumbnail: /assets/posts/customer-satisfaction/Customer_Satisfaction.png
image:
  path: /assets/posts/customer-satisfaction/Customer_Satisfaction.png
  height: 100
  width: 100
---

**Last updated:** November 21, 2022.

Customer satisfaction is a measure of how satisfied a customer is with a product or service of a company. It is a subjective measure of the quality of a product or service. It is measured by the customer and is usually used to evaluate the quality of a product or service. In this article, I show how I used a ZenML pipeline to create a model that uses historical customer data to predict the review score for the next order or purchase. I also deployed a [Streamlit application](https://share.streamlit.io/ayush714/customer-satisfaction/main) to showcase the final end product.

I will be using the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). This dataset has information on 100,000 orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allow viewing charges from various dimensions: from order status, price, payment, freight performance to customer location, product attributes and finally, reviews written by customers. The objective here is to predict the customer satisfaction score for a given order based on features like order status, price, payment, etc.

The first pipeline we create consists of the following steps:

- `ingest_data`: This step will ingest the data and create a `DataFrame`.
- `clean_data`: This step will clean the data and remove the unwanted columns.
- `model_train`: This step will train the model and save the model using [MLflow autologging](https://www.mlflow.org/docs/latest/tracking.html).
- `evaluation`: This step will evaluate the model and save the metrics -- using MLflow autologging -- into the artifact store.

In order to build a real-world workflow, it is not enough to just train the model once. Instead, I chose to build an end-to-end pipeline for continuously predicting and deploying the machine learning model, alongside a data application that utilizes the latest deployed model for the business to consume. This way, my workflow can be deployed to the cloud, scale up according to business needs, and ensure that all parameters and data that flow through pipeline runs are tracked. 

ZenML helps to build such a pipeline in a simple, yet powerful, way. It integrates with tools that allow you to compare experiments (i.e. MLflow), easily deploy models that you've trained, and then later fetch them for inference with a simple command.

If you prefer consuming your content in video form, then [this](https://youtu.be/L3_pFTlF9EQ) video covers the same material found in this blogpost.

<div class="embed-responsive embed-responsive-16by9 mb-5">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/L3_pFTlF9EQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Setting up the project

I suggest you create and work out of a virtual environment. You can create a virtual environment using `conda` by following these steps, but of course, you can also use whatever you're familiar with:

```shell
conda create -n envname python=x.x anaconda
conda activate envname
```

Before running this project, you must install some Python packages in your environment, which you can do with the following steps:

```bash
git clone https://github.com/zenml-io/zenml-projects.git
cd zenml-projects/customer-satisfaction
pip install -r requirements.txt
```

If you are running the `run_deployment.py` script, you will also need to install some integrations using ZenML:

```bash
zenml init
zenml integration install mlflow -y
```

We're ready to go now. Now you can run the project, and You have two pipelines to run, `run_pipeline.py`, a pipeline that only trains the model and `run_deployment.py`, a pipeline that also continuously deploys the model. If you only want to run the former, you can do:

```bash
python run_pipeline.py
```

While the latter can be run with:

```bash
python run_deployment.py
```

## How does it work?

Let's start with the `run_pipeline.py`, which is a traditional ZenML pipeline, the code for this pipeline is as follows:

```python
def run_training():
    ...
    train_pipeline(
        ingest_data(),
        clean_data().with_return_materializers(cs_materializer),
        train_model(),
        evaluation(),
    ).run()
```

It will run the following steps:

- `ingest_data`: This step will ingest the data from the source and return a data frame; the CSV file is in the `data` folder.
- `clean_data`: This step will clean the data and remove the unwanted columns. It removes columns that contribute less to the target variable and fills null values with mean.
- `model_train`: This step will train different models like xgboost, lightgbm, and random forest. I am also using MLflow to track our model performance, parameters, metrics and for saving the model.
- `evaluation`: This step will evaluate the model and save the metrics using MLflow autologging into the artifact store. Autologging can be used to compare the performance of different models and decide to select the best model. It will also help in doing an error analysis of our model chosen.

We have another pipeline, the `deployment_pipeline.py`, that extends the training pipeline, and implements a continuous deployment workflow. It ingests and processes input data, trains a model and then (re)deploys the prediction server that serves the model if it meets our evaluation criteria. The criteria that we have chosen is a configurable threshold on the [mean squared error](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_squared_error.html#sklearn.metrics.mean_squared_error) of the training.

```python
deployment = continuous_deployment_pipeline(
    ingest_data(),
    clean_data().with_return_materializers(cs_materializer),
    train_model(),
    evaluation(),
    deployment_trigger=deployment_trigger(
        config=DeploymentTriggerConfig(
            min_accuracy=min_accuracy,  # set a min threshold for deployment
        )
    ),
    model_deployer=mlflow_model_deployer(...),  # use mlflow to deploy
)
deployment.run()
```

In the deployment pipeline, ZenML's [MLflow tracking integration](https://docs.zenml.io/stacks-and-components/component-guide/experiment-trackers/mlflow) is used for logging the hyperparameter values and the trained model itself and the model evaluation metrics -- as MLflow experiment tracking artifacts -- into the local MLflow backend. This pipeline also launches a local MLflow deployment server to serve the latest MLflow model if its accuracy is above a configured threshold.

The MLflow deployment server runs locally as a daemon process that will continue to run in the background after the example execution is complete. When a new pipeline is run which produces a model that passes the accuracy threshold validation, the pipeline automatically updates the currently running MLflow deployment server to serve the new model instead of the old one. While this ZenML Project trains and deploys a model locally, other ZenML integrations such as the [Seldon](https://github.com/zenml-io/zenml/tree/main/examples/) deployer can also be used in a similarly manner to deploy the model in a more production setting (such as on a Kubernetes cluster).

To round it off, we deploy a Streamlit application that consumes the latest model service asynchronously from the pipeline logic. This can be done easily with ZenML within the Streamlit code:

```python
service = load_last_service_from_step(
    pipeline_name="continuous_deployment_pipeline",
    step_name="model_deployer",
    running=True,
)
...
service.predict(...)  # Predict on incoming data from the application
```

If you want to run this Streamlit app in your local system, you can run the following command:

```bash
streamlit run streamlit_app.py
```

![Steps in the ZenML continuous deployment pipeline ]({{ site.url }}/assets/posts/customer-satisfaction/trainingandif.png)

## Results

We have experimented with two ensemble and tree-based models and compared the performance of each model. The results are as follows:

| Models       | MSE   | RMSE  |
| ------------ | ----- | ----- |
| **LightGBM** | 1.804 | 1.343 |
| **XGboost**  | 1.781 | 1.335 |

I framed our problem as a regression problem and used the "LightGBM" model as our final model. You can also put this in a multi-class classification problem and analyze the results. Output from a model can be adjusted according to a threshold; for example, we can round the work to its nearest integer; say, for example, that we can round the output to its nearest integer.

The following figure shows how important each feature is in the model that contributes to the target variable or predicting customer satisfaction rate.

![FeatureImportance]({{ site.url }}/assets/posts/customer-satisfaction/feature_importance_gain.png)

## 🕹 Demo App

We also made a live demo of this project using [Streamlit](https://streamlit.io/) which you can find [here](https://share.streamlit.io/ayush714/customer-satisfaction/main). It takes some input features for the product and predicts the customer satisfaction rate using our trained models.

![DemoApp]({{ site.url }}/assets/posts/customer-satisfaction/screenshotofweb.png)

This app simulates what happens when predicting the customer satisfaction score for a given customer. You can input the features of the product listed below and get the customer satisfaction score.

| Models                         | Description                                                                                                                             |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------- |
| **Payment Sequential**         | Customer may pay for an order with more than one payment method. If he does so, a sequence will be created to accommodate all payments. |
| **Payment Installments**       | Number of installments chosen by the customer.                                                                                          |
| **Payment Value**              | Total amount paid by the customer.                                                                                                      |
| **Price**                      | Price of the product.                                                                                                                   |
| **Freight Value**              | Freight value of the product.                                                                                                           |
| **Product Name length**        | Length of the product name.                                                                                                             |
| **Product Description length** | Length of the product description.                                                                                                      |
| **Product photos Quantity**    | Number of product published photos                                                                                                      |
| **Product weight (gms)**       | Weight of the product measured in grams.                                                                                                |
| **Product length (CMs)**       | Length of the product measured in centimeters.                                                                                          |
| **Product height (CMs)**       | Height of the product measured in centimeters.                                                                                          |
| **Product width (CMs)**        | Width of the product measured in centimeters.                                                                                           |

## What we learned

The e-commerce sector is rapidly evolving as internet accessibility increases in different parts of the world over the years. As a result, the demand for online shopping has grown. Businesses want to know how satisfied their customers are with their products and services to make better decisions. Machine learning plays a significant role in various aspects of business like sales prediction, customer segmentation, product recommendation, customer satisfaction, etc.

In this blog post, we have seen how to build a model that can predict customer satisfaction based on data provided by customers. We have also seen how to use MLflow to track the model's performance and how to deploy the model for online prediction. Finally, we have seen how one can deploy and interact with a web application that consumes a deployed model with Streamlit.

If you're interested in learning more about ZenML, visit our [GitHub page](https://github.com/zenml-io/zenml), [read our docs](https://docs.zenml.io/). If you have questions or want to talk through your specific use case, feel free to [reach out to us on Slack](https://zenml.io/slack-invite/)!
