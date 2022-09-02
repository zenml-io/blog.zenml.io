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
0.8.0 makes it much easier to extend the core ZenML framework. To achieve this,
we changed the underlying code and wrote better documentation and guides on
exactly how to do this.

* We added the ability to register custom stack component flavors, and `type`
  was renamed to `flavor` everywhere.
* We added the ability to easily extend orchestrators along with extended
  documentation on how you can do this yourself.
* Our documentation for stacks, stack components and flavors has been fully
  fleshed out. We know you're going to love it!
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
- We added a `zenml go` command which launches an easy tutorial on how to get
  started with ZenML and some of its features.
- We've noticed that the CLI has started to become a little sluggish and took
  the first steps towards adding some 🚄 speed back in.
- We've been adding more and more stack components to handle the full MLOps
  story, so the list of options in the CLI has been growing and growing. With
  this release you'll see that the CLI options are split into menu groups which
  should make everything a lot more comprehensible and navigable! Check it out!
  Doesn't it look beautiful now?

![Screenshot of how our CLI looks
now](../assets/posts/release_0_8_0/zenml-cli.png)

## 🚀 New Integrations

- We saw we didn't have [a PyTorch
  example](https://github.com/zenml-io/zenml/tree/main/examples/pytorch) on the
  books yet, so we added that in.
- We added a GCP ☁️ Secrets Manager to sit alongside our AWS Secrets Manager
  integration.

## 📖 Documentation & User Guides

- We completely overhauled the ZenBytes introductory guide. You not only learn
  about ZenML but we teach some MLOps basics from the ground up. Check out the
  [notebook-based lessons here](https://github.com/zenml-io/zenbytes)! (Shout
  out to Felix for making this happen!)
- Like our CLI commands, our examples directory was starting to get a bit
  unwieldy with all the additions so we updated how that all looks and is
  presented. [The main
  README](https://github.com/zenml-io/zenml/tree/main/examples) subdivides the
  examples by use case.

## ➕ Other Updates, Additions and Fixes

- We improved how secrets are passed around in a deployed or cloud setting.
- We added additional metadata tracking for pipeline runs which adds to what you
  can see as part of the post-execution workflow. (This includes tracking the
  Git SHA, the Docker SHA as well as docstrings.)
- Model deployer logs can now be streamed through the CLI and not just accessed
  post-facto. Viewing the logs is as simple as calling `zenml model-deployer models
  logs` from the CLI.
- After popular request, the `-f` or `--force` flag has now been replaced with
  `-y` or `--yes`. Don't worry, though, this won't break your workflows just
  yet. We've deprecated the `-f` flags and you'll see an error message for a
  while before we remove it completely.
- You can now pass in-line pip requirements into your pipeline decorator instead
  of only being able to pass in a `requirements.txt` file. We also renamed this
  parameter from `requirements_file` to just `requirements`, but don't worry we
  just deprecated the old parameter to give you time to adjust your code.
- We fixed [the Evidently drift detection
  visualizer](https://github.com/zenml-io/zenml/tree/main/examples/evidently_drift_detection)
  so that it now works on Google Colab notebooks again. (Hamza is doing an AMA
  with the Evidently community on May 24; [click
  here](https://www.eventbrite.co.uk/e/ama-whamza-tahir-co-founder-zenml-tickets-336732525047)
  to register!)

## 🙌 Community Contributions

We received a new community contribution during this release cycle, from Avram
Ðorđević in Belgrade. It's great to have the community returning to contribute
to the codebase! Avram added support for scipy sparse matrices [in his
PR](https://github.com/zenml-io/zenml/pull/534).

## 👩‍💻 Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know if you have an
idea for a feature or something you'd like to contribute to the framework.

![Screenshot of the new hub for our
roadmap](../assets/posts/release_0_8_0/roadmap.png)

We're super excited to be able to share [the new home for our
roadmap](https://zenml.io/roadmap) where you can vote on your favorite upcoming
feature or propose new ideas for what the core team should work on. You can vote
without needing to log in, so please do let us know what you want us to build!

[Photo by <a href="https://unsplash.com/@avmartin">Audrey Martin</a> on <a
href="https://unsplash.com/photos/FJpHcqMud_Y">Unsplash</a>] 
