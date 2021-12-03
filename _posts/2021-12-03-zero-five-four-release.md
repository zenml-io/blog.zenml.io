---
layout: post
author: Alex Strick van Linschoten
title: What's New in v0.5.4
category: zenml
tags: zenml release-notes
publish_date: December 3, 2021
date: 2021-12-03T00:02:00Z
thumbnail: /assets/posts/release_0_5_4/luca-upper-Z-4kOr93RCI-unsplash.jpg
image:
  path: /assets/posts/release_0_5_4/luca-upper-Z-4kOr93RCI-unsplash.jpg
  # height: 1910
  # width: 1000
---

ZenML 0.5.4 adds [LIST THE NEW FEATURES]

For a detailed look at what's changed, give [our full release notes](https://github.com/zenml-io/zenml/releases/tag/0.5.4) a glance. This blog post will cover some of the big-picture changes.

## Pipeline Lineage Tracking & Visualization

## Standard Interfaces for Steps





## Statistics Visualisations

In the latest release we added the concept of visualizations as a first-class citizen in ZenML. Now you can use awesome third-party libraries to visualize ZenML steps and artifacts. We support the facets visualization for statistics out of the box, to find data drift between your training and test sets.

We use the built-in FacetStatisticsVisualizer using the [Facets Overview](https://pypi.org/project/facets-overview/) integration. [Facets](https://pair-code.github.io/facets/) is an awesome project that helps users visualize large amounts of data in a coherent way.

| ![Here's what the statistics visualizer looks like](../assets/posts/release_0_5_3/stats.gif) |
|:--:|
| *Here's what the statistics visualizer looks like* |

<br>
## CLI Speed Improvements

You may have noticed that the previous versions of ZenML CLI were a bit slow. 😬 Sorry about that. We've fixed the problem. There were some imports of large libraries happening at inopportune moments. This improvement will get a whole blog post of its own, so watch this space for more details…

## Contribute to ZenML!

Join our [Slack](https://zenml.io/slack-invite/) to let us know what you think we should build next!

Keep your eyes open for future releases and make sure to [vote](https://github.com/zenml-io/zenml/discussions/categories/roadmap) on your favorite feature of our [roadmap](https://zenml.io/roadmap) to make sure it gets implemented as soon as possible.

[Image credit: Photo by [Luca Upper](https://unsplash.com/@lucaupper?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/balloons?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)]