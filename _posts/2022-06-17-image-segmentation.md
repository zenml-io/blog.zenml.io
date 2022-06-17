---
layout: post
author: Ayush Singh
title: Segmenting Stomach and Intestines from MRI Scans Using ZenML
description: "We built an end to end production-grade pipeline using ZenML for a computer vision problem where our problem was to segment stomach and intestine from MRI scans."
publish_date: May 27, 2022
date: 2022-05-27T10:20:00Z
tags: machine-learning mlops evergreen applied-zenml pipelines zenfile
category: zenml
thumbnail: /assets/posts/customer-churn/poster.jpg
image:
  path: /assets/posts/customer-churn/poster.jpg
  height: 100
  width: 100
---

[Gastrointestinal cancer](https://en.wikipedia.org/wiki/Gastrointestinal_cancer#:~:text=Gastrointestinal%20cancer%20refers%20to%20malignant,large%20intestine%2C%20rectum%20and%20anus.) refers to malignant conditions of the gastrointestinal tract (GI tract) and accessory organs of digestion such as stomach, esophagus and other organs of digestion. During treatment of gastrointestinal cancer, doctors must manually outline the position of the stomach and intestines in order to adjust the direction of the x-ray beams to increase the dose delivery to the tumor and avoid the stomach and intestines. This is a time-consuming and labor intensive process that can prolong treatments from 15 minutes a day to an hour a day. Doctors needs a method to automate this process.

So I will create a model to automatically segment the stomach and intestines on Magnetic resonance imaging (MRI) scans. I will be using data from [UW-Madison GI Tract Image Segmentation Competiton](https://www.kaggle.com/competitions/uw-madison-gi-tract-image-segmentation/data) to build our model.

This blog shows you how to build such model which will segment the stomach and intestines from MRI scans using [ZenML](https://zenml.io/). Our aim is not to build the best model or win this competiton but to show you, but to show you the power of the ZenML that how it can ease the whole process with it's amazing features like caching, easily switching stacks from local to cloud, training on different cloud service provider using `StepOperator`, integrating with experiment tracking tools like wandb.

## Running the pipeline using StepOperator Stack

In order to build a model which will segment stomach and intestine from MRI scans & setting this in real-world workflow, I will build a reproducible pipeline using ZenML for this task, I will be using step operators for training on cloud (I will be using AWS but feel free to choose your favorite cloud provider.), I will also make use of ZenML's wandb integration for experiment tracking.

Our training pipeline `run_image_seg_pipeline.py` will be built using the following steps:-

- `prepare_df`: This step will read the data and prepare it for the pipeline.
- `create_stratified_fold`: This step creates stratified k folds.
- `augment_df`: This is a step that returns a dictionary of data transforms( the transformation which we need to apply on our data).
- `prepare_dataloaders`: This step takes in the dataframe and the data transforms and returns the train and validation dataloaders.
- `initiate_model_and_optimizer`: This is a step that returns (U-Net model, Adam optimizer, Configured scheduler).
- `train_model`: a step that takes in the model, optimizer, scheduler, train_loader, and valid_loader and returns the trained model and history.

I need to train the models on remote environment, so we need to use `StepOperator` to run your training jobs on remote backends.Step operators allow you to run individual steps in a custom environment different from the default one used by your active orchestrator. One example use-case is to run a training step of your pipeline in an environment with GPUs available.

You can find step operator implementations for the three big cloud providers in the azureml, sagemaker and vertex integrations. You can also build your own custom step operator, you can learn more about this [here](https://docs.zenml.io/extending-zenml/step-operators#building-your-own-custom-step-operator).

Let's first create a sagemaker stack, you can create it by following commands:-

```bash
# install ZenML integrations
zenml integration install aws s3

zenml artifact-store register s3_store \
    --flavor=s3 \
    --path=<S3_BUCKET_PATH>

# create the sagemaker step operator
zenml step-operator register sagemaker \
    --flavor=sagemaker \
    --role=<SAGEMAKER_ROLE> \
    --instance_type=<SAGEMAKER_INSTANCE_TYPE>
    --base_image=<CUSTOM_BASE_IMAGE>
    --bucket_name=<S3_BUCKET_NAME>
    --experiment_name=<SAGEMAKER_EXPERIMENT_NAME>

# register the container registry
zenml container-registry register ecr_registry --flavor=aws --uri=<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

# register and activate the sagemaker stack
zenml stack register sagemaker_stack \
    -m default \
    -o default \
    -c ecr_registry \
    -a s3_store \
    -s sagemaker \
    --set
```

So, Now I created and registered the sagemaker stack, Now you can run the pipeline by running the following command:-

```bash
python run_image_seg_pipeline.py
```

## Integrating WANDB in our pipeline

I will be integrating Weights & Biases (It's a popular tool that tracks and visualizes experiment runs with their many parameters, metrics and output files) for experiment tracking, I will create the stack with the wandb experiment tracker component.

In order to use an experiment tracking tool like Weights & Biases, you need to create a new `StackCoomponent`, and
subsequently a new `Stack` with the type `wandb`. The wandb experiment tracker stack component has the following options:

- `api_key`: Non-optional API key token of your wandb account.
- `project_name`: The name of the project where you're sending the new run. If the project is not specified, the run is put in an "Uncategorized" project.
- `entity`: An entity is a username or team name where you're sending runs. This entity must exist before you can send runs there, so make sure to create your account or team in the UI before starting to log runs. If you don't specify an entity, the run will be sent to your default entity, which is usually your username.

Note that project_name and entity are optional in the below command:

```shell
zenml experiment-tracker register wandb_tracker --type=wandb \
    --api_key=<WANDB_API_KEY> \
    --entity=<WANDB_ENTITY> \
    --project_name=<WANDB_PROJECT_NAME>

zenml stack register wandb_stack \
    -m default \
    -a default \
    -o default \
    -e wandb_tracker \
    --set
```

BUT I am not done yet!!!

I need to create a stack that supports step operator component as well as wandb experiment tracker component. You can create such stack by the following command:-

```bash
zenml stack register sagemaker_stack_with_wandb \
    -m default \
    -o default \
    -c ecr_registry \
    -a s3_store \
    -s sagemaker \
    -e wandb_tracker \
    --set
```

I created a stack named `sagemaker_stack_with_wandb` which has `StepOperator` component as sagemaker, and `wandb` as experiment tracker. Now you can run the `run_image_seg_pipeline.py` by the following command:

```bash
python run_image_seg_pipeline.py
```

## What we learned

In this blog post, I showed you how to build a production-grade machine learning system that segments stomach and intestine from MRI scans using ZenML, I showed how you can make use of ZenML's `StepOperator` to run your training jobs on remote backend server, I also showed how you can use popular experiment tracking tools like `wandb` to track your experiments in ZenML.

If you're interested in learning more about ZenML, visit our [Github page](https://github.com/zenml-io/zenml), [read our docs](https://docs.zenml.io/). If you have questions or want to talk through your specific use case, feel free to [reach out to us on Slack](https://zenml.io/slack-invite/)!
