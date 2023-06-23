---
layout: post
author: Alex Strick van Linschoten
title: "What's New in v0.6.1: Reach for the AWS and Azure Cloud! ☁️"
description: "Release notes for the new version of ZenML. We now support AWS S3 and Azure Blob Storage as artifact stores. You'll also find a lot of smaller improvements and bug fixes in this release."
category: zenml
tags: zenml release-notes
publish_date: February 7, 2022
date: 2022-02-07T00:02:00Z
thumbnail: /assets/posts/release_0_6_1/ankush-minda-4Xy08NbMBLM-unsplash.jpg
image:
  path: /assets/posts/release_0_6_1/ankush-minda-4Xy08NbMBLM-unsplash.jpg
---

**Last updated:** November 3, 2022.

ZenML 0.6.1 is out and it's all about Cloud storage ☁️! We have improved your ability to work with AWS services and added a brand-new Azure integration! Run your pipelines on AWS and Azure now and let us know how it went [on our Slack](https://zenml.io/slack-invite/).

Smaller changes that you'll notice include much-awaited updates and fixes, including the first iterations of scheduling pipelines and tracking more reproducibility-relevant data in the metadata store. For a detailed look at what's changed, give [our full release notes](https://github.com/zenml-io/zenml/releases/tag/0.6.1) a glance.

## ☁️ Cloud Integrations: AWS and Azure

You can now use [Azure Blob Storage](https://azure.microsoft.com/en-us/services/storage/blobs/) and [AWS' S3](https://aws.amazon.com/s3?tag=soumet-20) as your [artifact store](https://docs.zenml.io/v/0.13.2/mlops-stacks/artifact-stores) for ZenML pipelines. We implemented all the relevant `fileio` methods to enable this. If you prefer to use Amazon's AWS or Microsoft's Azure, we hope these new integrations will be the start of more options for you when using ZenML.

To learn more, check out [the new documentation page](https://docs.zenml.io/) we just included to guide you in deploying your pipelines to AWS, GCP and/or Azure.

## 🛠 Stack and Integration Improvements

Some significant improvements behind the scenes, though some of these are the first in a series of wider improvements to specific areas:

- All orchestrators now have the ability to configure `Schedule` objects (with the exception of the local orchestrator). This is the first part of our implementation of scheduled pipelines in ZenML. Watch this space for more!
- You can now attach custom properties to your pipeline so that they are tracked within the ZenML Metadata Store.
- Our MLFlow Tracking integration now works well with Kubeflow as well as scheduled pipelines. (You might have had issues when trying to use those two together in the previous release.)

## 🗒 Documentation Updates

As the codebase and functionality of ZenML grows, we always want to make sure [our documentation](https://docs.zenml.io/) is clear, up-to-date and easy to use. We made a number of changes in this release that will improve your experience in this regard:

- Ensure *quickstart* example code is identical across everywhere it is referenced.
- Fix MLFlow Tracking, lineage, statistics and airflow_local examples.
- Various spelling and typo corrections.

## ➕ Other updates, additions and fixes

- If you're using ZenML in coordination with `mypy` in your own codebase, we added the relevant file that will mark it as a 'typed' package. You're welcome! We saved you from some `mypy` errors 😄.
- We improved the error message if your ZenML is missing inside a Kubeflow container entrypoint.
- We now prevent access to the repository during step execution. This stops bad things from happening inadvertently.
- The materializer registry now can detect sub-classes of defined types.
- Our computation of the hashes of steps and materialisers (relied on by our caching behavior as well as other things) now works in notebooks rather than just in code executed from files.
- We improved some error messages to help you better understand what's going on when things go wrong.

## Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think we should build next!

Keep your eyes open for future releases and make sure to vote on your favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure it gets implemented as soon as possible.

[Image credit: Photo by <a href="https://unsplash.com/@an_ku_sh?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Ankush Minda</a> on <a href="https://unsplash.com/s/photos/balloons?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]