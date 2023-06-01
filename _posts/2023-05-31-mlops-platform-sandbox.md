---
layout: post
author: "Alex Strick van Linschoten"
title: "Launching MLOps Platform Sandbox: A Production-Ready MLOps Platform in an Ephemeral Environment"
description: "An easy way to deploy an ephemeral MLOps stack, inclusive of ZenML, Kubeflow, MLflow, and Minio Bucket. This one-stop sandbox provides users an interactive playground to explore pre-built pipelines and effortlessly experiment with various MLOps tools, without the burden of infrastructure setup and management."
category: zenml
tags: tooling zenml evergreen mlops sandbox
publish_date: May 31, 2023
date: 2023-05-31T00:02:00Z
thumbnail: /assets/posts/sandbox/sandbox-launch-small.png
image:
  path: /assets/posts/sandbox/sandbox-launch.png
---

**Last updated:** May 31, 2023

![Screenshots of the MLOps Platform Sandbox](/assets/posts/sandbox/sandbox-launch.png)

We are excited to launch the MLOps Platform Sandbox, a one-click deployment platform for an ephemeral MLOps stack that you can use to run production-ready MLOps pipelines in the cloud. The MLOps Platform Sandbox allows you to create a sandbox with a stack made up of [ZenML](https://zenml.io/), [Kubeflow](https://www.kubeflow.org/), [MLflow](https://mlflow.org/), and [Minio ](https://min.io/) Bucket. The Sandbox comes with pre-built example pipelines that you can run and try out. It provides a seamless experience for you to experiment with these tools without worrying about infrastructure setup and management.

## Simplifying MLOps Platform Deployment

The goal of [ZenML](https://www.zenml.io) is to give ML and MLOps Engineers the ability to pick and choose their preferred infrastructure and tooling to build a platform that fulfills their company's needs. However, deploying ZenML and a rudimentary MLOps platform can be time-consuming for new users. The MLOps Platform Sandbox bridges this gap by providing a one-click deployment platform for a pre-built ephemeral MLOps stack, simplifying the deployment process.

<div class="embed-responsive embed-responsive-16by9 mb-5">
  <iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/4oGF_utgJtE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

You can sign up with Google and start a demo sandbox. After a few minutes, you'll receive credentials for Kubeflow, Minio, MLflow, and ZenML. You can then use commands like `zenml connect` and `zenml stack set` to set your stacks and `python run.py` to run the pipelines. The sandbox is deleted after 8 hours, and you can choose from a repository of pre-built pipelines to run.

## Why ZenML On Kubeflow / MLflow / Minio?

Using ZenML with Kubeflow, MLflow, and Minio is a representative stack as it
includes a production-ready orchestrator, an object storage component for data
versioning, and a popular experiment tracking tool in machine learning. ZenML's
stack recipe system is designed to allow you to easily swap out components and
infrastructure based on your company's needs.

Our [Stack Recipes](https://github.com/zenml-io/mlops-stacks) allow you to take
the next step after using the sandbox. These recipes are designed to be customizable, allowing you to easily swap out
components and infrastructure based on your company's requirements. You can
replace Kubeflow with Vertex AI Pipelines or Sagemaker Pipelines, use S3 or GCS
storage instead of Minio, and choose Weights and Biases or Neptune over MLflow.

## How to Use the Sandbox

![Screenshot of the MLOps Platform Sandbox](/assets/posts/sandbox/zenml_sandbox_step_3_commands.png)

The Sandbox provides you with pre-built pipelines that you can easily re-run or modify to suit your needs. If you want to run your own custom code inside your sandbox, there are a few more steps you'll have to do, all of which is [described in our dedicated documentation page](https://docs.zenml.io/user-guide/advanced-guide/sandbox).

To list the available pre-built pipelines with which your sandbox comes, simply use the command `zenml pipeline list`. This will display a list of pipelines, including their build IDs, which you can use to run a specific pipeline.

To run a pipeline with a build, use the command `zenml pipeline run <PIPELINE_NAME> --build_id <BUILD_ID>`. For example, to run the `mlflow_example_pipeline`, you would enter `zenml pipeline run mlflow_example_pipeline --build_id <BUILD_ID>`, replacing `<BUILD_ID>` with the appropriate build ID from the list.

Using these pre-built pipelines makes it incredibly easy to reproduce results and experiment with powerful tools integrated into the ZenML framework. By leveraging the MLOps Platform Sandbox, you can quickly explore the capabilities of a unified MLOps platform in the context of real ML pipelines without the hassle of setting up and managing your own infrastructure.

## What To Do After Your Sandbox Expires

Once you have experimented with the MLOps Platform Sandbox and gained a better
understanding of how the ZenML frameworks work, you may want to deploy your own
MLOps stack tailored to your specific needs. To help you with this process,
ZenML offers [Stack Recipes](https://github.com/zenml-io/mlops-stacks), which
provide a starting point for deploying various MLOps stacks on different cloud
providers and with different components. Our documentation also includes [a
guide to the specific steps to
follow](https://docs.zenml.io/platform-guide/set-up-your-mlops-platform/deploy-and-set-up-a-cloud-stack/deploy-a-stack-post-sandbox)
for when your sandbox has expired and you want
to create your own MLOps stack.

If you would like to extend your sandbox, you can request an extension by
[filling in the form here](https://zenml.io/extend-sandbox). We will get back to
you as soon as possible, but please be sure to fill in the form in good time to
allow us to review your request.

## Try out the Sandbox!

MLOps Platform Sandbox provides an easy-to-use platform for users to experiment with ZenML, Kubeflow, and MLflow without having to worry about infrastructure setup and management.

To try the MLOps Platform Sandbox, visit
[https://sandbox.zenml.io](https://sandbox.zenml.io/). To learn more about
ZenML, join our [Slack community](https://zenml.io/slack) and check out our
[GitHub](https://github.com/zenml-io/zenml) repository.
