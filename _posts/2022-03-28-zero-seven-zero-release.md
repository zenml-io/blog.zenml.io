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
still let you do that as well.

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

## Profiles

Lorem Ipsum, meow.

## Secrets

Hocus Pocus.

## Vertex AI and more

Lorem Checksum.

## ➕ Other Updates, Additions and Fixes

Dolor amet sic.

## Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think
we should build next!

Keep your eyes open for future releases and make sure to
[vote](https://github.com/zenml-io/zenml/discussions/categories/roadmap) on
your favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure
it gets implemented as soon as possible.

[Photo by <a href="https://unsplash.com/@ninjason?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Jason Leung</a> on <a href="https://unsplash.com/s/photos/balloon?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>] 
