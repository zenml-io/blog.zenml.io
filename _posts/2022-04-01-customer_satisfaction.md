---
layout: post
author: Ayush Singh
title: End to End Customer Satisfaction Pipeline with ZenML
description: "We built an end to end continuous deployment pipeline using ZenML for a customer satisfaction model that uses historical data of the customer predict the review score for the next order or purchase."
publish_date: April 1, 2022
date: 2022-04-01T10:20:00Z
tags: tensorflow machine-learning mlops evergreen applied-zenml pipelines 
category: zenml
thumbnail: /assets/posts/Customer_Satisfaction.png
image:
  path: /assets/posts/Customer_Satisfaction.png
  height: 100
  width: 100
---

Customer satisfaction is a measure of how satisfied a customer is with a product or service of a company. It is a subjective measure of the quality of a product or service. It is measured by the customer, and is usually used to evaluate the quality of a product or service. In this article, I will be building a customer satisfaction model that uses historical data of the customer predict the review score for the next order or purchase. 

I will be using [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) dataset, The data-set has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allow viewing orders from multiple dimensions: from order status, price, payment, and freight performance to customer location, product attributes and finally reviews written by customers. The objective here is to predict the customer satisfaction score for a given order based on the given features like order status, price, payment, etc.

I will be using [ZenML](https://zenml.io/) (MLOps Framework) to build an End to End Customer Satisfaction Pipeline. I will be using zenml traditional pipeline to build training pipeline which includes several steps like: 

* `ingest_data`  :- This step will ingest the data from source and will return a dataframe.
* `clean_data`   :- This step will clean the data and remove the unwanted columns. 
* `model_train`  :- This step will train the model and will save the model using mlfow autlogging. 
* `evaluation`   :- This step will evaluate the model and will save the metrics using mlfow autlogging into the artifact store.  

Now you may be thinking `Why do we require pipelines?` We can't just train our model in our local system as we need to serve to the users as well, so we need it to be deployed in the cloud. For doing Machine learning at scale we need machine learning pipelines which is an end-to-end construct that orchestrates the flow of data into, and output from, a machine learning model (or set of multiple models). It includes raw data input, features, outputs, the machine learning model and model parameters, and prediction outputs. and All these capbilities are built on top of the zenml framework.  

I will be also using the MLflow deployment integration that ZenML provides to help build a continuous deployment pipeline and an inference pipeline for our customer satisfaction system. 

## Setting up the project

I suggest you create and work out of a virtual environment. You can create a virtual environment using `conda` by following these steps, but of course you can also use whatever you're familiar with:

```shell
conda create -n envname python=x.x anaconda
conda activate envname
```

Before running this project, you must install some Python packages in your environment which you can do with the following steps:

```bash
git clone https://github.com/zenml-io/zenfiles.git
cd customer_satisfaction
pip install -r requirements.txt
```

If you are running the `run_deployment.py` script, you will also need to install some integrations using zenml:

```bash
zenml integration install mlflow -f
```

We're ready to go now. Now you can run the project, You have two pipelines to run, `run_pipeline.py` which is traditional ZenML Pipeline and `run_deployment.py` which is continuous deployment pipeline. So, if you want to run `run_pipeline.py` you can run the following command: 

```bash
python run_pipeline.py
```

and this will run the standard ZenML pipeline. If you want to run `run_deployment.py` you can run the following command:

```bash
python run_deployment.py
```

## How it works?

Let's start with the `run_pipeline.py` which is a traditional ZenML pipeline, the code for this pipeline is as follows:

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

* `ingest_data`  :- This step will ingest the data from the source and will return a dataframe, csv file is in `data` folder. 
* `clean_data`   :- This step will clean the data and remove the unwanted columns. It removes columns which contributes less to the target variable and fill null values with mean. 
* `model_train`  :- This step will train different models like xgboost, lightgbm, random forest. I am also using `mlflow tracking` to track our model performance, parameters, metrics and saving the model. 
* `evaluation`   :- This step will evaluates the model and will save the metrics using mlfow autlogging into the artifact store. This can be used to compare the performance of different models and make decision to select the best model. It will also help in doing error analysis of our selected model. 

![Steps in the ZenML traditional pipeline ](/assets/posts/training_pipeline.png)

Now we will move to the `run_deployment.py` which is a continuous deployment pipeline, the code for this pipeline is as follows:

```python 
def main(min_accuracy: float, stop_service: bool): 

    '''Run the mlflow example pipeline''' 
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
            f"The MLflow prediction server is running locally as a daemon process "
            f"and accepts inference requests at:\n"
            f"    {service.prediction_uri}\n"
            f"To stop the service, re-run the same command and supply the "
            f"`--stop-service` argument."
        )
if __name__ == "__main__":
    main()
```

It implements a continuous deployment workflow. It ingests and processes input data, trains a model and then (re)deploys the prediction server that serves the model if it meets some evaluation criteria.

In the deployment pipeline, ZenML's MLflow tracking integration is used to log the hyperparameter values -- as well as the trained model itself and the model evaluation metrics -- as MLflow experiment tracking artifacts into the local MLflow backend. This pipeline also launches a local MLflow deployment server to serve the latest MLflow model if its accuracy is above a configured threshold.

The MLflow deployment server is running locally as a daemon process that will continue to run in the background after the example execution is complete.

The deployment pipeline has caching enabled to avoid re-training the model if the training data and hyperparameter values don't change. When a new model is trained that passes the accuracy threshold validation, the pipeline automatically updates the currently running MLflow deployment server so that the new model is being served instead of the old one.

We also have an inference pipeline that interacts with the prediction server deployed by the continuous deployment pipeline to get online predictions based on live data. The inference pipeline simulates loading data from a dynamic external source, then uses that data to perform online predictions using the running MLflow prediction server.

![Steps in the ZenML continuous deployment pipeline ](/assets/posts/trainandinf.png) 

## What we learned

The e-commerce sector is rapidly evolving as internet accessibility is increasing in different parts of the world over the years. As a result, the demand for online shopping has increased. Businesses wants to know how satisfeid their customers are with their products and services, so they can make better decisions. Machine learning is playing one of the major role in various aspects of business like sales prediction, customer segmentation, product recommendation, customer satisfaction, etc. 

In this blog post we have seen that how to build a model that can predict the customer satisfaction based on the data provided by the customers. We have also seen how to use the MLflow to track the performance of the model and how to deploy the model for online prediction.  

If you’re interested in learning more about ZenML, visit our [Github page](https://github.com/zenml-io/zenml), [read our docs](https://docs.zenml.io/). If you have questions or want to talk through your specific use case, feel free to [reach out to us on Slack](https://zenml.io/slack-invite/)!
