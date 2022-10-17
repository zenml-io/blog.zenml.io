---
layout: post
author: Alex Strick van Linschoten
title: "Podcast: Open-Source MLOps with Matt Squire"
description: "This week I spoke with Matt Squire, the CTO and co-founder of Fuzzy Labs, where they help partner organizations think through how best to productionise their machine learning workflows."
category: podcast
tags: podcast mlops evergreen bigger-picture tooling education machine-learning
publish_date: March 31, 2022
date: 2022-03-31T00:02:00Z
thumbnail: /assets/posts/matt-squire/matt-squire-profile.jpeg
image:
  path: /assets/posts/matt-squire/matt-squire-profile.jpeg
---

This week I spoke with [Matt Squire](https://www.linkedin.com/in/matt-squire-a19896125/), the CTO and co-founder of [Fuzzy Labs](https://www.fuzzylabs.ai/), where they help partner organizations think through how best to productionize their machine learning workflows.

Matt and FuzzyLabs are also behind the '[Awesome Open Source MLOps](https://github.com/fuzzylabs/awesome-open-mlops)' GitHub repo where you can find all the options for an open-source MLOps stack of your dreams.

Matt has been an enthusiastic early supporter of the work we do at ZenML so it was really amazing to get to talk to him and  get his take based on the many experiences he's had seeing how machine learning is done out in the field.

In this clip, Matt talks through the components that would make up his ideal MLOps stack:

<iframe src="https://share.descript.com/embed/7QxoXz3v8ZN" width="410" height="410" frameborder="0" allowfullscreen></iframe>

Matt has also recently been writing a series of blog posts about ZenML over at the Fuzzy Labs Blog:

![Fuzzy Lab blog posts]({{ site.url }}/assets/posts/matt-squire/blogposts.png)

Only the [first](https://www.fuzzylabs.ai/blog-post/the-road-to-zen-part-1-getting-started-pipelines) [two](https://www.fuzzylabs.ai/blog-post/the-road-to-zen-running-experiments) parts are out, but they cover the basics of running ZenML pipelines as well as experiment tracking with MLflow. Towards the end of the first one, Matt lays out the case for why a tool like ZenML is important in a machine learning workflow:

> "*The first is reproducibility. By writing really clear, modular pipelines, we can efficiently re-run a pipeline many times over. ZenML not only encourages this clear programming style, it also helps us to capture pipeline dependencies, which we’ve done by adding a special PIP requirements file (pipeline-requirements.txt). […] The pipeline that we’ve written can be run on any data scientist’s machine, and it will always do the same thing, produce the same model. It can also run using a dedicated model training environment, like KubeFlow, which you might do if you wanted more compute power than your own machine has. You don’t need to modify your pipeline in any way to do this; ZenML figures out how to run the pipeline in whatever target environment you’re using. The notion of writing a pipeline once and running it anywhere is one of the unique things about ZenML. It means your pipelines are decoupled from your infrastructure, which in turn enables a data scientist to focus just on the pipeline, without worrying about what infrastructure it will run on.*"

We encourage you to [visit the Fuzzy Labs Blog](https://www.fuzzylabs.ai/blog) and read the full series along with the other articles that they have there.

As always, full show notes and links are available on
[our dedicated podcast page](https://podcast.zenml.io/).

<iframe src="https://player.fireside.fm/v2/vA-gqsEV+UsZ0ZY4P?theme=dark" width="740" height="200" frameborder="0" scrolling="no"></iframe>

<br>

_[Subscribe to Pipeline Conversations](https://podcast.zenml.io/subscribe) with_
_your favorite podcast player [here](https://podcast.zenml.io/subscribe)._
