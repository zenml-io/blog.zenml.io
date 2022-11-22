---
layout: post
author: Dickson Neoh
title: "ZenML 0.22.0: BentoML Integration and a Revamped Airflow Orchestrator!"
description: "This release comes with a new BentoML integration as well as a reworked Airflow orchestrator. Additionally, it greatly improves the server performance as well as other small fixes and updates to our docs!"
category: zenml
tags: zenml release-notes
publish_date: November 22nd, 2022
date: 2022-11-05T00:02:00Z
thumbnail: /assets/posts/release_0_22_0/Release_0.22.0.gif
image:
  path: /assets/posts/release_0_22_0/Release_0.22.0.jpg
---

![Release 0.22.0](../assets/posts/release_0_22_0/Release_0.22.0.jpg)

[ZenML 0.22.0](https://github.com/zenml-io/zenml/releases/tag/0.20.0) is out, and marks the biggest release in the history of ZenML. The release follows ten months of the community's feedback, a couple months of development effort, and literally [tens of thousands of lines of code changes](https://github.com/zenml-io/zenml/pull/879).

![PR Changes]({{ site.url }}/assets/posts/zenml_revamped/pr_changes.png)

So what has changed? The new release brings a complete [architectural shift](https://docs.zenml.io/getting-started/core-concepts) from previous versions of ZenML. It features a new way of [sharing and configuring pipelines and stacks](https://docs.zenml.io/advanced-guide/pipelines/settings). Perhaps most excitingly, it brings with it a brand-new look for ZenML, which now comes bundled with a [React-based, open-source dashboard](https://github.com/zenml-io/zenml-dashboard), which can be launched (and [deployed](https://docs.zenml.io/getting-started/deploying-zenml)) directly from the CLI!

If you're already using ZenML, don't worry! Even though this is going to be a big breaking change, we have written an extensive [migration guide](https://docs.zenml.io/guidelines/migration-zero-twenty). As always, if you have any issues or questions regarding the new changes, please let us know over on the [Slack community](https://zenml.io/slack-invite).

For now, let's dive right into the changes and share why we are so excited about the new direction ZenML is going.

For those who prefer video, we also showcased a demo on our Special Launch Day Event on 5th October 2022 👇

<iframe width="560" height="316" src="https://www.youtube-nocookie.com/embed/dxnOcqe_lfA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## 🤖 ZenML is now a server-based application (RIP Metadata Store 🪦)

![Architecture Diagram]({{ site.url }}/assets/posts/zenml_revamped/architecture_diagram.png)

ZenML can now run as a server that can be accessed via REST API and comes with a dashboard. This server can be deployed in arbitrary environments (local, on-prem, via Docker, on AWS / GCP / Azure / ...) and supports user management, project scoping, and more.

The Metadata Store stack component has been deprecated and is no longer required to create a stack. The role of the Metadata Store is now taken over by the ZenServer. All metadata is now stored, tracked, and managed by ZenML itself. To further improve reproducibility, pipelines themselves are now tracked in ZenML (rather than the metadata store) and exposed as first-class citizens. Each pipeline clearly defines what steps are used in the pipeline and in what order the steps are executed. By default, pipeline runs are now scoped by pipeline.

The architecture changes for the remote use-case are shown in the diagram below. This was the status quo before:

![ZenML remote metadata before 0.20.0]({{ site.url }}/assets/posts/zenml_revamped/remote-metadata-pre-0.20.png)

And now, with our 0.20.0 release, you can see how things look:

![ZenML remote metadata after 0.20.0]({{ site.url }}/assets/posts/zenml_revamped/remote-metadata-post-0.20.png)

Extensive community feedback and our own experience over time had revealed that the metadata store connection was proving a bottleneck. By replacing the metadata store database with a FastAPI application, performance is more secure and easier to use. It will also reduce the likelihood of breaking changes of this scale going forward. 

Getting started with the new server is painless: `zenml up` will handle spinning up a server locally. When you're ready to take things to the next level, `zenml deploy` will take care of deploying a ZenML server in the cloud. For more details on how to use a cloud ZenML server to help you collaborate with a team, please [check out our extensive deployment documentation](https://docs.zenml.io/getting-started/deploying-zenml).

## 🎠 ZenML Dashboard: A beautiful, new look

Changes on the backend are one thing, but we also added a whole new feature and experience to how you work with ZenML and with your team.

![Dashboard Screenshot]({{ site.url }}/assets/posts/zenml_revamped/pipelines_dashboard.png)

Our new dashboard gives you a way to view your pipelines, pipeline runs, stacks and stack components all from within ZenML. We even added a way for you to view the DAG of your steps from within the dashboard:

![DAG visualizer screenshot]({{ site.url }}/assets/posts/zenml_revamped/dag-visualizer-screenshot.png)

The new ZenML Dashboard build files are now bundled as part of all future releases and can be launched directly from within Python. The source code lives in the [ZenML Dashboard repository](https://github.com/zenml-io/zenml-dashboard) which we are also releasing open-source as usual.

## 🥰 Sharing is caring

One of the benefits of centralizing through the ZenML Server means that not only can you view your own stacks, but if they are shared then you can now see and use the stacks and stack components of your team. This keeps the barrier for collaboration low and raises the reproducibility of your work as a team.

You can share your stacks and stack components at creation team  (`zenml stack register mystack ... --share`) or afterwards using `zenml stack share mystack`. In this way, a common setup might look something like this:

![Diagram showing shared cloud stacks]({{ site.url }}/assets/posts/zenml_revamped/stacks_shared.png)

The moment the stack is shared, other users who connect to the server will be able to see the stack and use it as well!

## 🎊 Centralizing configuration

Alongside the architectural shift, Pipeline configuration has been completely rethought. ZenML pipelines and steps could previously be configured in many different ways:

- On the `@pipeline` and `@step` decorators
- In the `__init__` method of the pipeline and step class
- Using `@enable_xxx` decorators
- Using specialized methods like `pipeline.with_config(...)` or `step.with_return_materializer(...)`

Some of the configuration options were quite hidden, difficult to access and not tracked in any way by the ZenML metadata store.

With ZenML 0.20.0, we introduce the `BaseSettings` class, a broad class that serves as a central object to represent all runtime configuration of a pipeline run.

Pipelines and steps now allow all configurations on their decorators as well as the `.configure(...)` method. This includes configurations for stack components that are not infrastructure-related which was previously done using
the `@enable_xxx` decorators). The same configurations can also be defined in a YAML file. 

Read more about this paradigm in the [new docs section about settings](https://docs.zenml.io/advanced-guide/pipelines/settings).

## 👨‍🍳 Flavors: Separating configuration from implementation

Stack components can now be registered without having the required integrations installed. As part of this change, we split all existing stack component definitions into three classes: 

- an implementation class that defines the logic of the stack component
- a config class that defines the attributes and performs input validations, 
- and a flavor class that links implementation and config classes together.

You can describe a stack component with the following command:

```shell
zenml <STACK_COMPONENT> flavor describe
```

This gives the following output:

![Flavor Describe Usage]({{ site.url }}/assets/posts/zenml_revamped/flavor_describe.png)

You can see how it's now clear which properties are required and what types are expected for each flavor you choose for stack component registrations.

## 🔥 Onwards and Upwards!

The key changes highlighted above addresses most of the major use-cases, but there are many other additions, changes and tweaks in ZenML 0.20.0. To learn about all the updates, [visit our migration guide](https://docs.zenml.io/guidelines/migration-zero-twenty) which lists the changes as well as offers you a clear path to migrating your existing work to the new version.

We're really excited to have this latest version out in the world and for you to try it out! The best place to start is [our Quickstart example](https://github.com/zenml-io/zenml/tree/main/examples/quickstart). Instructions for how to get going are listed in the README.

If you find any bugs or something doesn't work the way you expect, please [let
us know in Slack](https://zenml.io/slack-invite) or also feel free to [open up a
Github issue](https://github.com/zenml-io/zenml/issues/new/choose) if you
prefer. We welcome your feedback and we thank you for your support!
