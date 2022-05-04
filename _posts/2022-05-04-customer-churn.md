---
layout: post
author: Ayush Singh
title: Will they stay or go? Building a Customer Loyalty Predictor
description: "We built an end-to-end production-grade pipeline using ZenML for a Customer Churn model that can predict whether a customer will stay or go."
publish_date: April 20, 2022
date: 2022-04-20T10:20:00Z
tags: machine-learning mlops evergreen applied-zenml pipelines zenfile
category: zenml
thumbnail: /assets/posts/customer-satisfaction/Customer_Satisfaction.png
image:
  path: /assets/posts/customer-satisfaction/Customer_Satisfaction.png
  height: 100
  width: 100
---

When someone leaves a company and when that customer stops paying a business for its services or products, we call that 'churn'. We can calculate a churn rate for a company by dividing the number of customers who churned by the total number of customers and then multiplying that number by 100 to reach a percentage value. If you want to learn more about customer churn, you can read this [Wikipedia article](https://en.wikipedia.org/wiki/Churn_rate). In this article, I show how I used a ZenML pipeline to build a customer churn model and present two deployment options:-

- `Deployment using Kubeflow Pipelines`: I will be using [Kubeflow Pipelines](https://www.kubeflow.org/docs/components/pipelines/) to build and run our ZenML pipeline on the cloud and deploy it in a production environment.
- `Continuous Deployment using Seldon Core`: I will be using [Seldon Core](https://docs.seldon.io/projects/seldon-core/en/latest/index.html), a production-grade open-source model serving platform, to build our continuous deployment pipeline that trains a model and then serves it with Seldon Core.

I will be using the [Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn?datasetId=13996&sortBy=voteCount) dataset for building an end to end production-grade machine learning system that can predict whether the customer will stay loyal or not. The dataset has 20 input features and a target variable for 7043 customers.

## Deployment using Kubeflow Pipelines

To build a real-world workflow for predicting whether a customer will churn or not, you will probably develop your pipelines on your local machine initially, allowing for quick iteration and debugging. However, at a certain point, when you are finished with its design, you might want to transition to a more production-ready setting and deploy the pipeline to a more robust environment. This is where ZenML comes in.

We will be ZenML's [Kubeflow](https://github.com/zenml-io/zenml/tree/main/examples/kubeflow) integration to deploy pipelines to production using Kubeflow Pipelines on the cloud.

Our training pipeline `run_kubeflow_pipeline.py` consists of the following steps:

![PipelineStepExplanation](/assets/posts/customer-churn/pipelinestepsexplanation.png)

- `ingest_data`: Ingest the data from the source and create a DataFrame.
- `encode_cat_cols`: Encode categorical columns.
- `handle_imbalanced_data`: Handle imbalanced data.
- `drop_cols`: Dropping irrelevant columns.
- `data_splitter`: Split the data into training and test sets.
- `model_trainer`: Train the model.
- `evaluation`: Evaluate the trained model.
