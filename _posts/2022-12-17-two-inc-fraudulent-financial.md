---
layout: post
author: Simon Helmig at Two.inc (Guest post)
title: "Detecting Fraudulent Financial Transactions with ZenML"
description: "A winning entry - 2nd prize winner at Month of MLOps 2022 competition."
category: zenml
tags: zenml-project month-of-mlops
publish_date: December 17th, 2022
date: 2022-12-17T00:02:00Z
thumbnail: /assets/posts/neptune_released/Release_0.23.0.gif
image:
  path: /assets/posts/neptune_released/Release_0.23.0.jpg
---

**Last updated:** December 17, 2022.

![Release 0.23.0](../assets/posts/neptune_released/Release_0.23.0.jpg)


At Two, we’re keenly aware that the ability to develop, deploy, and maintain sophisticated machine learning solutions is critical for the success of our business. That’s why we make it a priority to keep our finger on the pulse of ongoing developments in the MLOps space.
A great example of this is the impressive framework developed by the ZenML team. So, as part of our efforts to get properly acquainted with their software and its capabilities, we decided to enter their Month of ML Ops competition.
For our submission, we decided to implement a fraud detection model using ZenML to utilise the framework for a problem similar to the ones our Data Science team works on.
In particular, we used the Synthetic data from a financial payment system dataset, made available by Kaggle, to develop our model. In line with the requirements of the competition, we began developing an end-to-end ML solution using ZenML, which was tasked with the following responsibilities:
Importing the dataset
Cleaning the data and engineering informative features
Detecting data drift of new data
Training a model to detect fraud on a transactional level
Evaluating the performance of the model
Deploying the model to a REST API endpoint
Providing an interface for users to interact with the model
To address these requirements we built a Training pipeline which we used for experimentation, and a Continuous Deployment pipeline. The Continuous Deployment pipeline extended the capabilities of the Training Pipeline to identify data drift in new data, train a model on all available data, and evaluate the performance of this model prior to deploying it to an API endpoint.
To enable these pipelines, we made use of the following ZenML stack:
Artifact Storage: Google Cloud Storage
Container Registry: Google Cloud Container Registry
Data Validator: EvidentlyAI
Experiment Tracker: MLFlow
Orchestrator: Google Kuberenetes Engine
Model Deployer: Seldon
We had a lot of fun implementing this solution using ZenML, and encourage readers to give the framework a try for themselves!


### 🚄 Training Pipeline

The Training pipeline defines the end-to-end process of training our model to predict whether a given transaction is fraudulent.
This pipeline is particularly useful compared to an ad-hoc training workflow thanks to its reproducibility and maintainability. The artifacts produced by each stage of the pipeline are automatically saved to the ZenML artifact storage, allowing us to revisit any model knowing exactly what data it was trained on.
Thanks to ZenML's infrastructure**-**agnostic design, it was also simple to integrate our pipeline with the MLFlow Experiment Tracker. This gave us visibility on the performance and metadata of each run of our pipeline, and made it easy to run the pipeline as a sequence of pods on Kubernetes.
The Training pipeline can be summarized as follows:


### 📥 Baseline Data Importer

### 🔧 Transformer

### 🏃‍♂️ Trainer

### 📈 Evaluator


## ♻️ Continuous Deployment Pipeline

### 📰 New Data Importer


### 〰️ Data Drift Detector


### ➕ Data Combiner

### ✅ Deployment Trigger


### 🚀 Model Deployer


## 💭 Conclusions


## 📚 Learn More
