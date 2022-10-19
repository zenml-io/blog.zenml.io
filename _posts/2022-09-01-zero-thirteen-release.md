---
layout: post
author: Dickson Neoh Tze How
title: "What's New in v0.13: Spark, Custom Code Deployment, Stack Recipes, and More"
description: "This release blog describes the changes for three releases v0.13.0 (major release), v0.13.1 and v0.13.2 (minor releases). v0.13.0 brings the first iteration of our Apache Spark integration. v0.13.1 and v0.13.2 includes several bugfixes and quality of life improvements for ZenML users."
category: zenml
tags: zenml release-notes
publish_date: September 21, 2022
date: 2022-09-21T00:02:00Z
thumbnail: /assets/posts/release_0_13_0/combined_zero_thirteen.gif
image:
  path: /assets/posts/release_0_13_0/combined_zero_thirteen.jpg
---

![img]({{ site.url }}/assets/posts/release_0_13_0/combined_zero_thirteen.jpg)

This release blog describes the changes for three releases v0.13.0 (major release), v0.13.1 and v0.13.2 (minor releases). v0.13.0 brings the first iteration of our Apache Spark integration. This integration opens up the possibility of running large-scale workloads on single-node machines or clusters. Additionally, this release also allows you to run custom code along with your models using KServe or Seldon. Lastly, we introduce the Stack Recipe as a convenient way to spin up perfectly configured infrastructure with ease. v0.13.1 and v0.13.2 includes several bugfixes and quality of life improvements for ZenML users.

Version 0.13.0 is chock-full of exciting features:

