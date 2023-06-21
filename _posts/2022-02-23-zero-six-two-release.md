---
layout: post
author: Alex Strick van Linschoten
title: "What's New in v0.6.2: ♻️ Continuous Deployment and a fresh CLI 👩‍💻"
description: "Release notes for the new version of ZenML. We've added the ability to serve models using MLflow deployments, and we've refreshed how our CLI looks using the popular 'rich' library. You'll also find a lot of smaller improvements, documentation additions and bug fixes in this release."
category: zenml
tags: zenml release-notes
publish_date: February 23, 2022
date: 2022-02-23T00:02:00Z
thumbnail: /assets/posts/release_0_6_2/hybrid-uGP_6CAD-14-unsplash.jpg
image:
  path: /assets/posts/release_0_6_2/hybrid-uGP_6CAD-14-unsplash.jpg
---

**Last updated:** November 3, 2022.

ZenML 0.6.2 brings you the ability to serve models using MLflow deployments as well as an updated CLI interface! For a real continuous deployment cycle, we know that ZenML pipelines should be able to handle everything — from pre-processing to training to serving to monitoring and then potentially re-training and re-serving. The interfaces we created in this release are the foundation on which all of this will build.

We also improved how you interact with ZenML through the CLI. Everything looks so much smarter and readable now with the popular `rich` library integrated into our dependencies.

Smaller changes that you'll notice include updates to our cloud integrations and bug fixes for Windows users. For a detailed look at what's changed, give [our full release notes](https://github.com/zenml-io/zenml/releases/tag/0.6.2) a glance.

## ♻️ Continuous Deployment with MLflow

![A Continuous Deployment workflow. Achievement unlocked!]({{ site.url }}/assets/posts/release_0_6_2/ZenML0-6-2.gif)

The biggest new feature in the 0.6.2 release is our integration with the parts of MLflow that allow you to serve your models. We [previously added MLflow Tracking](https://blog.zenml.io/zero-five-seven-release/), but now hook into the standard format for packaging machine learning models so that you can deploy them for real-time serving using a range of deployment tools. With the new integration you can locally deploy your models [using a local deployment server](https://mlflow.org/docs/latest/models.html#deploy-mlflow-models).

This is the foundation for the obvious next useful step: non-local deployments using tools like [KServe](https://github.com/kserve/kserve) and [BentoML](https://github.com/bentoml/BentoML). ([Community votes](https://github.com/zenml-io/zenml/discussions/215) on that directed us first towards MLflow, but we realize that there are several other options that are commonly used.)

As part of this new feature, we added a new concept of a 'service'. The service extends the paradigm of a ZenML pipeline to now cover long-running processes or workflows; you are no longer limited to executing run-to-completion pipelines or mini-jobs. With services you can therefore serve the an artifact created by a pipeline and have it reflected in a running component that you can interact with after-the fact. For machine learning, this is what gives us continuous model deployment.

The MLflow deployment integration means you can implement a workflow — for example — where you train a model, make some decision based on the results (perhaps you evaluate the best model) and immediately see the model updated in production as a prediction service.

We're really excited about the production use cases that this feature enables. To learn more, check out [the new documentation page](https://zenml.io/features/ct-cd) we just included to guide you in understanding continuous training and continuous deployment. The [`mlflow_deployment` example](https://github.com/zenml-io/zenml/tree/main/examples) is also a great way to understand how to use this new feature. ([Use the CLI](https://blog.zenml.io/examples-cli/) to explore and interact with the examples.)

## Improving our CLI with `rich`

![Our CLI tables look much nicer with 'rich']({{ site.url }}/assets/posts/release_0_6_2/rich-tables.jpeg)

If you've been using the ZenML CLI utility for a while, you'll know that it was functional but maybe not always *delightful*. We've [taken a bit of time](https://github.com/zenml-io/zenml/pull/392) to make it more pleasant to use from the user perspective. We used 'rich' to add a visual uplift to most user-facing parts of the `zenml` terminal interface. 

Tables are easier to read, spinners conceal log messages that you didn't really need to see, and tracebacks from errors raised while using ZenML are now much more feature-filled and easy to parse. Now that we've added `rich` into our dependencies it will be easier to continually improve the CLI going forward.

We'll be writing more about how we integrated with `rich` on the blog in the coming days, so stay tuned for that!

## 🗒 Documentation Updates

As the codebase and functionality of ZenML grows, we always want to make sure [our documentation](https://docs.zenml.io/) is clear, up-to-date and easy to use. We made a number of changes in this release that will improve your experience in this regard:

- Ensure *quickstart* example code is identical across everywhere it is referenced.
- Added core concepts back into the [main glossary](https://docs.zenml.io/) (sorted alphabetically and made concise).
- Added [cloud-specific guide](https://docs.zenml.io/) for deploying pipelines.
- Inside the codebase itself, removed some parameters specified in docstrings that no longer existed in code.
- Various spelling and typo corrections.

## ➕ Other Updates, Additions and Fixes

- Our test suite is now more robust. We run our integration tests on `kubeflow` (as well as on the local stack), and integration tests run in separate virtual environments for each integration test.
- We added [some extra parts](https://github.com/zenml-io/zenml/pull/411) to our PR template, which you'll reach when you contribute to the ZenML codebase.
- We fixed a bug where the CLI wasn't working if you didn't have `git` already installed. (This mainly applies to Windows machines, and our bug fix doesn't apply to any of the `zenml example…` functionality, since that requires `git`.)
- Added various logging and informative error messages for edge cases.
- [Fixed a bug](https://github.com/zenml-io/zenml/pull/416) where an IPython REPL would crash when running examples or code that visualized data.
- We now automatically activate integrations when we are unable to find stack components.
- We now [handle the failure](https://github.com/zenml-io/zenml/pull/390) of workflows for cases where `ModuleNotFound` errors are raised.

## 🙌 Community Contributions

We received [a contribution](https://github.com/zenml-io/zenml/pull/422) from [Rasmus Halvgaard](https://github.com/halvgaard), in which he fixed a number of documentation errors and redundancies in our codebase. Thank you, Rasmus!

## Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think we should build next!

Keep your eyes open for future releases and make sure to vote on your favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure it gets implemented as soon as possible.

[Photo by <a href="https://unsplash.com/@artbyhybrid?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Hybrid</a> on <a href="https://unsplash.com/s/photos/balloons?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]