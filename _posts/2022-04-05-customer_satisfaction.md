---
layout: post
author: Ayush Singh
title: Predicting how a customer will feel about a product before he even ordered it
description: "We built an end to end continuous deployment pipeline using ZenML for a customer satisfaction model that uses historical data of the customer predict the review score for the next order or purchase."
publish_date: April 11, 2022
date: 2022-11-04T10:20:00Z
tags: machine-learning mlops evergreen applied-zenml pipelines zenfile
category: zenml
thumbnail: /assets/posts/Customer_Satisfaction.png
image:
  path: /assets/posts/Customer_Satisfaction.png
  height: 100
  width: 100
---

Customer satisfaction is a measure of how satisfied a customer is with a product or service of a company. It is a subjective measure of the quality of a product or service. It is measured by the customer and is usually used to evaluate the quality of a product or service. In this article, I built a customer satisfaction model that uses historical customer data to predict the review score for the next order or purchase. 

I will be using the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). This dataset has information on 100,000 orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allow viewing charges from various dimensions: from order status, price, payment, freight performance to customer location, product attributes and finally, reviews written by customers. The objective here is to predict the customer satisfaction score for a given order based on features like order status, price, payment, etc. I will be using [ZenML](https://zenml.io/) to build a production-ready pipeline to predict the customer satisfaction score for the next order or purchase.

- `ingest_data`: This step will ingest the data and create a `DataFrame`.
- `clean_data`: This step will clean the data and remove the unwanted columns.
- `model_train`: This step will train the model and save the model using [MLflow autologging](https://www.mlflow.org/docs/latest/tracking.html).
- `evaluation`: This step will evaluate the model and save the metrics -- using MLflow autologging -- into the artifact store.


Now you may be wondering why we need pipelines in the first place. We can't just train our model in our local system as we need to serve the users, so we need it to be deployed in the cloud. For doing machine learning at scale, we need machine learning pipelines, an end-to-end construct that orchestrates the flow of data into and out of a machine learning model (or set of multiple models). It includes raw data input, features, results, the machine learning model and model parameters, as well as prediction outputs. And all these capabilities are built on top of ZenML. Using ZenML, you can run the components of the project on the cloud, and it helps in caching steps so that you don't waste your time/processing power.
It integrates with tools that allow you to compare experiments (i.e. MLflow), easily deploy models that you've trained and easily monitor your deployed models. 

I will also use the MLflow deployment integration that ZenML provides to help build a continuous deployment pipeline and an inference pipeline for our customer satisfaction system. 

## Setting up the project

I suggest you create and work out of a virtual environment. You can create a virtual environment using `conda` by following these steps, but of course, you can also use whatever you're familiar with:

```shell
conda create -n envname python=x.x anaconda
conda activate envname
```

Before running this project, you must install some Python packages in your environment, which you can do with the following steps:

```bash
git clone https://github.com/zenml-io/zenfiles.git
cd customer_satisfaction
pip install -r requirements.txt
```

If you are running the `run_deployment.py` script, you will also need to install some integrations using ZenML:

```bash
zenml integration install mlflow -f
```

We're ready to go now. Now you can run the project, and You have two pipelines to run, `run_pipeline.py`, a traditional ZenML Pipeline and `run_deployment.py`, a continuous deployment pipeline. So, if you want to run `run_pipeline.py`, you can run the following command: 

```bash
python run_pipeline.py
```

And this will run the standard ZenML pipeline. If you want to run `run_deployment.py`, you can run the following command:

```bash
python run_deployment.py
```

## How does it work?

Let's start with the `run_pipeline.py`, which is a traditional ZenML pipeline, the code for this pipeline is as follows:

```python
def run_training(): 
    training = train_pipeline(
        ingest_data(),
        clean_data().with_return_materializers(cs_materializer),
        train_model(),
        evaluation(),
    )

    training.run()


if __name__ == "__main__":
    run_training()

    mlflow_env = Environment()[MLFLOW_ENVIRONMENT_NAME]
    print(
        "Now run \n "
        f"    mlflow ui --backend-store-uri {mlflow_env.tracking_uri}\n"
        "To inspect your experiment runs within the mlflow ui.\n"
        "You can find your runs tracked within the `mlflow_example_pipeline`"
        "experiment. Here you'll also be able to compare the two runs.)"
    )
``` 

It will run the following steps: 

* `ingest_data`: This step will ingest the data from the source and return a data frame; the CSV file is in the `data` folder.
* `clean_data`: This step will clean the data and remove the unwanted columns. It removes columns that contribute less to the target variable and fills null values with mean.
* `model_train`: This step will train different models like xgboost, lightgbm, and random forest. I am also using MLflow to track our model performance, parameters, metrics and for saving the model. 
* `evaluation`: This step will evaluate the model and save the metrics using MLflow autologging into the artifact store. Autologging can be used to compare the performance of different models and decide to select the best model. It will also help in doing an error analysis of our model chosen. 

![Steps in the ZenML traditional pipeline ](/assets/posts/training_pipeline.png)

We have another pipeline, the `deployment_pipeline.py`, that implements a continuous deployment workflow. It ingests and processes input data, trains a model and then (re)deploys the prediction server that serves the model if it meets our evaluation criteria. For us this is the [mean squared error](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.mean_squared_error.html#sklearn.metrics.mean_squared_error); you can also set your own minimum MSE.

```python 
def main(min_accuracy: float, stop_service: bool): 

    '''Run the MLflow example pipeline''' 
    if stop_service:
        service = load_last_service_from_step(
            pipeline_name="continuous_deployment_pipeline",
            step_name="model_deployer",
            running=True,
        )
        if service:
            service.stop(timeout=10)
        return

    deployment = continuous_deployment_pipeline(  
        ingest_data(), 
        clean_data().with_return_materializers(cs_materializer),
        train_model(),
        evaluation(),
        deployment_trigger=deployment_trigger(
            config=DeploymentTriggerConfig(
                min_accuracy=min_accuracy,
            )
        ), 
        model_deployer=model_deployer(config=MLFlowDeployerConfig(workers=3)),
    ) 
    deployment.run() 

    inference = inference_pipeline(
        dynamic_importer=dynamic_importer().with_return_materializers(cs_materializer),
        prediction_service_loader=prediction_service_loader(
            MLFlowDeploymentLoaderStepConfig(
                pipeline_name="continuous_deployment_pipeline",
                step_name="model_deployer",
            )
        ),
        predictor=predictor(),
    ) 
    inference.run()

    mlflow_env = Environment()[MLFLOW_ENVIRONMENT_NAME]
    print(
        "You can run:\n "
        f"[italic green]    mlflow ui --backend-store-uri {mlflow_env.tracking_uri}[/italic green]\n"
        "...to inspect your experiment runs within the MLflow UI.\n"
        "You can find your runs tracked within the `mlflow_example_pipeline`"
        "experiment. There you'll also be able to compare two or more runs.\n\n"
    )

    service = load_last_service_from_step(
        pipeline_name="continuous_deployment_pipeline",
        step_name="model_deployer",
        running=True,
    )
    if service:
        print(
            f "The MLflow prediction server is running locally as a daemon process."
            f" and accepts inference requests at:\n."
            f"    {service.prediction_uri}\n"
            f" To stop the service, re-run the same command and supply the"
            f" `--stop-service` argument."
        )
if __name__ == "__main__":
    main()
```

It implements a continuous deployment workflow. It ingests and processes input data, trains a model and then (re)deploys the prediction server that serves the model if it meets some evaluation criteria.

In the deployment pipeline, ZenML's MLflow tracking integration is used for logging the hyperparameter values and the trained model itself and the model evaluation metrics -- as MLflow experiment tracking artifacts -- into the local MLflow backend. This pipeline also launches a local MLflow deployment server to serve the latest MLflow model if its accuracy is above a configured threshold.

The MLflow deployment server runs locally as a daemon process that will continue to run in the background after the example execution is complete.

The deployment pipeline has caching enabled to avoid re-training the model if the training data and hyperparameter values don't change. When a new model is trained and passes the accuracy threshold validation, the pipeline automatically updates the currently running MLflow deployment server to serve the new model instead of the old one.

We also have an inference pipeline that interacts with the continuous prediction server deployed to get online predictions based on live data. The inference pipeline simulates loading data from a dynamic external source and then uses that data to perform online predictions using the running MLflow prediction server.

![Steps in the ZenML continuous deployment pipeline ](/assets/posts/trainandinf.png) 

## Results 

We have experimented with two ensemble and tree-based models and compared the performance of each model. The results are as follows: 


| Models | MSE | RMSE | 
| ------------- | - | - |
| **LightGBM** | 1.804 |  1.343 |
| **XGboost** | 1.781| 1.335 | 

I framed our problem as a regression problem and used the "LightGBM" model as our final model. You can also put this in a multi-class classification problem and analyze the results. Output from a model can be adjusted according to a threshold; for example, we can round the work to its nearest integer; say, for example, that we can round the output to its nearest integer. 

The following figure shows how important each feature is in the model that contributes to the target variable or predicting customer satisfaction rate. 

![FeatureImportance](/assets/posts/feature_importance_gain.png) 

## 🕹 Demo App
We also made a live demo of this project using [Streamlit](https://streamlit.io/) which you can find [here](https://share.streamlit.io/ayush714/customer-satisfaction/main). It takes some input features for the product and predicts the customer satisfaction rate using our trained models.

![DemoApp](/assets/posts/screenshotofweb.png)

This app simulates what happens when predicting the customer satisfaction score for a given customer. You can input the features of the product listed below and get the customer satisfaction score. 

| Models        | Description   | 
| ------------- | -------------      | 
| **Payment Sequential** | Customer may pay for an order with more than one payment method. If he does so, a sequence will be created to accommodate all payments. | 
| **Payment Installments**   | Number of installments chosen by the customer. |  
| **Payment Value** |       Total amount paid by the customer. | 
| **Price** |       Price of the product. |
| **Freight Value** |    Freight value of the product.  | 
| **Product Name length** |    Length of the product name. |
| **Product Description length** |    Length of the product description. |
| **Product photos Quantity** |    Number of product published photos |
| **Product weight (gms)** |    Weight of the product measured in grams. | 
| **Product length (CMs)** |    Length of the product measured in centimeters. |
| **Product height (CMs)** |    Height of the product measured in centimeters. |
| **Product width (CMs)** |    Width of the product measured in centimeters. |


## What we learned

The e-commerce sector is rapidly evolving as internet accessibility increases in different parts of the world over the years. As a result, the demand for online shopping has grown. Businesses want to know how satisfied their customers are with their products and services to make better decisions. Machine learning plays a significant role in various aspects of business like sales prediction, customer segmentation, product recommendation, customer satisfaction, etc. 

In this blog post, we have seen how to build a model that can predict customer satisfaction based on data provided by customers. We have also seen how to use MLflow to track the model's performance and how to deploy the model for online prediction.  

If you're interested in learning more about ZenML, visit our [Github page](https://github.com/zenml-io/zenml), [read our docs](https://docs.zenml.io/). If you have questions or want to talk through your specific use case, feel free to [reach out to us on Slack](https://zenml.io/slack-invite/)!
