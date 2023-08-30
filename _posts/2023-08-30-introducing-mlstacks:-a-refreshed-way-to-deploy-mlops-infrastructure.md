---
layout: post
author: "Alex Strick van Linschoten"
title: "Introducing mlstacks: a refreshed way to deploy MLOps infrastructure"
description: "Introducing mlstacks: a refreshed way to deploy MLOps infrastructure"
category: zenml
tags: mlstacks production mlops zenml evergreen tooling
publish_date: August 30, 2023
date: 2023-08-30T08:05:51Z
thumbnail: /assets/posts/mlstacks/mlstacks_logo.png
image:
  path: /assets/posts/mlstacks/mlstacks_logo.png
---
**Last updated:** August 30, 2023

We're excited to launch [the new `mlstacks` Python package](https://mlstacks.zenml.io). MLStacks builds on
the work done to create Stack Recipes, allowing you to quickly spin up MLOps
infrastructure using Terraform. It is designed to be used with ZenML, but can be
used with any MLOps tool or platform.

You can use `mlstacks` [directly as a Python package](https://pypi.org/project/mlstacks/), deploying infrastructure
with the CLI after defining your stacks in YAML. Alternatively, you can let
ZenML handle writing the stack and component specification files by [using the
ZenML CLI](https://docs.zenml.io/stacks-and-components/stack-deployment) to define which components you want to deploy. We currently support
modular MLOps stacks on AWS, GCP and K3D (for local use).

We reworked the previous way of doing things to be more stable and reliable. We
even added new features like the ability to get a cost estimate for your MLOps
stacks. MLStacks is also designed to be able to work as a standalone deployment
option independent of ZenML. All of this is available in the new `mlstacks`
Python package and with ZenML's latest release (0.44.0).

## How can I try it out?

To use `mlstacks` directly you'll want to create .yaml files to define your
stack and the individual components in your stack. (Examples of how to do this
can be found in [the dedicated `mlstacks` documentation
site.](https://mlstacks.zenml.io/getting-started/quickstart))

<div style="position: relative; padding-bottom: 65.0994575045208%; height: 0;"><iframe src="https://www.loom.com/embed/1a37379a5e1c463d914041b9124afa78?sid=feaf1422-708a-442c-9cd6-a6814858d4d9" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>

Using `mlstacks` with ZenML is easier as you aren't required to define your
stacks and components in .yaml files; ZenML handles all of that for you. As a
quick example, you can run:

```bash
zenml stack deploy -p gcp -a -n my_mlstacks_stack -r us-east1 -t env=dev -x bucket_name=my-new-bucket -x project_id=zenml
```

This would deploy a stack to GCP that has an artifact store created for you in
the `us-east1` region. It will also import that stack (with the name
`my_mlstacks_stack`) into ZenML ready for you to use.

<div style="position: relative; padding-bottom: 65.0994575045208%; height: 0;"><iframe src="https://www.loom.com/embed/cf73550229ce488eba6c071b7c61b1f4?sid=2d428b25-8e8d-4711-8c24-a6c6c1292b54" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>

Most of the examples shown here are fairly simple as they allow you to try
things out without needing to wait for too long or to incur significant cloud
costs, but you're encouraged to try it out for stacks that suit your needs!

## How it works

<div style="position: relative; padding-bottom: 89.99999999999999%; height: 0;"><iframe src="https://www.loom.com/embed/4fd5c428728b4f729234cb4c96f8d5a5?sid=cf73a6c1-b099-4723-8e19-31ff3f09625f" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div>

MLStacks works by taking stack and component specification files and parsing
them into Terraform files which are in turn deployed to your cloud (or local, in
the case of `k3d`) infrastructure. Our Python package will validate your
specification files to ensure that you're not using invalid or unsupported
combinations of components.

![](/assets/posts/mlstacks/mlstacks.jpg)

If you find something that we don't yet support but that you need for your work,
we encourage you to contribute to the project!

When using `mlstacks` through ZenML, you don't have to do the work of writing
the stack specification .yaml files. You simply need to compose the CLI command
that specifies which components you need in your stack.

![](/assets/posts/mlstacks/zenml-with-mlstacks.jpg)

We're working to provide other (easier) ways to deploy your infrastructure using
ZenML but for now CLI deployments offer all the flexibility of the `mlstacks`
package without the need to write your own stack and component specifications!

## Try it out!

We encourage you to try out `mlstacks` and to deploy MLOps stacks, either
through ZenML or by writing your own stack specifications. Full guides for both
options are available in our documentation:

- To spin up infrastructure using ZenML, [start with our
  introduction](https://docs.zenml.io/stacks-and-components/stack-deployment/deploy-a-stack-component)
  to deploying individual stack components via the CLI
- To try out `mlstacks` directly and see how easy it is to specify your stacks
  using the .yaml specification files, [check out one of our QuickStart
  guides](https://mlstacks.zenml.io/getting-started/quickstart) appropriate to
  your favorite cloud platform (or use the `k3d` guide to test deployment
  locally)

We'd love to hear your feedback, good and bad! Please [let us
know](https://zenml.io/slack-invite) how you got on with `mlstacks` [in
Slack](https://zenml.io/slack-invite). Happy deploying!
