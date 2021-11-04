---
layout: post
author: ZenML Team
title: ZenML will be open source
publish_date: November 11th, 2020
date: 2020-11-11T00:02:00Z
category: zenml
tags: bigger-picture open-source zenml
thumbnail: /assets/posts/open-source_1.svg
tags: legacy
image:
  path: /assets/posts/sharing-os.png
  height: 1200
  width: 628
---

For the last months, we’ve been hard at work bringing ZenML to market as a commercial product. Our vision was and remains the commoditization of reproducible Machine Learning. Every pipeline for every model should forever be reproducible and have a deployable model at its end. All the invaluable lessons we’ve learned in this time, from customers, users, friends, and strangers, are now culminating in the next step towards our goal: We will make ZenML available under an Open Source License.

The upcoming days will be dedicated to providing an extensible, open, and smartly abstracted version of the codebase we’ve been using so far to power our commercial product.

## Vision and reality

Above the realities of any project and startup stands a bigger vision. From our early days, we’ve always shared the belief that whatever we build should be available with as little barrier to adoption as possible - and Open Source is just the next stage of achieving that goal.

Next to that lofty vision is our vision for ZenML as a solution to a problem: making reproducible Machine Learning a reality. We are bridging the gap between your ML workflows and the complexity of ML tooling - in a unified tech-stack and without unnecessary steep learning curves.

We will have your back from sourcing data to trained models - and their deployment.
Let me walk you through a preview of what that’ll look like.

### Concepts

#### Artifact Stores

Every pipeline step, from sourcing data to training your model, will persist it’s output artifacts in a so-called artifact store. By default, the artifact store is a local directory inside your project. To allow for collaboration within teams and distribution of workloads on processing backends like Google Dataflow, we also support Google Cloud Storage buckets as artifact store.

_NOTE_: Support for AWS S3 and Azure Blob Storage is already on the roadmap.

#### Backends

Not every pipeline is suitable for local environments. Production workloads often require scheduling and distribution. That’s why we provide a few native integrations, e.g to processing backends like Google Dataflow or training backends like Google Cloud Platform. Custom backends can easily be added through extensible interfaces.

#### Tracking

Tracking is baked into the very fabric of ZenML. Inputs and outputs for every pipeline step are automatically tracked (default: local), and lineage can be established easily for all processed data up until serving time.

#### Comparability

An essential feature of ZenML is the guaranteed comparability of pipelines within a project. Automated tracking and a unified artifact store allow for the comparability of pipelines across processing backends.

### Pipeline layout

#### Sourcing data

ZenML pipelines start at sourcing data. For faster processing down the (pipe-)line, all data will be converted into `TFRecords`. To avoid unnecessary recomputation all processing is automatically versioned and cached. Results are conveniently stored immutably in a configurable artifact store. Sourcing data will automatically be executed on the configured backend (default: local).

#### Custom code and arbitrary pipeline steps

We are fully aware, workflows are very heterogeneous. The extensible interface design of ZenML allows you to easily extend a pipeline step, or build your own pipeline components. We’re exposing some convenient functionality, but you can dive deeper into the rabbit hole and eve run arbitrary TFX components, too.

_NOTE:_ TFX support can be subject to change in future releases.

#### Splitting

We’re shipping some batteries included making your life easier. From simple ratios to complex categorical or other hybrid split scenarios, you don’t have to reinvent the wheel (because we did). And where we fall short, you can use the extensible interface to run your own splits.

#### Preprocessing

Similar to splitting, we’re shipping a few batteries included, but provide an extensible interface to add your own code. As an added convenience, ZenML has native support for `tf.transform` and will embed the resulting transformation into the serving graph of your TensorFlow model.

#### Training

At launch, ZenML comes with native support for Keras models. For convenience, passing a `model_fn` is enough, but this functionality can be extended, similar to all the other pipeline steps before. Additionally, training can be offloaded to special training backends like Google AI Platform.

_NOTE_: Support for other libraries is already on the roadmap.

#### Evaluation

Every pipeline automatically provides you with pre-generated evaluation notebooks. There are a few tools we’ve found to be exceptionally useful, so we baked them in for you. Namely, we’re shipping these Notebooks with Tensorboard, TensorFlow Model Analysis (TFMA) as well as TensorFlow Data Validation (TFDV). You have, of course, access to all raw results to run your own evaluation.

#### Serving

Our value chain ends at serving. The heterogeneity of serving environments and use-cases guided our hand, and we’re shipping support for two of our favorite approaches: Seldon Core and Google AI Platform. Configuring Serving for your pipelines is optional, and can be added after running pipelines. For complex, custom scenarios we’re exposing an extensible interface for you to integrate ZenML in your existing workflows with limited overhead.

## Timeline

Going from closed-source and commercial to open-source is an involved process, and we’re working hard at making it happen. As of writing this, we’re looking at an anticipated release in early December 2020. If you have any questions or would like to talk to us about your special use-case feel free to reach out at support@zenml.io.
