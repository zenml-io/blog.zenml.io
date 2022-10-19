---
layout: post
author: Hamza Tahir
title: "What's New in v0.7.1: Fetch data from your feature store and deploy models on Kubernetes"
description: "The release introduces the Seldon Core ZenML integration, featuring the Seldon Core Model Deployer and a Seldon Core standard model deployer step. It also includes two new integrations with Feast as ZenML's first feature store addition and NeuralProphet adding to the growing list of training libraries supported."
category: zenml
tags: zenml release-notes
publish_date: April 11, 2022
date: 2022-04-11T00:02:00Z
thumbnail: /assets/posts/release_0_7_1/ian-dooley-DuBNA1QMpPA-unsplash.jpg
image:
  path: /assets/posts/release_0_7_1/ian-dooley-DuBNA1QMpPA-unsplash.jpg
---

![Seldon Core Logo]({{ site.url }}/assets/posts/release_0_7_1/release-0-7-1.gif)

The release introduces the [Seldon Core](https://github.com/SeldonIO/seldon-core) ZenML integration, featuring the *Seldon Core Model Deployer* and a *Seldon Core standard model deployer step*. The [*Model Deployer*](https://docs.zenml.io/getting-started/core-concepts#model-deployer) is a new type of stack component that enables you to develop continuous model deployment pipelines that train models and continuously deploy them to an external model serving tool, service, or platform. You can read more on deploying models to production with Seldon Core in our [Continuous Training and Deployment documentation section](https://docs.zenml.io/features/continuous-training-and-deployment) and our [Seldon Core deployment example](https://github.com/zenml-io/zenml/tree/main/examples/seldon_deployment).

We also two two new integrations: Feast and NeuralProphet. [Feast](https://feast.dev) is ZenML's first feature store integration. Feature stores allow data teams to serve data via an offline store and an online low-latency store where data is kept in sync between the two. It also offers a centralized registry where features (and feature schemas) are stored for use within a team or wider organization. ZenML currently supports connecting to a Redis-backed Feast feature store as a stack component integration. Check out the [full example](https://github.com/zenml-io/zenml/tree/release/0.7.1/examples/feature_store) to see it in action!

0.7.1 also brings an addition to the ZenML training library integrations with [NeuralProphet](https://neuralprophet.com/html/index.html). Check out the new [example](https://github.com/zenml-io/zenml/tree/main/examples) for more details, and the [docs](https://docs.zenml.io) for further detail on all new features!

## ☁️ Deploy models continuously on Kubernetes

![Seldon Core Logo]({{ site.url }}/assets/posts/release_0_7_1/seldon-core-logo.png)

We are proud to release one of the most requested features from our [community roadmap](https://zenml.io/roadmap) today! With 0.7.1, you can serve your models continuously on Kubernetes using the Seldon Core integration!

[Seldon Core](https://github.com/SeldonIO/seldon-core) is a production-grade open-source model serving platform. It packs a wide range of features built around deploying models to REST/GRPC microservices that include monitoring and  logging, model explainers, outlier detectors, and various continuous deployment
strategies such as A/B testing, canary deployments, and more.

Seldon Core also comes equipped with a set of built-in model server implementations designed to work with standard formats for packaging ML models that greatly simplify the process of serving models for real-time inference.

The [full example](https://github.com/zenml-io/zenml/tree/main/examples/seldon_deployment) demonstrates how easy it is to build a continuous deployment pipeline that trains a model and then serves it with Seldon Core as the industry-ready model deployment tool of choice.

After [serving models locally with MLflow](https://github.com/zenml-io/zenml/tree/main/examples/mlflow_deployment), switching to a ZenML MLOps stack that features Seldon Core as a model deployer component makes for a seamless transition from running experiments locally to deploying models in production.

## 🗄️ Fetch data from your Feature Store

0.7.1 introduces [Feast](https://feast.dev) as ZenML's first feature store integration. Feature stores allow data teams to serve data via an offline store and an online low-latency store where data is kept in sync between the two. It also offers a centralized registry where features (and feature schemas) are stored for use within a team or wider organization. ZenML currently supports connecting to a Redis-backed Feast feature store as a stack component integration. Check out the [full example](https://github.com/zenml-io/zenml/tree/release/0.7.1/examples/feature_store) to see it in action! 

![Feast Architecture]({{ site.url }}/assets/posts/release_0_7_1/feast-archtecture.svg)
Picture Source: [Feast website](https://feast.dev)

There are two core functions that feature stores enable: access to data from an offline / batch store for training and access to online data at inference time. The ZenML Feast integration enables both of these behaviors.

The full [example](https://github.com/zenml-io/zenml/tree/main/examples/feature_store) showcases how to fetch a configured feature store in a ZenML step.  This example uses a local implementation where the whole setup runs on a single machine, but we assume that users of the ZenML Feast integration will have set up their feature store already. We encourage users to check out [Feast's documentation](https://docs.feast.dev/) and [guides](https://docs.feast.dev/how-to-guides/) on how to set up your offline and online data sources via the configuration `YAML` file.

## ➕ Other Updates, Additions, and Fixes

Abstract Stores and FileIO were overhauled in this release: Abstract Stores now have a way cleaner abstraction with the FileIO methods embedded. Check out the [BaseArtifactStore](https://github.com/zenml-io/zenml/blob/main/src/zenml/artifact_stores/base_artifact_store.py#L68) for more information.

This release marks the beginnings of a ZenML Service with PR [#496](https://github.com/zenml-io/zenml/pull/496). This service will keep track of pipelines, users, teams, and stacks in a centralized manner and can be deployed to the cloud! Watch out for the next release for this exciting new update!

## Join us for the inaugural MLOps hour

We're hosting an MLOps Hour! On Wednesday, 13th April 9 AM PT / 6 PM CET, we'll be gathering the ZenML community (and beyond) to showcase CI/CD/CT in MLOps using the latest release features!

Don't miss out, [register now here](https://www.eventbrite.de/e/zenml-mlops-hour-from-experimentation-to-continuous-deployment-tickets-313855027837
)!

Alternatively, chat with us directly by joining our [Slack](https://zenml.io/slack-invite/). Have a good one!

[*Photo by <a
href="https://unsplash.com/@sadswim?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">ian
dooley</a> on <a
href="https://unsplash.com/s/photos/balloon?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>*]
