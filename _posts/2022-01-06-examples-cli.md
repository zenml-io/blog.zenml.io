---
layout: post
author: Alex Strick van Linschoten
title: Get to know ZenML through examples
description:
  "ZenML has a treasure-trove of examples available for users to get to know
  specific features. Using these examples, running them and pulling refreshed
  versions is easy with our CLI that takes on the heavy work for you."
category: zenml
tags: zenml pipelines tooling applied-zenml evergreen
publish_date: January 6, 2022
date: 2022-01-06T00:02:00Z
thumbnail: /assets/posts/examples-cli/cli.png
image:
  path: /assets/posts/examples-cli/cli.png
  # height: 1910
  # width: 1000
---

As ZenML continues to grow, we'll be
[adding more features and integrations](https://github.com/zenml-io/zenml/releases).
Alongside whatever new things get added to the codebase, we work hard to make
[our documentation](https://docs.zenml.io/) a complete reference for anyone
trying to get up to speed quickly. For those of you who prefer a more hands-on
approach, [our examples](https://github.com/zenml-io/zenml/tree/main/examples)
might be better suited.

Right now you can find the following small, practical ways to experiment with
ZenML pipelines:

## Use Case / Workflow Guides

- **class_based_api**: All the code for the class-based API guide found in the
  [docs](https://docs.zenml.io/v/0.5.7/guides/class-based-api).
- **functional_api**: All the code for the functional API guide found in the
  [docs](https://docs.zenml.io/v/0.5.7/guides/functional-api).
- **caching**: Using caching to skip data-intensive tasks and save costs.
- **not_so_quickstart**: Shows of the modularity of the pipelines with
  hot-swapping of TensorFlow, PyTorch, and scikit-learn trainers.
- **quickstart**: The official quickstart tutorial.
- **standard_interfaces**: Uses a collection of built-in and integrated standard
  interfaces to showcase their effect on the overall smoothness of the user
  experience.

## Orchestrators

- **airflow_local**: Running pipelines with Airflow locally.
- **kubeflow**: Shows how to orchestrate a pipeline a local Kubeflow stack.

## Visualization

- **dag_visualizer**: Visualizing a pipeline.
- **lineage**: Visualizing a pipeline run and showcasing artifact lineage.
- **statistics**: Automatically extract statistics using facets.

You don't even need to clone our repository to get the goodness of examples! Use
the series of commands that begin with `zenml example` to download and even run
examples. (UPDATE: As of November 2022 we have lots more examples covering the
integrations that have been written in the intervening period since this blog
was written.)

Get the full list of examples available:

```bash
zenml example list
```

Pick an example to download into your current working directory:

```bash
zenml example pull quickstart
# at this point a `zenml_examples` dir would be created with the example(s) inside it
```

When you're ready to run the example, simply type the following command. If
there are any dependencies needed to be downloaded for the example to run, the
CLI will prompt you to install them.

```bash
zenml example run quickstart
```

It's that easy to get started with some examples of ZenML in action! Visit
[our guides and walkthroughs](https://docs.zenml.io/) for longer examples
showcasing some longer use cases.

The ZenML core team originally started discussing adding the `example run`
command as a way of including test runs of our examples as part of our
continuous integration that Github Actions invokes whenever merging to `main`.
It was only later that we saw how it might also be a useful option for users to
be able to run the examples with very little setup or configuration needs.

If you're inspired by our examples to create your own, feel free to let us know
by [creating an issue here](https://github.com/zenml-io/zenml/issues) on our
GitHub or by reaching out to us [on Slack](https://zenml.io/slack-invite/).
