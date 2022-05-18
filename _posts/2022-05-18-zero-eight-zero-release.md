---
layout: post
author: Alex Strick van Linschoten
title: "What's New in v0.8.0: Extend ZenML Any Way You Like!"
description: "Release notes for the new version of ZenML. We've added a ton of extensibility improvements, documentation and guides that take away most of the hard work of figuring out how to add custom components. Our CLI also has been beautified and it should even run a bit faster too!"
category: zenml
tags: zenml release-notes
publish_date: May 18, 2022
date: 2022-05-18T00:02:00Z
thumbnail: /assets/posts/release_0_8_0/audrey-martin-FJpHcqMud_Y-unsplash.jpg
image:
  path: /assets/posts/release_0_8_0/audrey-martin-FJpHcqMud_Y-unsplash.jpg
---

ZenML 0.8.0 -- and a number of changes around the edges including our messaging
and website -- is all about extensibility. We've been working hard to make it
clear and comprehensible how you can add custom components to the core
framework. You'll love how we've upgraded and beautified the CLI, even giving it
a speed boost while we were there!

Beyond this, a host of smaller bugfixes and documentation changes combine to
make ZenML 0.8.0 a more pleasant user experience overall. For a detailed look at
what's changed, give [our full release
notes](https://github.com/zenml-io/zenml/releases/tag/0.8.0) a glance.

## ⏲️ EVENT: Join the ZenML team for an MLOps Day

We are hosting a MLOps day on Wednesday, May 25, where we'll be building a
vendor-agnostic MLOps pipeline from scratch.

Sign up
[here](https://www.eventbrite.com/e/zenml-mlops-day-join-us-in-building-a-vendor-agnostic-mlops-pipeline-tickets-336331515617)
to join the entire ZenML team in showcasing the latest release, answering the
community's questions, and live-coding vendor-agnostic MLOps features with the
ZenML framework!

## 🧘‍♀️ Extensibility is our middle name

From talking to many of you in our Slack community, we know that custom stack
components and integrations is often at the top of your collective minds. ZenML
0.8.0 makes it much easier to extend the core ZenML framework through changes to
the underlying code and better documentation and guides on exactly how to do
this.

* We added the ability to register custom stack component flavors, and `type`
  was renamed to `flavor` everywhere.
* We added the ability to easily extend orchestrators along with extended
  documentation on how you can do this yourself.
* Our documentation for stacks, stack components and flavors has been fully
  fleshed out. We know you're going to love it!
* We have updated how you configure the `S3ArtifactStore` to allow you to
  connect to non-AWS S3 storage.
* We added in new MySQL metadata stores along with the ability to use SSL to
  connect to those MySQL clients (e.g. in the cloud)

## 🥞 Manage your Stacks

We added some extra functionality that's going to improve your quality of life
considerably when interacting with your stacks!

- You can now update your stacks and stack components directly! No need to
  delete and re-register things from scratch. Check out [the CLI
  docs](https://apidocs.zenml.io/0.8.0/cli/) to learn how this works.
- You can also remove custom (optional) attributes from stack components
  directly.
- When deleting stacks with `stack delete...`, we'll be sure to confirm with you
  before we go ahead and delete the stack now.
- You can [export the stack](https://docs.zenml.io/collaborate/stack-export) to
  a shareable YAML file with `zenml stack export` and import from a compatible
  YAML file with `zenml stack import`. For the full collaborative experience
  you'll want to [use the
  ZenServer](https://docs.zenml.io/collaborate/zenml-server), but this will
  still be a useful feature for some of you!

## 👭 Collaboration

* The ZenServer now enables shared projects along with the foundations of a
  shared and collaborative user experience. We added some functionality to
  [manage
  users](https://docs.zenml.io/collaborate/zenml-server#zenserver-user-management)
  interacting with your shared ZenServer.
- All of the new collaboration features have been fully documented
  [here](https://docs.zenml.io/collaborate/collaborate).

## 🖥 CLI Improvements

- We saw how it was sometimes difficult to see the full details of stack
  components and their configuration when using the CLI tool, so we made some
  fixes and tweaks to make sure text doesn't get shortened. Instead, it just
  wraps onto the next line.
- We've noticed that the CLI has started to become a little sluggish and took
  the first steps towards adding some 🚄 speed back in.
- We've been adding more and more stack components to handle the full MLOps
  story, so the list of options in the CLI has been growing and growing. With
  this release you'll see that the CLI options are split into menu groups which
  should make everything a lot more comprehensible and navigable!

## 🚀 New Integrations

- We saw we didn't have [a PyTorch
  example](https://github.com/zenml-io/zenml/tree/main/examples/pytorch) on the
  books yet, so we added that in.
- We added a GCP ☁️ Secrets Manager to sit alongside our AWS Secrets Manager
  integration.

## 📖 Documentation & User Guides

- We completely overhauled the ZenBytes introductory guide. You not only learn
  about ZenML but we teach some MLOps basics from the ground up. Check out the
  [notebook-based lessons here](https://github.com/zenml-io/zenbytes)!
- Like our CLI commands, our examples directory was starting to get a bit
  unwieldy with all the additions so we updated how that all looks and is
  presented. [The main
  README](https://github.com/zenml-io/zenml/tree/main/examples) subdivides the
  examples by use case.

## ➕ Other Updates, Additions and Fixes

- Experiment Trackers are now a full-fledged stack component.
- We improved how secrets are passed around in a deployed or cloud setting.
- We added additional metadata tracking for pipeline runs which adds to what you
  can see as part of the post-execution workflow.
- Model deployer logs can now be streamed through the CLI and not just accessed
  post-facto.
- After popular request, the `-f` or `--force` flag has now been replaced with
  `-y` or `--yes`. Don't worry, though, this won't break your workflows just
  yet. We've deprecated the `-f` flags and you'll see an error message for a
  while before we remove it completely.
- You can now pass in-line pip requirements into your pipeline decorator instead
  of only being able to pass in a `requirements.txt` file.
- We fixed [the Evidently drift detection
  visualizer](https://github.com/zenml-io/zenml/tree/main/examples/evidently_drift_detection)
  so that it now works on Google Colab notebooks again.

## 🙌 Community Contributions

We received some community contributions during this release cycle, two of which
were from new contributors!

* @Ankur3107 made their first contribution in
  https://github.com/zenml-io/zenml/pull/467
* @MateusGheorghe made their first contribution in
  https://github.com/zenml-io/zenml/pull/523
* @avramdj added support for scipy sparse matrices in
  https://github.com/zenml-io/zenml/pull/534

## 👩‍💻 Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think
we should build next!

Keep your eyes open for future releases and make sure to
[vote](https://github.com/zenml-io/zenml/discussions/categories/roadmap) on your
favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure it gets
implemented as soon as possible.

[Photo by <a href="https://unsplash.com/@avmartin">Audrey Martin</a> on <a
href="https://unsplash.com/photos/FJpHcqMud_Y">Unsplash</a>] 
