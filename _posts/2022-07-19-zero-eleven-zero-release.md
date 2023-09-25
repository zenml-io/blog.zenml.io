---
layout: post
author: Alex Strick van Linschoten
title: "What's New in v0.11.0: Label All The Things!"
description: "This release brings the first iteration of the ZenML annotation stack component and an integration with Label Studio, the popular open-source tool that supports many annotation types. We've also made significant updates to our documentation."
category: zenml
tags: zenml release-notes
publish_date: July 19, 2022
date: 2022-07-19T00:02:00Z
thumbnail: /assets/posts/release_0_11_0/gaelle-marcel-vrkSVpOwchk-unsplash.jpg
image:
  path: /assets/posts/release_0_11_0/gaelle-marcel-vrkSVpOwchk-unsplash.jpg
---

**Last updated:** November 3, 2022.

Our 0.11.0 release contains our new annotation workflow and stack component. We've been blogging [about](https://blog.zenml.io/open-source-data-annotation-tools/) this for a few weeks, and even started maintaining [our own repository](https://github.com/zenml-io/awesome-open-data-annotation) of open-source annotation tools. With ZenML 0.11.0 you can bring data labeling into your MLOps pipelines and workflows as a first-class citizen. We've started our first iteration of this functionality by integrating with [Label Studio](https://labelstud.io/), a leader in the open-source annotation tool space.

This release also includes a ton of updates to our documentation. (Seriously, go check them out! We added tens of thousands of words since the last release.) We continued the work on our data validation story from the previous release: [Deepchecks](https://deepchecks.com/) is the newest data validator we support, and we updated our Evidently and whylogs integrations to include all the latest and greatest from those tools.

Beyond this, as usual we included a number of smaller bugfixes and documentation changes to cumulatively improve experience of using ZenML as a user. For a detailed look at what's changed, give [our full release notes](https://github.com/zenml-io/zenml/releases/tag/0.11.0) a glance.

## 🏷 Data Annotation with Label Studio

We've been hard at work on our new stack component and integration with [Label Studio](https://labelstud.io/), the first of our data annotation tools. 🥳

![Object Detection with ZenML and Label Studio]({{ site.url }}/assets/posts/release_0_11_0/label-studio-integration.png)

Annotators are a stack component that enables the use of data annotation as part of your ZenML stack and pipelines. You can use the associated CLI command to launch annotation, configure your datasets and get stats on how many labeled tasks you have ready for use.

Data annotation/labeling is a core part of MLOps that is frequently left out of the conversation. With this release, ZenML now supports annotation as an integrated and first-class citizen as part of the MLOps lifecycle.

Got feedback or just want to let us know how you feel? [Connect with us](https://zenml.io/slack-invite/) or join us for a [Community Meetup](https://www.eventbrite.de/e/zenml-meet-the-community-tickets-354426688767) 👋 which happens every Wednesday!

## 🔎 More Data Validation with Deepchecks, Evidently & whylogs

We continued the work started in the previous release, adding a new integration with [Deepchecks](https://deepchecks.com/). Deepchecks is a feature-rich data validation open-source library to painlessly do data validation. Deepchecks can do a variety of data validation tasks, from data integrity checks that work with a single dataset to data+model evaluation to data drift analyses. All this can be done with minimal configuration input from the user, or customized with specialized conditions that the validation checks should perform. Check out [our example](https://docs.zenml.io/stacks-and-components/component-guide/data-validators/deepchecks) if you want to see it in action!

We also updated our integrations with Great Expectations, Evidently and whylogs to support their latest releases. These tools have added lots of great new features in recent weeks and we now support most of them, all under the new data validator stack component and abstraction.

## 📖 Documentation & User Guides

We made a significant overhaul of our documentation since the last release:

- The developer guide section is reworked to be more complete and beginner-friendly
- We wrote a whole new 'MLOps stack' section, which contains detailed explanations for all MLOps stack components and their various implementations in ZenML
- A new 'Cloud Guide' section contains complete setup guides for multiple cloud stacks. This will help you get started quickly.
- We added [a new ZenML cheatsheet](https://storage.googleapis.com/zenml-public-bucket/zenml_cheat_sheet.pdf) that you can use to remind you of important CLI commands.

## ⌨️ CLI Improvements

We fixed a bug that was preventing users who upgraded to 0.10.0 from pulling new examples. This now works without any problem.

## ➕ Other Updates, Additions and Fixes

The latest release includes several smaller features and updates to existing functionality:

- We fixed a bug in our Feast integration that prevented registration as a stack component.
- We updated the structure of all our examples so that they now conform to all of [the 'best practices' guidance](https://docs.zenml.io/v/0.11.0/resources/best-practices) we've made available in our docs.
- We fixed some module and path resolution errors that were happening for Windows users.
- We have combined all the MetadataStore contexts to speed up calls to the metadata store. This speeds up pipeline execution.
- We now prevent providing extra attributes when initializing stack components. This could have led to unexpected behaviors so we now just prevent this behavior.
- We've built several new Docker images. You can view them all over at [dockerhub](https://hub.docker.com/r/zenmldocker/zenml/tags).
- The facets magic display now works on Google Colab.
- Our Azure Secret Schema now works with the secrets manager. An issue with how Azure handles secret names was preventing this, but we encoded the secret names to get around this shortcoming on the Azure platform.
- @Val3nt-ML added a nested MLflow parameter (on the `@enable_mlflow` decorator) which will allow the creation of nested runs for each step of a ZenML pipeline in MLflow.
- We enabled the fetching of secrets from within a step.
- We now allow the fetching of pipelines and steps by name, class or instance.
- You can now also add optional machine specs to VertexAI orchestrators, thanks to a PR from @felixthebeard.
- We fixed a bug that was preventing users from importing pipeline requirements via a `requirements.txt` file if the file ended with a newline.

## Breaking Changes

The 0.11.0 release remodels the Evidently and whylogs integrations as Data Validator stack components, in an effort to converge all data profiling and validation libraries around the same abstraction. As a consequence, you now need to configure and add a Data Validator stack component to your stack if you wish to use Evidently or whylogs in your pipelines:

* for Evidently:

    ```shell
    zenml data-validator register evidently -f evidently
    zenml stack update -dv evidently
    ```

* for whylogs:

    ```shell
    zenml data-validator register whylogs -f whylogs
    zenml stack update -dv whylogs
    ```

In this release, we have also upgraded the Evidently and whylogs libraries to their latest and greatest versions (whylogs 1.0.6 and evidently 0.1.52). These versions introduce non-backwards compatible changes that are also reflected in the ZenML integrations:

* Evidently profiles are now materialized using their original `evidently.model_profile.Profile ` data type and the builtin `EvidentlyProfileStep` step now also returns a `Profile` instance instead of the previous dictionary representation. This may impact your existing pipelines as you may have to update your steps to take in `Profile` artifact instances instead of dictionaries.

* the whylogs `whylogs.DatasetProfile` data type was replaced by `whylogs.core.DatasetProfileView` in the builtin whylogs materializer and steps. This may impact your existing pipelines as you may have to update your steps to return and take in `whylogs.core.DatasetProfileView` artifact instances instead of `whylogs.DatasetProfile` objects.

* the whylogs library has gone through a major transformation that completely removed the session concept. As a result, the `enable_whylogs` step decorator was replaced by an `enable_whylabs` step decorator. You only need to use the step decorator if you wish to log your profiles to the Whylabs platform.

Please refer to the examples provided for Evidently and whylogs to learn more about how to use the new integration versions:

* [Evidently](https://docs.zenml.io/stacks-and-components/component-guide/data-validators/evidently)
* [whylogs/Whylabs](https://docs.zenml.io/stacks-and-components/component-guide/data-validators/whylogs)

## 🙌 Community Contributions

We received several new community contributions during this release cycle. Here's everybody who contributed towards this release:

* [@jsuchome](https://github.com/jsuchome) made their first contribution in https://github.com/zenml-io/zenml/pull/740
* [@Val3nt-ML](https://github.com/Val3nt-ML) made their first contribution in https://github.com/zenml-io/zenml/pull/742
* [@felixthebeard](https://github.com/felixthebeard) contributed a PR to allow
  for optional machine specs to be passed in for the VertexAI orchestrator in https://github.com/zenml-io/zenml/pull/762

## 👩‍💻 Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know if you have an
idea for a feature or something you'd like to contribute to the framework.

We have a [new home for our roadmap](https://zenml.io/roadmap) where you can vote on your favorite upcoming
feature or propose new ideas for what the core team should work on. You can vote
without needing to log in, so please do let us know what you want us to build!

[Photo by <a href="https://unsplash.com/@gaellemarcel?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Gaelle Marcel</a> on <a href="https://unsplash.com/s/photos/balloons?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]
