---
layout: post
author: Dickson Neoh
title: "ZenML 0.22.0: BentoML Integration and A Revamped Airflow Orchestrator!"
description: "This release comes with a new BentoML integration as well as a reworked Airflow orchestrator. Additionally, it greatly improves the server performance as well as other small fixes and updates to our docs!"
category: zenml
tags: zenml release-notes
publish_date: November 22nd, 2022
date: 2022-11-05T00:02:00Z
thumbnail: /assets/posts/release_0_22_0/Release_0.22.0.gif
image:
  path: /assets/posts/release_0_22_0/Release_0.22.0.jpg
---

![Release 0.22.0](../assets/posts/release_0_22_0/Release_0.22.0.jpg)

It's been a while since we last release a new feature.
We've been busy in the past month on the [Month of MLOps competition](./2022-09-26-mlops-competition.md) and fixing various bugs after our [major 0.20.0 release](./2022-10-05-zenml-revamped.md).

This time around, we are back to shipping new features to you!

In [ZenML 0.22.0](https://github.com/zenml-io/zenml/releases/tag/0.22.0) we present to you a brand new [BentoML](https://www.bentoml.com/) integration and a revamped Airflow Orchestrator!

Let's dive right into the changes.

## 🤖 BentoML Integration
The BentoML integration has been on our radar for some time now and we finally took the time to flesh it out with the help of our contributors [Tim Cvetko](https://github.com/timothy102) and [Aaron Pham](https://github.com/aarnphm).

The new [BentoML integration](https://zenml.io/integrations/bentoml) includes a BentoML model deployer component that allows you to deploy your models from any of the major machine learning frameworks on your local machine and in the cloud.

We will be showcasing the BentoML integration in our next community hour (23rd Nov 2022, 5:30PM CET). 
Curious to learn more? Join us [here](https://zenml.io/meet).

In the meantime, check out the BentoML [example]((https://github.com/zenml-io/zenml/tree/main/examples/bentoml_deployment)) on our repo.

## 🚀 Airflow in the Clouds

The previous Airflow orchestrator was limited to running locally and had many additional unpleasant constraints.
It's a pain to work with. So, we've completely rewritten, the Airflow orchestrator. Now, it works both locally and with remote Airflow deployments!

Watch a demo video below to see the revamped Airflow orchestrator in action.
<iframe width="560" height="316" src="https://www.youtube-nocookie.com/embed/v-tEm4O61Y8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

And also, check out the example of the brand-new Airflow orchestrator [here](https://github.com/zenml-io/zenml/tree/main/examples/airflow_orchestration).


## 💔 Breaking Changes

The revamped Airflow orchestrator comes with a breaking change. 
The Airflow orchestrator now requires a newer version of Airflow and Docker installed to work.

You can simply run `zenml integration install airflow` to update your installations to the right versions.

## ☔ Notable Bug Fixes and Improvements

The ZenML Label Studio integration can now be used with non-local (i.e. deployed) instances. For more information see the [Label Studio documentation](https://docs.zenml.io/component-gallery/annotators/label-studio).
The Label Studio [example](https://github.com/zenml-io/zenml/tree/main/examples/label_studio_annotation) shows how you can set it up on major cloud infrastructure like Azure, GCP and AWS.

The Spark [example](https://github.com/zenml-io/zenml/tree/main/examples/spark_distributed_programming) is fixed and now works again end-to-end.

We also include a fix that speeds up the data sync from the MLMD database to the ZenML server. 

As usual, we included a list of various improvements which you can view [here](https://github.com/zenml-io/zenml/releases/edit/0.22.0).


## 🤗 New Contributors

We are super grateful to have the following new contributors in this release!

* [@sheikhomar](https://github.com/sheikhomar) made their first contribution in [#1045](https://github.com/zenml-io/zenml/pull/1045)
* [@chiragjn](https://github.com/chiragjn) made their first contribution in [#1057](https://github.com/zenml-io/zenml/pull/1057)

Thank you for helping us make ZenML better and sharing it with the community.

## 🔥 Onwards and Upwards!

If you find any bugs or something doesn't work the way you expect, please [let
us know in Slack](https://zenml.io/slack-invite) or also feel free to [open up a
Github issue](https://github.com/zenml-io/zenml/issues/new/choose) if you
prefer. We welcome your feedback and we thank you for your support!
