---
layout: post
author: Dickson Neoh Tze How
title: "What's New in v0.13.0 and v0.13.1: Spark Integration, Custom Code Deployment and Stack Recipes!"
description: "This release brings the first iteration of Apache Spark integration into ZenML. This integration opens up the possibility of running large-scale workloads on single-node machines or clusters. Additionally, this release also opens up the possibility of running custom code along with your models using KServe or Seldon. Lastly, we introduce the Stack Recipe as a convenient way to spin up perfectly configured infrastructure with ease."
category: zenml
tags: zenml release-notes
publish_date: September 01, 2022
date: 2022-09-01T00:02:00Z
thumbnail: /assets/posts/release_0_13_0/zero-thirteen-zero-release.jpg
image:
  path: /assets/posts/release_0_13_0/zero-thirteen-zero-release.jpg
---

![img](/assets/posts/release_0_13_0/zero-thirteen-zero-release.jpg)

ZenML version 0.13.0 is chock-full with exciting features including:

* You can now run Spark jobs within ZenML with the long awaited Spark integration.
* It's now possible to run custom code alongside your model with KServe and Seldon.
* We introduce a convenient way to spin up infrastructures with Stack Recipes.

![img](/assets/posts/release_0_13_0/zero-thirteen-one-release.jpg)

ZenML 0.13.1 comes with several quality of life improvements:

* Specify the exact order in which your pipelines steps should be
executed, e.g., via `step_b.after(step_a)`
* It's now possible to use TensorBoard with PyTorch and other modeling frameworks.
* You can now configure the Evidently integration to ignore specific columns in 
your datasets. 

As always, we've also included various bug fixes and lots of improvements to the documentation and our examples.