* [Spark Integration](#-spark-integration) - You can now run Spark jobs within ZenML with the long-awaited Spark integration.
* [Custom Code Deployment](#-custom-code-deployment) - It's now possible to run custom code alongside your model with KServe and Seldon.
* [Stack Recipes](#-spin-up-infrastructure-with-stack-recipes) - We introduce a convenient way to spin up infrastructures using Stack Recipes and how you can extend them to your needs.

View the full release notes [here](https://github.com/zenml-io/zenml/releases/tag/0.13.0).

Version 0.13.1 comes with several quality of life improvements:

* Specify the exact order in which your pipelines steps should be
executed, e.g., via `step_b.after(step_a)`
* It's now possible to use TensorBoard with PyTorch and other modeling frameworks.
* You can now configure the [Evidently integration](https://docs.zenml.io/v/0.13.0/mlops-stacks/data-validators/evidently) to ignore specific columns in 
your datasets. 

View the full release notes [here](https://github.com/zenml-io/zenml/releases/tag/0.13.1).

Version 0.13.2 comes with a new local Docker orchestrator and many other improvements and fixes:

* You can now run your pipelines locally in isolated Docker containers per step. This is useful to test whether the dockerization process will work in remote orchestrators like Kubeflow.
* [@gabrielmbmb](https://github.com/gabrielmbmb) updated our MLflow experiment tracker to work with Databricks deployments.
* Documentation updates for cloud deployments and multi-tenancy Kubeflow support.

View the full release notes [here](https://github.com/zenml-io/zenml/releases/tag/0.13.2).


As always, we've also included various bug fixes and lots of improvements to the documentation and our examples.

## ⚡ Spark Integration
To date, [Spark](https://spark.apache.org/) has been the most requested feature on our [Roadmap](https://zenml.io/roadmap).

We heard you! And in this release, we present to you the long-awaited Spark integration!

With Spark, this release brings distributed processing into the ZenML toolkit. 
You can now run heavy data-processing workloads across machines/clusters as part of your MLOps pipeline and leverage all the distributed processing goodies that come with Spark.

We showcased how to use it in our community meetup on 17th August 2022 👇
<iframe width="560" height="315" src="https://www.youtube.com/embed/ai366Y3UoXY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Run the Spark integration example [here](https://github.com/zenml-io/zenml/tree/main/examples/spark_distributed_programming).

## 🎯 Custom Code Deployment

We continue our streak in supporting [model deployment](2022-03-02-continuous-deployment.md) in ZenML by introducing a feature that allows you to deploy custom code alongside your models on KServe or Seldon.

With this, you can now ship the model with the pre-processing and post-processing code to run within the deployment environment.

We showcased how to deploy custom code with a model during our community meetup on 24th August 2022 
<iframe width="560" height="315" src="https://www.youtube.com/embed/yrvO_fmE520" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Run the example [here](https://github.com/zenml-io/zenml/tree/main/examples/custom_code_deployment).

## 🥘 Spin Up Infrastructure with Stack Recipes

Spinning up and configuring infrastructure is a difficult part of the MLOps journey 
and can easily become a barrier to entry. 

Worry not! Now you don't need to get lost in the infrastructure configuration details. 

Using our [mlops-stacks](https://github.com/zenml-io/mlops-stacks) repository, it is now possible to spin up perfectly-configured infrastructure with
the corresponding ZenML stack using the ZenML CLI.

View the demo recorded during our community meetup on 31st August 2022 👇
<iframe width="560" height="315" src="https://www.youtube.com/embed/9U-jPkufmnE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Check out all the Stack Recipes [here](https://github.com/zenml-io/mlops-stacks).

## 💔 Breaking Changes

This release introduces a breaking change to the CLI by adjusting the access to the stack component-specific resources for secrets managers and 
model deployers to be more explicitly linked to the component. 

Here is how:

```bash
# `zenml secret register ...` becomes 
zenml secrets-manager secret register ...

# `zenml served_models list` becomes 
zenml model-deployer models list
```

## ➕ Other Updates, Additions, and Fixes

### 0.13.0

Model Deployment -
* Update kserve installation to 0.9 on kserve deployment example by [@safoinme](https://github.com/safoinme) in [#823](https://github.com/zenml-io/zenml/pull/823).
* Custom deployment with KServe and Seldon Core by [@safoinme](https://github.com/safoinme) in [#841](https://github.com/zenml-io/zenml/pull/841).
* Fix served models logs formatting error by [@safoinme](https://github.com/safoinme) in [#836](https://github.com/zenml-io/zenml/pull/836).

Spark Integration -
* Spark Integration by [@bcdurak](https://github.com/bcdurak) in [#837](https://github.com/zenml-io/zenml/pull/837).

Tekton Orchestrator -
* Add Tekton orchestrator by [@schustmi](https://github.com/schustmi) in [#844](https://github.com/zenml-io/zenml/pull/844).

Materializer - 
* Pillow Image materializer by [@strickvl](https://github.com/strickvl) in [#820](https://github.com/zenml-io/zenml/pull/820).
* Implement Recursive Built-In Container Materializer by [@fa9r](https://github.com/fa9r) in [#812](https://github.com/zenml-io/zenml/pull/812).

CLI Improvement - 
* Unify CLI concepts (removing `secret`, `feature` and `served-models`) by [@strickvl](https://github.com/strickvl) in [#833](https://github.com/zenml-io/zenml/pull/833).
* Add zenml stack recipe CLI commands by [@wjayesh](https://github.com/wjayesh) in [#807](https://github.com/zenml-io/zenml/pull/807).

Secrets -
* Add secret scoping to the Azure Key Vault by [@stefannica](https://github.com/stefannica) in [#830](https://github.com/zenml-io/zenml/pull/830).
* Secrets references on stack component attributes by [@schustmi](https://github.com/schustmi) in [#817](https://github.com/zenml-io/zenml/pull/817).

README page improvements - 
* Update Readme with latest info from docs page by [@dnth](https://github.com/dnth) in [#810](https://github.com/zenml-io/zenml/pull/810).
* Typo on Readme by [@dnth](https://github.com/dnth) in [#821](https://github.com/zenml-io/zenml/pull/821).
* Put Slack call to action at the top of README page. by [@dnth](https://github.com/dnth) in [#846](https://github.com/zenml-io/zenml/pull/846).

Link checker and broken links -
* Add automated link check github actions by [@dnth](https://github.com/dnth) in [#828](https://github.com/zenml-io/zenml/pull/828).
* Link checker by [@dnth](https://github.com/dnth) in [#818](https://github.com/zenml-io/zenml/pull/818).
* Put link checker as part of CI by [@dnth](https://github.com/dnth) in [#838](https://github.com/zenml-io/zenml/pull/838).
* Fix broken links from link checker results by [@dnth](https://github.com/dnth) in [#835](https://github.com/zenml-io/zenml/pull/835).

Misc -
* Misc bugfixes by [@schustmi](https://github.com/schustmi) in [#842](https://github.com/zenml-io/zenml/pull/842).
* Add missing requirement for step operators by [@schustmi](https://github.com/schustmi) in [#834](https://github.com/zenml-io/zenml/pull/834).
* Change Quickstart to Use Tabular Data by [@fa9r](https://github.com/fa9r) in [#843](https://github.com/zenml-io/zenml/pull/843).
* Add sleep before docker builds in release GH action by [@schustmi](https://github.com/schustmi) in [#849](https://github.com/zenml-io/zenml/pull/849).
* New Docker build configuration by [@schustmi](https://github.com/schustmi) in [#811](https://github.com/zenml-io/zenml/pull/811).
* Improve label studio error messages if secrets are missing or of wrong schema by [@schustmi](https://github.com/schustmi) in [#811](https://github.com/zenml-io/zenml/pull/832).
* Fix the SQL zenstore to work with MySQL by [@stefannica](https://github.com/stefannica) in [#829](https://github.com/zenml-io/zenml/pull/829).
* Allow setting caching via the `config.yaml` by [@strickvl](https://github.com/strickvl) in [#827](https://github.com/zenml-io/zenml/pull/827).
* Handle file-io with context manager by [@aliabbasjaffri](https://github.com/aliabbasjaffri) in [#825](https://github.com/zenml-io/zenml/pull/825).

### 0.13.1

* Fix flag info on recipes in docs by [@wjayesh](https://github.com/wjayesh) in [#854](https://github.com/zenml-io/zenml/pull/854).
* Fix some materializer issues by [@schustmi](https://github.com/schustmi) in [#852](https://github.com/zenml-io/zenml/pull/852).
* Add ignore columns for evidently drift detection by [@SangamSwadiK](https://github.com/SangamSwadiK) in [#851](https://github.com/zenml-io/zenml/pull/851).
* TensorBoard Integration by [@fa9r](https://github.com/fa9r) in [#850](https://github.com/zenml-io/zenml/pull/850).
* Add option to specify task dependencies by [@schustmi](https://github.com/schustmi) in [#858](https://github.com/zenml-io/zenml/pull/858).
* Custom code readme and docs by [@safoinme](https://github.com/safoinme) in [#853](https://github.com/zenml-io/zenml/pull/853).


### 0.13.2

* Update GitHub Actions by [@fa9r](https://github.com/fa9r) in [#864](https://github.com/zenml-io/zenml/pull/864).
* Raise zenml exception when cyclic graph is detected by [@schustmi](https://github.com/schustmi) in [#866](https://github.com/zenml-io/zenml/pull/866).
* Add source to segment identify call by [@htahir1](https://github.com/htahir1) in [#868](https://github.com/zenml-io/zenml/pull/868).
* Use default local paths/URIs for the local artifact and metadata stores by [@stefannica](https://github.com/stefannica) in [#873](https://github.com/zenml-io/zenml/pull/873).
* Implement local docker orchestrator by [@schustmi](https://github.com/schustmi) in [#862](https://github.com/zenml-io/zenml/pull/862).
* Update cheat sheet with latest CLI commands from 0.13.0 by [@dnth](https://github.com/dnth) in [#867](https://github.com/zenml-io/zenml/pull/867).
* Add a note about importing proper DockerConfiguration module by [@jsuchome](https://github.com/jsuchome) in [#877](https://github.com/zenml-io/zenml/pull/877).
* Bugfix/misc by [@schustmi](https://github.com/schustmi) in [#878](https://github.com/zenml-io/zenml/pull/878).
* Fixed bug in tfx by [@htahir1](https://github.com/htahir1) in [#883](https://github.com/zenml-io/zenml/pull/883).
* Mlflow Databricks connection by [@gabrielmbmb](https://github.com/gabrielmbmb) in [#882](https://github.com/zenml-io/zenml/pull/882).
* Refactor cloud guide to stack deployment guide by [@wjayesh](https://github.com/wjayesh) in [#861](https://github.com/zenml-io/zenml/pull/861).
* Add cookie consent by [@strickvl](https://github.com/strickvl) in [#871](https://github.com/zenml-io/zenml/pull/871).
* Stack recipe CLI improvements by [@wjayesh](https://github.com/wjayesh) in [872](https://github.com/zenml-io/zenml/pull/872).
* Kubeflow workaround added by [@htahir1](https://github.com/htahir1) in [#886](https://github.com/zenml-io/zenml/pull/886).


## 🙌 Community Contributions
* [@aliabbasjaffri](https://github.com/aliabbasjaffri) made their first contribution in [#825](https://github.com/zenml-io/zenml/pull/825).
* [@SangamSwadiK](https://github.com/SangamSwadiK) made their first contribution in [#851](https://github.com/zenml-io/zenml/pull/851).


## 👩‍💻 Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know if you have an
idea for a feature or something you'd like to contribute to the framework.

We have a [new home for our roadmap](https://zenml.io/roadmap) where you can vote on your favorite upcoming
feature or propose new ideas for what the core team should work on. You can vote
without needing to log in, so please do let us know what you want us to build!

