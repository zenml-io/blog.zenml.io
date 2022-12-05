---
layout: post
author: Hamza Tahir
title: What's New in v0.5.6
description: "Release notes for the new version of ZenML."
category: zenml
tags: zenml release-notes
publish_date: December 23, 2021
date: 2021-12-23T00:02:00Z
thumbnail: /assets/posts/release_0_5_6/balloons-unsplash-0-5-6.jpeg
image:
  path: /assets/posts/release_0_5_6/balloons-unsplash-0-5-6.jpeg
  # height: 1910
  # width: 1000
---

**Last updated:** November 3, 2022.

This release fixes some known bugs from previous releases and especially [0.5.5](2021-12-13-zero-five-five-release.md). Therefore, upgrading to 0.5.6 is a **breaking change**. You must do the following in order to proceed with this version:

```
cd zenml_enabled_repo
rm -rf .zen/
```

And then start again with ZenML init:

```
pip install --upgrade zenml
zenml init
```

## New Features
* Added `zenml example run [EXAMPLE_RUN_NAME]` feature: The ability to run an example with one command. In order to run this, do `zenml example pull` first and see all examples available by running `zenml example list`.
* Added ability to specify a `.dockerignore` file before running pipelines on Kubeflow.
* Kubeflow Orchestrator is now leaner and faster. 
* Added the `describe` command group to the CLI for groups `stack`, `orchestrator`, `artifact-store`, and `metadata-store`. E.g. `zenml stack describe`

## Bug fixes and minor improvements
* Adding `StepContext` to a branch now invalidates caching by default. Disable explicitly with `enable_cache=True`.
* Docs updated to reflect minor changes in CLI commands.
* CLI `list` commands now mentions active component. Try `zenml stack list` to check this out.
* `zenml version` now has cooler art.

ZenML 0.5.6 is jam-packed with new features to take your ML pipelines to the next level. In this blog post we will 
highlight our three biggest new features: Kubeflow Pipelines, CLI support for our integrations and Standard Interfaces. That's right, Standard Interfaces are back!

For a detailed look at what's changed, give [our full release
notes](https://github.com/zenml-io/zenml/releases/tag/0.5.6) a glance.

## Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think we should build next!

Keep your eyes open for future releases and make sure to vote on your favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure it gets implemented as soon as possible.

[Photo by <a href="https://unsplash.com/@adigold1?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Adi Goldstein</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]
  