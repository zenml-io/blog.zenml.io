---
layout: post
author: Dickson Neoh
title: "ZenML 0.23.0: Neptune.ai Integration and Performance Optimization!"
description: "This release comes with a new neptune.ai integration and a huge performance boost by optimizing server API calls!"
category: zenml
tags: zenml release-notes
publish_date: December 05th, 2022
date: 2022-12-05T00:02:00Z
thumbnail: /assets/posts/release_0_23_0/Release_0.23.0.gif
image:
  path: /assets/posts/release_0_23_0/Release_0.23.0.jpg
---

**Last updated:** December 05, 2022.

![Release 0.23.0](../assets/posts/release_0_23_0/Release_0.23.0.jpg)

Let's dive right into the changes.

## 🪐 neptune.ai Integration
The biggest new we have for you this release is the new [neptune.ai](https://neptune.ai/) integration!

This integration includes an experiment tracker component that allows you to track your machine learning experiments
using neptune.ai.

## 🚀 Performance Optimization

This release brings about a huge boost in performance! What used to take minutes now takes seconds to complete.
We did this by significantly reducing the amount of server calls.
The huge performance boost is obvious in the now blazing fast CLI and [ZenML Dashboard](https://github.com/zenml-io/zenml-dashboard).


## 🙌 So long, PyArrow

We've removed PyArrow as a dependency of the `zenml` Python package.

As a consequence of that, our `NumPy` and `Pandas` materializer no
longer read and write their artifacts using PyArrow but instead use
native formats instead. 

If you still want to use `PyArrow` to serialize
your `NumPy` arrays and `Pandas` dataframes, you'll need to install it manually with 

```bash
pip install pyarrow
```

This results in a slimmer and lighter version of `zenml`.
In our upcoming releases, we aim to remove more unnecessary dependencies to slim down the `zenml` package even further.


## 💔 Breaking Changes

The following changes introduces with this release mey require some manual
intervention to update your current installations:

- If your code calls some methods of our `Client` class, it might need to be
updated to the new model classes introduced by the performance optimization changes
explained above
- The CLI command to remove an attribute from a stack component now takes no more dashes
in front of the attribute names:
`zenml stack-component remove-attribute <COMPONENT_NAME> <ATTRIBUTE_NAME>`
- If you're using a custom stack component and have overridden the `cleanup_step_run` method,
you'll need to update the method signature to include a `step_failed` parameter.

For minor changes view the release note [here](https://github.com/zenml-io/zenml/releases/tag/0.23.0).

## 🤗 New Contributors and Acknowledgment

We are grateful to have the following new contributors in this release:

* [@jcarlosgarcia](https://github.com/jcarlosgarcia) made their first contribution in [#1098](https://github.com/zenml-io/zenml/pull/1098)
* [@AleksanderWWW](https://github.com/AleksanderWWW) made their first contribution in [#1082](https://github.com/zenml-io/zenml/pull/1082)
* [@shivalikasingh95](https://github.com/shivalikasingh95) made their first contribution in [#1062](https://github.com/zenml-io/zenml/pull/1062)

We would like to also acknowledge the [neptune.ai](https://neptune.ai/) team and community contributors that helped review the [PR](https://github.com/zenml-io/zenml/pull/1044) especially:

* [@normandy7](https://github.com/normandy7)
* [@twolodzko](https://github.com/twolodzko)

Thank you for helping us make ZenML better and sharing it with the community.

## 🔥 Onwards and Upwards!

If you find any bugs or something doesn't work the way you expect, please [let
us know in Slack](https://zenml.io/slack-invite) or also feel free to [open up a
GitHub issue](https://github.com/zenml-io/zenml/issues/new/choose) if you
prefer. We welcome your feedback and we thank you for your support!
