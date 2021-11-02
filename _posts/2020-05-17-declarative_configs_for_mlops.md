---
layout: post
author: Benedikt Koller
title: A case for declarative configurations for ML training
tags: legacy
publish_date: May 17th, 2020
date: 2020-05-17T20:00:00Z
thumbnail: /assets/posts/declarative_cfg.svg
category: mlops
tags: [devops, mlops]
image:
  path: /assets/logo_sq.png
  height: 100
  width: 100
---

No way around it: I am what you call an "Ops guy". In my career I admin'ed more servers than I've written code. Over twelve years in the industry have left their permanent mark on me. For the last two of those I'm exposed to a new beast - Machine Learning. My hustle is bringing Ops-Knowledge to ML. These are my thoughts on that.

## Deploying software into production

Hundreds of thousands of companies deploy software into production every day. Every deployment mechanism has someone who built it. Whoever it was (The Ops Guy™, SRE-Teams, "Devops Engineers"), all follow tried-and-true paradigms. After all, the goal is to ship code often, in repeatable and reliable ways. Let me give you a quick primer on two of those.

### Infrastructure-as-code (IaC)

Infrastructure as code, or IaC, applies software engineering rules to infrastructure management. The goal is to avoid environment drift, and to ensure idempotent operations. In plain words, read the infrastructure configuration and you'll know exactly how the resulting environment looks like. You can rerun the provisioning without side effects, and your infrastructure has a predictable state. IaC allows for version-controlled evolution of infrastructures and quick provisioning of extra resources. It does so through declarative configurations.

Famous tools for this paradigm are Terraform, and to a large degree Kubernetes itself.

### Immutable infrastructure

In conjunction with IaC, immutable infrastructure ensures the provisioned state is maintained. Someone ssh'ed onto your server? Its tainted - you have no guarantee that it still is in the identical shape to the rest of your stack. Interaction between a provisioned infrastructure and new code happens only through automation. Infrastructure, e.g. a Kubernetes cluster, is never modified after it's provisioned. Updates, fixes and modifications are only possible through new deployments of your infrastructure.

Operational efficiency requires thorough automation and handling of ephemeral data. Immutable infrastructure mitigates config drift and snowflake server woes entirely.

## ML development

Developing machine learning models works in different ways. In a worst case scenario, new models begin their "life" in a Jupyter Notebook on someones laptop. Code is not checked into git, there is no requirements file, and cells can be executed in any arbitrary order. Data exploration and preprocessing are intermingled. Training happens on that one shared VM with the NVIDIA K80, but someone messed with the CUDA drivers. Ah, and does anyone remember where I put those `matplotlib` screenshots that showed the AUROC and MSE?

Getting ML models into production reliably, repeatedly and fast remains a challenge, and large data sets become a multiplying factor. The solution? Learn from our Ops-brethren.

We can extract key learnings from the evolution of infrastructure management and software deployments:

1. Automate processing and provisioning
2. Version-control states and instructions
3. Write declarative configs

How can we apply them to a ML training flow?

### Fetching data

Automate fetching of data. Declaratively define the datasource, the subset of data to use and then persist the results. Repeated experiments on the same source and subset can use the cached results.

Thanks to automation, fetching data can be rerun at any time. The results are persisted, so data can be versioned. And by reading the input configuration everyone can clearly tell what went into the experiment.

### Splitting (and preprocessing data)

Splitting data can be standardized into functions.

- Splitting happens on a quota, e.g. 70% into train, 30% into eval. Data might be sorted on an index, data might be categorized.
- Splitting happens based on features/columns. Data might be categorized, Data might be sorted on an index.
- Data might require preprocessing / feature engineering (e.g. filling, standardization).
- A wild mix of the above.

Given those, we can define an interface and invoke processing through parameters - and use a declarative config. Persist the results so future experiments can warm-start.

Implementation of interfaces makes automated processing possible. The resulting train/eval datasets are versionable, and my input config is the declarative authority on the resulting state of the input dataset.

### Training

Standardizing models is hard. Higher-level abstractions like Tensorflow and Keras already provide comprehensive APIs, but complex architectures need custom code injection.

A declarative config will, at least, state which version-controlled code was used. Re-runs on the same input will deliver the same results, re-runs on different inputs can be compared. Automation of training will yield a version-controllable artefact - the model - of a declared and therefore anticipatable shape.

### Evaluation

Surprisingly, this is the hardest to fully automate. The dataset and individual use case define the required evaluation metrics. However, we can stand on the shoulders of giants. Great tools like Tensorboard and the What-If-Tool go a long way. Our automation just needs to account for enough flexibility that a.) custom metrics for evaluation can be injected, and b.) raw training results are exposed for custom evaluation means.

### Serving

Serving is caught between the worlds. It would be easy to claim that a trained model is a permanent artifact, like you might claim that a Docker container acts as an artifact of software development. We can borrow another learning from software developers - if you don’t understand where your code is run, you don’t understand your code.

Only by understanding how a model is served will a ML training flow ever be complete. For one, data is prone to change. A myriad of reasons might be the cause, but the result remains the same: Models need to be retrained to account for data drift. In short, continuous training is required. Through the declarative configuration of our ML flow so far we can reuse this configuration and inject new data - and iterate on those new results.

For another, preprocessing might need embedding with your model. Automation lets us apply the same preprocessing steps used in training to live data, guaranteeing identical shape of input data.

## Why?

Outside academia, performance of machine learning models is measured through impact - economically, or by increased efficiency. Only reliable and consistent results are true measures for the success of applied ML. We as a new and still growing part of software engineering have to make sure of this success. And the reproducibility of success hinges on the repeatability of the full ML development lifecycle.
