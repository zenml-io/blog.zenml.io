---
layout: post
author: Hamza Tahir
title: "Run your steps on the cloud with Sagemaker, Vertex, and AzureML"
description: "With ZenML 0.6.3, you can now run your ZenML steps on Sagemaker, Vertex AI, and AzureML! It’s normal to have certain steps that require specific infrastructure (e.g. a GPU-enabled environment) on which to run model training, and Step Operators give you the power to switch out infrastructure for individual steps to support this."
category: zenml
tags: zenml cloud evergreen integrations
publish_date: March 25, 2022
date: 2022-03-25T00:09:00Z
thumbnail: /assets/posts/step-operators-training/clouds.jpg
image:
  path: /assets/posts/step-operators-training/clouds.jpg
---

_If you are of a more visual disposition, please check out this blog's [accompanying video tutorial](https://www.youtube.com/watch?v=b5TXRYkdL3w)._

<div class="embed-responsive embed-responsive-16by9 mb-5">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/04DbbEzE9ig" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

_[Subscribe to the ZenML YouTube Channel](https://www.youtube.com/channel/UCi79n61eV2sVyYxJOqk_bMw)._

# What is a step operator?

The step operator defers the execution of individual steps in a pipeline to specialized runtime environments that are optimized for Machine Learning workloads. This is helpful when there is a requirement for specialized cloud backends ✨ for different steps. One example could be using powerful GPU instances for training jobs or distributed compute for ingestion streams. 

![ZenML step operators allow training in the cloud](../assets/posts/step-operators-training/zen_in_clouds.gif)

# I’m confused 🤔. How is it different from an orchestrator?

An orchestrator is a higher level entity than a step operator. It is what executes the 
entire ZenML pipeline code and decides what specifications and backends to use for each step. 

The orchestrator runs the code which launches your step in a backend of your choice. If you don’t specify a step operator, then the step code runs on the same compute instance as your orchestrator.

While an orchestrator defines how and where your entire pipeline runs, a step operator defines how and where an individual 
step runs. This can be useful in a variety of scenarios. An example could be if one step within a pipeline needed to run on a 
separate environment equipped with a GPU (like a trainer step).

# How do I use it?

A step operator is a stack component, and is therefore part of a [ZenML stack](https://docs.zenml.io/core-concepts#stack).

An operator can be registered as part of the stack as follows:

```bash
zenml step-operator register OPERATOR_NAME \
    --type=OPERATOR_TYPE
    ...
```

And then a step can be decorated with the `custom_stop_operator` parameter to run it with that operator backend:

```python
@step(custom_step_operator=OPERATOR_NAME)
def trainer(...) -> ...:
    """Train a model"""
    # This step will run in environment specified by operator
```

# Run on AWS Sagemaker, GCP Vertex AI, and Microsoft Azure ML

<iframe src="https://giphy.com/embed/lrW5C1vjtWKb3X2oom" width="480" height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p>The step operator makes you feel like this -- <a href="https://giphy.com/gifs/BoschGlobal-like-a-boss-likeabosch-bosch-lrW5C1vjtWKb3X2oom">via GIPHY</a></p>

 ZenML's cloud integrations are now extended to include step operators that run an individual step in all of the public cloud providers hosted ML platform offerings. The ZenML [GitHub repository](https://github.com/zenml-io/zenml/tree/main/examples) gives a great example of how to use these integrations. Let's walk through one example, with AWS Sagemaker, in this blog. The other two clouds are quite similar and follow the same pattern.

 ## Pre-requisites

As we are working in the cloud, we need to first do a bunch of preperatory steps to regarding permissions and resource creation. In the future, ZenML will automate a lot of this way. For now, follow these manual steps:

 - Create a role in the IAM console that you want the jobs running in Sagemaker to assume. This role should at least have the `AmazonS3FullAccess` and `AmazonSageMakerFullAccess` policies applied. Check [this link](https://docs.aws.amazon.com/sagemaker/latest/dg/sagemaker-roles.html#sagemaker-roles-create-execution-role) to learn how to create a role.

- Choose what instance type needs to be used to run your jobs. You can get the list [here](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-available-instance-types.html).

- Create or choose an S3 bucket to which Sagemaker should output any artifacts from your training run. 

* You can also supply an experiment name if you have one created already. Check [this guide](https://docs.aws.amazon.com/sagemaker/latest/dg/experiments-create.html) to know how. If not provided, the job runs would be independent.

* You can also choose a custom docker image that you want ZenML to use as a base image for creating an environment to run your jobs in Sagemaker. 

* You need to have the `aws` cli set up with the right credentials. Make sure you have the permissions to create and manage Sagemaker runs. 

* A container registry has to be configured in the stack. This registry will be used by ZenML to push your job images that Sagemaker will run.

Once you have all these values handy, you can proceed to setting up the components required for your stack.

The command to register the stack component would look like the following. More details about the parameters that you can configure can be found in the class definition of Sagemaker Step Operator in the API docs (https://apidocs.zenml.io/). 


In summary, read more about Step Operators in the [docs](https://docs.zenml.io), or follow the [full example at the GitHub repository](https://github.com/zenml-io/zenml/tree/main/examples). Make sure to leave a star if you do end up there!



[Image credit: Photo by <a
href="https://unsplash.com/@lukaszlada?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">lukaszlada</a>
on <a
href="https://unsplash.com/photos/LtWFFVi1RXQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]
