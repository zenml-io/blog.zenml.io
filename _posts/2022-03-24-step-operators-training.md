---
layout: post
author: Hamza Tahir
title: "Run your steps on the cloud with Sagemaker, Vertex AI, and AzureML"
description: "With ZenML 0.6.3, you can now run your ZenML steps on Sagemaker, Vertex AI, and AzureML! It’s normal to have certain steps that require specific infrastructure (e.g. a GPU-enabled environment) on which to run model training, and Step Operators give you the power to switch out infrastructure for individual steps to support this."
category: zenml
tags: zenml cloud evergreen integrations
publish_date: March 25, 2022
date: 2022-03-25T00:09:00Z
thumbnail: /assets/posts/step-operators-training/clouds.jpg
image:
  path: /assets/posts/step-operators-training/clouds.jpg
---

**Last updated:** November 21, 2022.

_If you are of a more visual disposition, please check out this blog's [accompanying video tutorial](https://www.youtube.com/watch?v=rMf10sjJjZM)._

<iframe width="560" height="315" src="https://www.youtube.com/embed/rMf10sjJjZM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

_[Subscribe to the ZenML YouTube Channel](https://www.youtube.com/channel/UCi79n61eV2sVyYxJOqk_bMw)._

# What is a step operator?

The step operator defers the execution of individual steps in a pipeline to specialized runtime environments that are optimized for Machine Learning workloads. This is helpful when there is a requirement for specialized cloud backends ✨ for different steps. One example could be using powerful GPU instances for training jobs or distributed compute for ingestion streams. 

![ZenML step operators allow training in the cloud]({{ site.url }}/assets/posts/step-operators-training/zen_in_clouds.gif)

# I’m confused 🤔. How is it different from an orchestrator?

An orchestrator is a higher level entity than a step operator. It is what executes the 
entire ZenML pipeline code and decides what specifications and backends to use for each step. 

The orchestrator runs the code which launches your step in a backend of your choice. If you don’t specify a step operator, then the step code runs on the same compute instance as your orchestrator.

While an orchestrator defines how and where your entire pipeline runs, a step operator defines how and where an individual 
step runs. This can be useful in a variety of scenarios. An example could be if one step within a pipeline needed to run on a 
separate environment equipped with a GPU (like a trainer step).

# How do I use it?

A step operator is a stack component, and is therefore part of a [ZenML stack](https://docs.zenml.io/getting-started/core-concepts#stacks-and-components).

An operator can be registered as part of the stack as follows:

```bash
zenml step-operator register OPERATOR_NAME \
    --type=OPERATOR_TYPE
    ...
```

And then a step can be decorated with the `custom_step_operator` parameter to run it with that operator backend:

```python
from zenml.client import Client

step_operator = Client().active_stack.step_operator
@step(step_operator=step_operator.name)
def trainer(...) -> ...:
    """Train a model"""
    # This step will run in environment specified by operator
```

# Run on AWS Sagemaker, GCP Vertex AI, and Microsoft Azure ML

<iframe src="https://giphy.com/embed/lrW5C1vjtWKb3X2oom" width="480" height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p>The step operator makes you feel like this -- <a href="https://giphy.com/gifs/BoschGlobal-like-a-boss-likeabosch-bosch-lrW5C1vjtWKb3X2oom">via GIPHY</a></p>


ZenML's cloud integrations are now extended to include step operators that run an individual step in all of the public cloud providers hosted ML platform offerings. The ZenML [GitHub repository](https://github.com/zenml-io/zenml/tree/main/examples) gives a great example of how to use these integrations. Let's walk through one example, with AWS Sagemaker, in this blog. The other two clouds are quite similar and follow the same pattern.

## Introduction to AWS Sagemaker

[AWS Sagemaker](https://aws.amazon.com/sagemaker/) is a hosted ML platform offered by Amazon Web Services. It manages the full lifecycle of building, training, and deploying machine learning (ML) models for any use case with fully managed infrastructure, tools, and workflows. It offers specialized compute instances to run your training jobs and has a beautiful UI to track and manage your models and logs. 

You can now use the new `SagemakerStepOperator` class to submit individual steps to be run on compute instances managed by Amazon Sagemaker. 

## Set up a stack with the AWS Sagemaker StepOperator

As we are working in the cloud, we need to first do a bunch of preperatory steps to regarding permissions and resource creation. In the future, ZenML will automate a lot of this way. For now, follow these manual steps:

- Create or choose an S3 bucket to which Sagemaker should output any artifacts from your training run. Then register it as an artifact store:

```bash
zenml artifact-store register s3-store \
    --type=s3
    --path=<S3_BUCKET_PATH>
```

- A container registry has to be configured in the stack. This registry will be used by ZenML to push your job images that Sagemaker will run. Register this as well:

```bash
# register the container registry
zenml container-registry register ecr_registry --type=default --uri=<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
```

- Set up the `aws` cli set up with the right credentials. Make sure you have the permissions to create and manage Sagemaker runs. 

- Create a role in the IAM console that you want the jobs running in Sagemaker to assume. This role should at least have the `AmazonS3FullAccess` and `AmazonSageMakerFullAccess` policies applied. Check [this link](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html#sagemaker-roles-create-execution-role) to learn how to create a role.

- Choose what instance type needs to be used to run your jobs. You can get the list [here](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html).

- Come up with an experiment name if you have one created already. Check [this guide](https://docs.aws.amazon.com/sagemaker/latest/dg/experiments-create.html) to know how. If not provided, the job runs would be independent of an experiment.

- Optionally, select a custom docker image that you want ZenML to use as a base image for creating an environment to run your jobs in Sagemaker. 

- Once you have all these values handy, you can proceed to setting up the components required for your stack.

```bash
# create the sagemaker step operator
zenml step-operator register sagemaker \
    --type=sagemaker
    --role=<SAGEMAKER_ROLE> \
    --instance_type=<SAGEMAKER_INSTANCE_TYPE>
    --base_image=<CUSTOM_BASE_IMAGE>
    --bucket_name=<S3_BUCKET_NAME>
    --experiment_name=<SAGEMAKER_EXPERIMENT_NAME>
```

The command to register the stack component would look like the following. More details about the parameters that you can configure can be found in the class definition of Sagemaker Step Operator in the [API docs](https://apidocs.zenml.io/). 

- Register the sagemaker stack with the same pattern as always:

```bash
# register the sagemaker stack
zenml stack register sagemaker_stack \
    -o local_orchestrator \
    -c ecr_registry \
    -a s3-store \
    -s sagemaker

# activate the stack
zenml stack set sagemaker_stack
```

And now you have the stack up and running! Note that similar steps can be undertaken with Vertex AI and Azure ML. See the [docs](https://docs.zenml.io/user-guide/component-guide/step-operators) for more information.

## Create a pipeline with the step operator decorator

Once the above is out of the way, any step of any pipeline we create can be decorated with the following decorator:

```python
from zenml.client import Client

step_operator = Client().active_stack.step_operator
@step(step_operator=step_operator.name)
def trainer(...) -> ...:
    """Train a model"""
    # This step will run as a custom job in Sagemaker
```

ZenML will take care of packaging the step for you into a docker image, pushing the image, provisioning the resources for the custom job, and monitoring it as it progresses. Once complete, the pipeline will continue as always.

You can also switch the "sagemaker" operator with any other operator of your choosing, and it will work with the same step code as you always have. Modularity at its best!

So what are you waiting for? Read more about step operators in the [docs](https://docs.zenml.io), or try it yourself with the [full example at the GitHub repository](https://github.com/zenml-io/zenml/tree/main/examples). Make sure to leave a star if you do end up there!


[Image credit: Photo by <a
href="https://unsplash.com/@lukaszlada?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">lukaszlada</a>
on <a
href="https://unsplash.com/photos/LtWFFVi1RXQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]
