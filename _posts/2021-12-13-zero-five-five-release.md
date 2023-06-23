---
layout: post
author: Alexej Penner
title: What's New in v0.5.5
description: "Release notes for the new version of ZenML."
category: zenml
tags: zenml release-notes
publish_date: December 13, 2021
date: 2021-12-13T00:02:00Z
thumbnail: /assets/posts/release_0_5_5/balloons-pixabay_0_5_5.jpg
image:
  path: /assets/posts/release_0_5_5/balloons-pixabay_0_5_5.jpg
  # height: 1910
  # width: 1000
---

**Last updated:** November 3, 2022.

ZenML 0.5.5 is jam-packed with new features to take your ML pipelines to the next level. In this blog post we will 
highlight our three biggest new features: Kubeflow Pipelines, CLI support for our integrations and Standard Interfaces. That's right, Standard Interfaces are back!

For a detailed look at what's changed, give [our full release
notes](https://github.com/zenml-io/zenml/releases/tag/0.5.5) a glance.

## Kubeflow Pipelines

We are super excited about our integration of Kubeflow Pipelines into ZenML. With just a few lines of code you can now 
spin up your very own local deployment of Kubeflow Pipelines. With Kubeflow Pipelines running on your machine or even 
in the cloud, you change where to run your code with just a few commands. 

![Kubeflow pipeline]({{ site.url }}/assets/posts/release_0_5_5/kubeflow.png)

## CLI Support for Integrations

With release 0.5.5 we made [our integrations](https://zenml.io/integrations) into the first class citizens they should be. You can now easily
list all integrations and see which integrations are active (by having all their requirements installed).

```
zenml integration list
```

But that's not all! Installing requirements for our integrations is just as easy now. For example, this is how you would 
install all requirements to use our `dash` integration 

```
zenml integration get-requirements dash
```

## Standard Interfaces

Standardization is a great way to keep code maintainable, easy to use and scalable across larger teams. With our 
Standard Interfaces we are making our steps, pipelines and artifacts even more powerful. 

```python
pipeline_instance = TrainingPipeline(
    datasource=PandasDatasource(),
    splitter=SklearnSplitter(),
    analyzer=PandasAnalyzer(),
    preprocessor=SklearnStandardScaler(),
    trainer=TensorflowBinaryClassifier(),
    evaluator=SklearnEvaluator()
).with_config('pipeline_config.yaml')

pipeline_instance.run()
```

Using a powerful set of standardized steps like this, it becomes easier than ever to hit the ground running when setting
up a new pipeline. Check out how get started with our Standard Interfaces in our 
[docs](https://docs.zenml.io/)

## Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think we should build next!

Keep your eyes open for future releases and make sure to vote on your favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure it gets implemented as soon as possible.

[Image credit: Photo by [Stefan Nyffenegger](https://pixabay.com/images/id-2826093/) on [pixabay](https://pixabay.com/)]