## ⚡ Spark Integration
To date, [Spark](https://spark.apache.org/) has been the most requested feature on our [Roadmap](https://zenml.io/roadmap).

We heard you! And in this release, we present to you the long-awaited Spark integration!

With Spark, this release brings distributed processing into the ZenML toolkit. You can now run heavy data processing workloads across machines/clusters as part of your MLOps pipeline.

View the demo recorded during our community meetup on 17th August 2022 👇
<iframe width="560" height="315" src="https://www.youtube.com/embed/ai366Y3UoXY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Run the example [here](https://github.com/zenml-io/zenml/tree/main/examples/spark_distributed_programming).

## 🎯 Custom Code Deployment

[Custom Code Deployment](https://github.com/zenml-io/zenml/tree/main/examples/custom_code_deployment) is the
continuation of the [Model Deployment](2022-03-02-continuous-deployment.md) story that we have been working on over the last few releases. 
Now it is possible to [deploy custom code along with your models using KServe or Seldon](2022-08-03-deploy-with-kserve.md).

View the demo recorded during our community meetup on 24th August 2022 👇
<iframe width="560" height="315" src="https://www.youtube.com/embed/yrvO_fmE520" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Run the example [here](https://github.com/zenml-io/zenml/tree/main/examples/custom_code_deployment).


## 🥘 Spin Up Infrastructure with Stack Recipes

Spinning up and configuring infrastructure is a difficult part of the MLOps journey 
and can easily become a barrier to entry. Using our [mlops-stacks](https://github.com/zenml-io/mlops-stacks)
repository, it is now possible to spin up perfectly-configured infrastructure with
the corresponding ZenML stack using the ZenML CLI.

View the demo recorded during our community meetup on 31st August 2022 👇
<iframe width="560" height="315" src="https://www.youtube.com/embed/9U-jPkufmnE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Check out all the Stack Recipes [here](https://github.com/zenml-io/mlops-stacks).

## 💔 Breaking Changes

This release introduces a breaking change to the CLI by adjusting the access to
the stack component specific resources for `secret-managers` and 
`model-deployers` to be more explicitly linked to the component. Here is how:

```bash
# `zenml secret register ...` becomes 
zenml secrets-manager secret register ...

# `zenml served_models list` becomes 
zenml model-deployer models list
```

## ➕ Other Updates, Additions, and Fixes

### 0.13.0

* Link checker by @dnth in https://github.com/zenml-io/zenml/pull/818
* Update Readme with latest info from docs page by @dnth in https://github.com/zenml-io/zenml/pull/810
* Typo on Readme by @dnth in https://github.com/zenml-io/zenml/pull/821
* Update kserve installation to 0.9 on kserve deployment example by @safoinme in https://github.com/zenml-io/zenml/pull/823
* Allow setting caching via the `config.yaml` by @strickvl in https://github.com/zenml-io/zenml/pull/827
* Handle file-io with context manager by @aliabbasjaffri in https://github.com/zenml-io/zenml/pull/825
* Add automated link check github actions by @dnth in https://github.com/zenml-io/zenml/pull/828
* Fix the SQL zenstore to work with MySQL by @stefannica in https://github.com/zenml-io/zenml/pull/829
* Improve label studio error messages if secrets are missing or of wrong schema by @schustmi in https://github.com/zenml-io/zenml/pull/832
* Add secret scoping to the Azure Key Vault by @stefannica in https://github.com/zenml-io/zenml/pull/830
* Unify CLI concepts (removing `secret`, `feature` and `served-models`) by @strickvl in https://github.com/zenml-io/zenml/pull/833
* Put link checker as part of CI by @dnth in https://github.com/zenml-io/zenml/pull/838
* Add missing requirement for step operators by @schustmi in https://github.com/zenml-io/zenml/pull/834
* Fix broken links from link checker results by @dnth in https://github.com/zenml-io/zenml/pull/835
* Fix served models logs formatting error by @safoinme in https://github.com/zenml-io/zenml/pull/836
* New Docker build configuration by @schustmi in https://github.com/zenml-io/zenml/pull/811
* Secrets references on stack component attributes by @schustmi in https://github.com/zenml-io/zenml/pull/817
* Misc bugfixes by @schustmi in https://github.com/zenml-io/zenml/pull/842
* Pillow Image materializer by @strickvl in https://github.com/zenml-io/zenml/pull/820
* Add Tekton orchestrator by @schustmi in https://github.com/zenml-io/zenml/pull/844
* Put Slack call to action at the top of README page. by @dnth in https://github.com/zenml-io/zenml/pull/846
* Change Quickstart to Use Tabular Data by @fa9r in https://github.com/zenml-io/zenml/pull/843
* Add sleep before docker builds in release GH action by @schustmi in https://github.com/zenml-io/zenml/pull/849
* Implement Recursive Built-In Container Materializer by @fa9r in https://github.com/zenml-io/zenml/pull/812
* Custom deployment with KServe and Seldon Core by @safoinme in https://github.com/zenml-io/zenml/pull/841
* Spark Integration by @bcdurak in https://github.com/zenml-io/zenml/pull/837
* Add zenml stack recipe CLI commands by @wjayesh in https://github.com/zenml-io/zenml/pull/807

### 0.13.1

* Fix flag info on recipes in docs by @wjayesh in https://github.com/zenml-io/zenml/pull/854
* Fix some materializer issues by @schustmi in https://github.com/zenml-io/zenml/pull/852
* Add ignore columns for evidently drift detection by @SangamSwadiK in https://github.com/zenml-io/zenml/pull/851
* TensorBoard Integration by @fa9r in https://github.com/zenml-io/zenml/pull/850
* Add option to specify task dependencies by @schustmi in https://github.com/zenml-io/zenml/pull/858
* Custom code readme and docs by @safoinme in https://github.com/zenml-io/zenml/pull/853


## 🙌 Community Contributions
* @aliabbasjaffri made their first contribution in https://github.com/zenml-io/zenml/pull/825
* @SangamSwadiK made their first contribution in https://github.com/zenml-io/zenml/pull/851


## 👩‍💻 Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know if you have an
idea for a feature or something you'd like to contribute to the framework.

We have a [new home for our roadmap](https://zenml.io/roadmap) where you can vote on your favorite upcoming
feature or propose new ideas for what the core team should work on. You can vote
without needing to log in, so please do let us know what you want us to build!

