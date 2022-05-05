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

I will be using ZenML's [Kubeflow](https://github.com/zenml-io/zenml/tree/main/examples/kubeflow) integration to deploy pipelines to production using Kubeflow Pipelines on the cloud.

Our training pipeline `run_kubeflow_pipeline.py` consists of the following steps:

![PipelineStepExplanation](/assets/posts/customer-churn/pipelinestepsexplanation.png)

- `ingest_data`: Ingest the data from the source and create a DataFrame.
- `encode_cat_cols`: Encode categorical columns.
- `handle_imbalanced_data`: Handle imbalanced data.
- `drop_cols`: Dropping irrelevant columns.
- `data_splitter`: Split the data into training and test sets.
- `model_trainer`: Train the model.
- `evaluation`: Evaluate the trained model.

if you want to run the pipeline with `default` stack settings, you can run the following command:

```bash
zenml stack set default
python run_kubeflow_pipeline.py
```

### Run the same pipeline on a local Kubeflow Pipelines deployment

Previously I ran our pipeline in default stack settings, now I will transition our pipeline to a more production-ready setting and deploy the pipeline to a more robust environment. In this section, I will run the same pipeline on a local Kubeflow Pipelines deployment.

With all the installation and initialization out of the way, all that's left to do is configure our ZenML stack. For this example, the stack we create consists of the following four parts:

- The **local artifact store** stores step outputs on your hard disk.
- The **local metadata store** stores metadata like the pipeline name and step
  parameters inside a local SQLite database.
- The Docker images created to run your pipeline are stored in a local
  Docker **container registry**.
- The **Kubeflow orchestrator** is responsible for running your ZenML pipeline
  in Kubeflow Pipelines.

```bash
# Make sure to create the local registry on port 5000 for it to work
zenml container-registry register local_registry --type=default --uri=localhost:5000
zenml orchestrator register kubeflow_orchestrator --type=kubeflow
zenml stack register local_kubeflow_stack \
    -m local_metadata_store \
    -a local_artifact_store \
    -o kubeflow_orchestrator \
    -c local_registry

# Activate the newly-created stack
zenml stack set local_kubeflow_stack
```

Now, we need to start the Kubeflow Pipelines stack locally; all we need to do is run:

```bash
zenml stack up
```

We can now run the pipeline by simply executing the Python script:

```bash
python run_kubeflow_pipeline.py
```

This will build a Docker image containing all the necessary Python packages and
files, push it to the local container registry and schedule a pipeline run in
Kubeflow Pipelines. Once the script is finished, you should be able to see the
pipeline run [here](http://localhost:8080/#/runs).

### Transitioning to Production with Kubeflow on AWS

Now I will transition our pipeline to a more production-ready setting and deploy the pipeline to a more robust environment because I don't want to deploy our pipeline locally, I want to deploy it on cloud. In this section, I will run the same pipeline on a Kubeflow Pipelines deployment on AWS.

There are two steps in order to continue:

- Set up the necessary cloud resources on the provider of your choice
- Configure ZenML with a new stack to be able to communicate with these resources

I will now run the same pipeline in Kubeflow Pipelines deployed to an AWS EKS cluster. Before running this, you need some additional setup or prerequisites to run the pipeline on AWS: you can refer to our [documentation](https://docs.zenml.io/features/guide-aws-gcp-azure#pre-requisites) which will help you get set up to run the pipeline on AWS.

If you want to run the pipeline on other cloud providers like GCP or Azure, you can follow [this guide](https://docs.zenml.io/features/guide-aws-gcp-azure) for more information on those cloud providers. We will be using AWS for this project, but feel free to use any cloud provider.

Following diagram which showcases our Kubeflow stack on AWS:

![CloudKubeflowStack](/assets/posts/customer-chull/aws_kubeflow_stack.png)

Now, I will configure the Kubeflow Pipelines stack on AWS and run the pipeline on AWS, following are the steps for doing so:

1. Install the cloud provider

```bash
zenml integration install aws
```

2. Register the stack components

```bash
zenml container-registry register cloud_registry --type=default --uri=$PATH_TO_YOUR_CONTAINER_REGISTRY
zenml orchestrator register cloud_orchestrator --type=kubeflow --custom_docker_base_image_name=YOUR_IMAGE
zenml metadata-store register kubeflow_metadata_store --type=kubeflow
zenml artifact-store register cloud_artifact_store --type=s3 --path=$PATH_TO_YOUR_BUCKET

# Register the cloud stack
zenml stack register cloud_kubeflow_stack -m kubeflow_metadata_store -a cloud_artifact_store -o cloud_orchestrator -c cloud_registry
```

3. Activate the newly-created stack

```bash
zenml stack set cloud_kubeflow_stack
```

4. Run the pipeline

```shell
python run_kubeflow_pipeline.py
```

5. Configure port Forwarding and check the Kubeflow UI to see if the model is deployed and running! 🚀

```bash
kubectl --namespace kubeflow port-forward svc/ml-pipeline-ui 8080:80
```

Now, you can go to [the localhost URL](http://localhost:8080/#/runs) to see the UI. If everything is working, you should see the model deployed and running as below:
![SuccessfulPipelineRun](/assets/posts/customer-chull/runsuccesskubeflow.png)

### Connecting Kubeflow Pipelines with Streamlit

Now we have a running pipeline deployed using Kubeflow Pipelines on AWS, Now I will connect the pipeline to data application like Streamlit so that I can using the model for prediction. Following code is core logic for connecting the pipeline to Streamlit.

```python
repo = Repository()
p = repo.get_pipeline("training_pipeline")
last_run = p.runs[-1]
trainer_step = last_run.get_step("model_trainer")
model = trainer_step.output.read()

input_details = [..., ..., ...]
pred = model.predict(input_details)
```

I'm fetching the `training_pipeline` from the ZenML repository and taking the last run of the pipeline. Then, I'm fetching the `model_trainer` step from the last run and reading the model from the `model_trainer` step. After that, I'm fetching the input details from the user and using the model to predict the output.

You can run the Streamlit app by running the following command:

```bash
streamlit run streamlit_apps/streamlit_app_kubeflow.py
```
