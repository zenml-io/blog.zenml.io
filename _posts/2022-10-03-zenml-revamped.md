---
layout: post
author: Hamza Tahir
title: "ZenML 0.20.0: Our biggest release yet"
description: "The 0.20.0 release is a seminar release in the history of the ZenML project. After 10 months of continuous feedback and iteration, we bring you a whole new architecture and redesign of ZenML - and a new dashboard to boot."
category: zenml
tags: zenml release-notes
publish_date: October 5th, 2022
date: 2022-10-05T00:02:00Z
thumbnail: /assets/posts/zenml_revamped/pr_changes.png
image:
  path: /assets/posts/zenml_revamped/pr_changes.png
---

![img](/assets/posts/zenml_revamped/pr_changes.png)


# ZenML 0.20.0: Our Biggest Release Yet

[ZenML 0.20.0]() is out, and marks the biggest release in the history of ZenML. The release follows ten months of the community's feedback, a couple months of development effort, and literally [thousands of lines of code changes](https://github.com/zenml-io/zenml/pull/879). 

So what has changed? The short answer is, a lot. The new release brings a complete [architectural shift]() from previous versions of ZenML. It also features a new way of [configuring pipelines and stacks](). Perhaps most excitingly, it brings with it a brand-new look for ZenML, which now comes bundled with a [React-based, open-source dashboard](https://github.com/zenml-io/zenml-dashboard), which can be launched directly from the CLI! 

For current ZenML users, do not worry! Even though, this is going to be a big breaking change, we have extensively documented a [migration guide](TBD). If there are any questions regarding the new changes, please let us know over on the [Slack community](https://zenml.io/slack-invite). 

For now, let's dive right into the changes, and share why we are so excited about the new direction ZenML is going.

## 🤖 ZenML is now a server-based application (Goodbye, Metadata Store)

ZenML can now run as a server that can be accessed via REST API and comes with a visual user interface (called the ZenML Dashboard). This server can be deployed in arbitrary environments (local, on-prem, via Docker, on AWS / GCP / Azure / ...) and supports user management, project scoping, and more.

Metadata Store stack component has been deprecated and is no longer required to create a stack. The role of the Metadata Store is now taken over by the ZenServer . All metadata is now stored, tracked, and managed by ZenML itself. To further improve reproducibility, pipelines themselves are now tracked in ZenML (rather than the metadata store) and exposed as first-level citizens. Each pipeline clearly defines what steps are used in the pipeline and in what order the steps are executed. By default, pipeline runs are now scoped by pipeline.

Address removing MLMD in the future with Mac M1

## 🎠 ZenML Dashboard: A beautiful, new look

The new ZenML Dashboard build files are now bundled as part of all future releases, and can be launched directly from within python. The source code lives in the ZenML Dashboard repository 

## 🥰 Sharing is caring

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
- 
@step/pipeline(…): Configures the class -> will be set for all instances

step_instance/pipeline_instance.configure(…): Configures the instance -> will be set for all runs using the instance

pipeline.run(…): allows configuration in code or using a yaml file. Configurations in code overwrite settings in the file

Generate a template for a config file: pipeline_instance.write_run_configuration_template(path=<PATH>)


Merging settings on class/instance/run:
when a settings object is configured, ZenML merges the values with previously configured keys: <Example>

```python
from zenml.config import ResourceSettings

@step(settings={"resources": ResourceSettings(cpu_count=2, memory="1GB")})
def my_step() -> None:
  ...

step_instance = my_step()
step_instance.configure(settings={"resources": ResourceSettings(gpu_count=1, memory="2GB")})
step_instance.configuration.settings["resources"] # cpu_count: 2, gpu_count=1, memory=2BG
```

Settings:
- General settings that can be used on all ZenML pipelines: DockerSettings and ResourceSettings
- Stack component specific settings: these can be used to supply runtime configurations to certain stack components (key= <COMPONENT_TYPE>.<COMPONENT_FLAVOR>). Settings for components not in the active stack will be ignored

Some settings can be configured on pipelines and steps, some only on one of the two. Pipeline level settings will be automatically applied to all steps, but if the same setting is configured on a step as well that takes precedence. Merging similar to the example above




## 👨‍🍳 Flavors: Seperating configuration from implementation

Stack components can now be registered without having the required integrations installed. As part of this change, we split all existing stack component definitions into three classes: An implementation class that defines the logic of the stack component, a config class that defines the attributes and performs input validations, and a flavor class that links implementation and config classes together. See component flavor models #895 for more details.

## 🔥 Breaking changes

- Configuration changes (deperecating enable_mlflow)
- Once a pipeline has been executed, it is represented by a `PipelineSpec` that uniques identifies it. Therefore, users are no longer able to edit a pipeline once it has been run once. There are now three options to get around this:
    - Pipeline runs can be created without being associated with a pipeline explicitly: We call these `unlisted` runs
    - Pipelines can be deleted and created again
    - Pipelines can be given unique names each time they are run to uniquely identify them