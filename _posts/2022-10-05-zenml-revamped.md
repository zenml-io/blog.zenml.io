---
layout: post
author: Hamza Tahir
title: "ZenML 0.20.0: Our biggest release yet"
description: "The 0.20.0 release is a seminar release in the history of the ZenML project. After 10 months of continuous feedback and iteration, we bring you a whole new architecture and redesign of ZenML - and a new dashboard to boot."
category: zenml
tags: zenml release-notes
publish_date: October 5th, 2022
date: 2022-10-05T00:02:00Z
thumbnail: /assets/posts/zenml_revamped/architecture_diagram.png
image:
  path: /assets/posts/zenml_revamped/architecture_diagram.png
---

![PR Changes](/assets/posts/zenml_revamped/pr_changes.png)

[ZenML 0.20.0](https://github.com/zenml-io/zenml/releases/tag/0.20.0) is out, and marks the biggest release in the history of ZenML. The release follows ten months of the community's feedback, a couple months of development effort, and literally [thousands of lines of code changes](https://github.com/zenml-io/zenml/pull/879). 

So what has changed? The new release brings a complete [architectural shift](https://docs.zenml.io/getting-started/core-concepts) from previous versions of ZenML. It features a new way of [sharing and configuring pipelines and stacks](https://docs.zenml.io/advanced-guide/pipelines/settings). Perhaps most excitingly, it brings with it a brand-new look for ZenML, which now comes bundled with a [React-based, open-source dashboard](https://github.com/zenml-io/zenml-dashboard), which can be launched (and [deployed](https://docs.zenml.io/getting-started/deploying-zenml)) directly from the CLI!

For current ZenML users, do not worry! Even though, this is going to be a big breaking change, we have extensively documented a [migration guide](https://docs.zenml.io/guidelines/migration-zero-twenty). If there are any questions regarding the new changes, please let us know over on the [Slack community](https://zenml.io/slack-invite).

For now, let's dive right into the changes, and share why we are so excited about the new direction ZenML is going.

## 🤖 ZenML is now a server-based application (RIP Metadata Store 🪦)

![Architecture Diagram](/assets/posts/zenml_revamped/architecture_diagram.png)

ZenML can now run as a server that can be accessed via REST API and comes with a visual user interface (called the ZenML Dashboard). This server can be deployed in arbitrary environments (local, on-prem, via Docker, on AWS / GCP / Azure / ...) and supports user management, project scoping, and more.

Metadata Store stack component has been deprecated and is no longer required to create a stack. The role of the Metadata Store is now taken over by the ZenServer. All metadata is now stored, tracked, and managed by ZenML itself. To further improve reproducibility, pipelines themselves are now tracked in ZenML (rather than the metadata store) and exposed as first-level citizens. Each pipeline clearly defines what steps are used in the pipeline and in what order the steps are executed. By default, pipeline runs are now scoped by pipeline.

The architecture changes for the remote case are shown in the diagram below:

![ZenML remote metadata before 0.20.0](/assets/posts/zenml_revamped/remote-metadata-pre-0.20.png)
![ZenML remote metadata after 0.20.0](/assets/posts/zenml_revamped/remote-metadata-post-0.20.png)

-> Talk about why this was necessary: Because the metadata store connection was clunky and users found it a big bottleneck. By replacing the metadata store database with a FastAPI application, things are faster, more secure, and easier to use. Address removing MLMD in the future with Mac M1.

-> Talk about deployment options with `zenml deploy` and link to deployment guide https://docs.zenml.io/getting-started/deploying-zenml

## 🎠 ZenML Dashboard: A beautiful, new look

![Dashboard Screenshot](/assets/posts/zenml_revamped/pipelines_dashboard.png)

The new ZenML Dashboard build files are now bundled as part of all future releases, and can be launched directly from within python. The source code lives in the [ZenML Dashboard repository](https://github.com/zenml-io/zenml-dashboard)

Talk about why its important to have visual feel

## 🥰 Sharing is caring

Combining above two points together we can talk about remote vs local stacks and shared vs non-shared stacks. The diagrams here should be used: https://zenml-io.gitbook.io/post-zenserver/QBNJR4RKcc9F3eLCSJJ6/starter-guide/collaborate

- Stacks and Stack Components can be shared through the Zen Server now - to share, either set it as shared during creation time `zenml stack register mystack ... --share`  or afterwards through `zenml stack share mystack`
- Stacks and Stack components can now be addressed by name, id or the first few letters of the id in the cli - for a stack `default` with id `179ebd25-4c5b-480f-a47c-d4f04e0b6185`  you can now do `zenml stack describe default` or `zenml stack describe 179` or `zenml stack describe 179ebd25-4c5b-480f-a47c-d4f04e0b6185`

## 🎊 Centralizing configuration

- Alongside the architectural shift, Pipeline configuration has been completely rethought. ZenML pipelines and steps could previously be configured in many different ways:
    - On the `@pipeline` and `@step` decorators
    - In the `__init__` method of the pipeline and step class
    - Using `@enable_xxx` decorators
    - Using specialized methods like `pipeline.with_config(...)` or `step.with_return_materializer(...)`

Some of the configuration options were quite hidden, difficult to access and not tracked in any way by the ZenML metadata store. The new changes introduced are:

- Pipelines and steps now allow all configurations on their decorators as well as the `.configure(...)` method. This includes configurations for stack components that are not infrastructure-related which was previously done using the `@enable_xxx` decorators)
- The same configurations can also be defined in a yaml file
- The users can think of configuring stacks and pipeline in terms of `Params` and `Settings`
- `BaseStepConfig` is not renamed to `Params`
- `DockerConfiguration` is not `DockerSettings`

## 👨‍🍳 Flavors: Separating configuration from implementation

Doc reference: https://zenml-io.gitbook.io/post-zenserver/QBNJR4RKcc9F3eLCSJJ6/advanced-guide/pipelines/settings

Stack components can now be registered without having the required integrations installed. As part of this change, we split all existing stack component definitions into three classes: An implementation class that defines the logic of the stack component, a config class that defines the attributes and performs input validations, and a flavor class that links implementation and config classes together. See component flavor models #895 for more details.

```
zenml <STACK_COMPONENT> flavor describe
```

![Flavor Describe Usage](/assets/posts/zenml_revamped/flavor_describe.png)


## 🔥 Conclusion 

While the above addresses most of the major use-cases, there are many smaller things -> Link to migration guide.

CTA is to try out the new Quickstart and join Slack or raise a GitHub issue if
there are bugs.
