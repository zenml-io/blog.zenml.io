---
layout: post
author: James W. Browne
title: "What's New in v0.7.0: 🔡 User Profiles and Secret Storage 🤫"
description: "Release notes for the new version of ZenML. We've added the
  ability to store your stacks in profiles accessible system-wide instead of
  just in individual project folders. We also added a way to store and retrieve
  passwords and secrets, including the possibility to integrate the AWS Secrets
  Manager. Also: run individual steps on Vertex AI."
category: zenml
tags: zenml release-notes
publish_date: March 28, 2022
date: 2022-03-28T00:02:00Z
thumbnail: /assets/posts/release_0_7_0/balloons.jpg
image:
  path: /assets/posts/release_0_7_0/balloons.jpg
---

With ZenML 0.7.0, a lot has been revamped under the hood about how things are
stored. Importantly what this means is that ZenML now has system-wide profiles
that let you register stacks to share across several of your projects! If you
still want to manage your stacks for each project folder individually, profiles
let you continue to do that as well.

Most projects of any complexity will require passwords or tokens to access data
and infrastructure, and for this purpose ZenML 0.7.0 introduces the Secrets
Manager stack component to seamlessly pass around these values to your steps.
Our AWS integration also allows you to use AWS Secrets Manager as a backend to
handle all your secret persistence needs.

Finally, in addition to the new AzureML and Sagemaker Step Operators that
[version 0.6.3](zero-six-three-release) brought, this release also
adds the ability to run individual steps on GCP's Vertex AI.

Beyond this, some smaller bugfixes and documentation changes combine to make
ZenML 0.7.0 a more pleasant user experience. For a detailed look at what's
changed, give [our full release notes](https://github.com/zenml-io/zenml/releases/tag/0.7.0)
a glance.

## 🗿 Profiles and Global Stack Storage

Ever wanted to use the same stack configuration in multiple projects? Well now
you can! ZenML 0.7.0 moves the storage of stack configurations out of the `.zen`
folder inside of each individual project and into the system-wide ZenML
application configuration folder. What this means is you can now interact with
ZenML using CLI commands from anywhere, not just in zen repository projects
with a `.zen` folder. Adding a new stack component, for instance an
orchestrator using
```sh
zenml orchestrator register kubeflow_orchestrator --type=kubeflow
```
means that this orchestrator will now be available to use in any ZenML projects
on your local machine.

Still want separation of concerns with isolated environments for each project?
This is where profiles come in. You can now register a new profile using:

```sh
zenml profile create NEW_PROFILE_NAME
zenml profile activate NEW_PROFILE_NAME
```

This provides you with a completely fresh environment that only has the default
local stack pre-registered, where you can work without disturbing other
profiles or projects. You can specify both globally and on a project (folder)
level which profile to default to using. For ease of transition, any legacy ZenML
repositories (projects) will automatically be migrated to a new isolated
profile so you can maintain the separation you are used to:

![Migration of Legacy Profiles]({{ site.url }}/assets/posts/release_0_7_0/legacy-migration.png)

## 🔑 Secret Management

Most projects of a certain complexity or using cloud infrastructure will
involve secrets of some kind. You use secrets, for example, when connecting to
AWS. These secrets, in this case the `access_key_id` and `secret_access_key`,
are usually stored in the `~/.aws/credentials` file. You might find you need to
access those secrets from within your Kubernetes cluster as it runs individual
steps, or you might just want a centralized location for the storage of secrets
across your project. As of this release, ZenML offers a basic
[local secrets manager](https://docs.zenml.io/v/0.7.0/features/secrets) and an
integration with the managed [AWS Secrets Manager](https://aws.amazon.com/secrets-manager).

This now lets you easily specify secrets as dependencies for pipelines from
the decorator:

```python
@pipeline(required_integrations=[TENSORFLOW], secrets=["aws"], enable_cache=True)
def mnist_pipeline(importer, normalizer, trainer, evaluator):
    """Steps that require access to an AWS account here"""
```

## ➕ Other Updates, Additions and Fixes

Google Cloud's Vertex AI is now available as a step operator to run individual
steps of your pipeline in the cloud. Simply register it as you would any other
stack component from the CLI:

```bash
zenml step-operator register vertex \
    --type=vertex \
    --project=zenml-core \
    --service_account_path=... \
    --region=europe-west1 \
    --machine_type=n1-standard-4 \
    --base_image=<CUSTOM_BASE_IMAGE> \
    --accelerator_type=...
```

 More details about the parameters that you can configure can be found in the
 class definition of Vertex Step Operator in the [API docs](https://apidocs.zenml.io/0.7.0/api_docs/integrations/#zenml.integrations.vertex.step_operators.vertex_step_operator).

Another change addresses the fact that while in most cases
[materializers](https://docs.zenml.io/guides/functional-api/materialize-artifacts)
should be used to control how artifacts are consumed and output from steps in a
pipeline, there is sometimes a need to have a completely non-materialized
artifact in a step. ZenML now provides this option of
[bypassing materialization](https://docs.zenml.io/v/0.7.0/guides/index/skip-materialization).


## 🙌 Community Contributions

We received [a contribution](https://github.com/zenml-io/zenml/pull/485) from
[Avram](https://github.com/avramdj), in which he fixed a typo in our
documentation. Thank you, Avram!

## Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think
we should build next!

Keep your eyes open for future releases and make sure to
[vote](https://github.com/zenml-io/zenml/discussions/categories/roadmap) on
your favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure
it gets implemented as soon as possible.

[Photo by <a href="https://unsplash.com/@ninjason?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Jason Leung</a> on <a href="https://unsplash.com/s/photos/balloon?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>] 
