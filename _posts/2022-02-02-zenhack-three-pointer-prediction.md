---
layout: post 
author: Alexej Penner 
title: How to build a three pointer prediction pipeline 
description: "We challenged ourselves to put our own tool to the test and set up a few pipelines to answer two questions: Did Steph Curry change the game? And how many three pointers will be in the next NBA Game?"
category: zenml 
tags: zenml pipelines tooling applied-zenml  
publish_date: February 02, 2022 
date: 2022-02-02T00:02:00Z 
thumbnail: /assets/posts/three-pointer-prediction/hoop.jpg 
image:
  path: /assets/posts/three-pointer-prediction/hoop.jpg
  # height: 1910
  # width: 1000
---


# The Gameplan

Before diving headfirst into this challenge, we got together as a team and brainstormed what our `zenhack` was going to
be about. A `zenhack` is a small internal hackathon with the intention of taking an idea into production using zenml. 
This serves a few purposes. 
For one, it gives us as the zenml team a direct insight into user experience. As such one of
the side effects is a bouquet of fresh new user-stories, tasks and sometimes bugs to fix. 
Another benefit of our `zenhack` is to show off our newest features and how they can be assembled into a killer
machine learning stack. For this `zenhack` specifically we had quite a few new features to showcase. Within this 
`zenhack` we wanted to show off how to use [evidently](https://evidentlyai.com/) for drift detection, 
[mlflow](https://mlflow.org/) for model tracking and [kubeflow pipelines](https://www.kubeflow.org/) for 
orchestration. 

As we have some hardcore NBA fans on the team, the idea of creating a prediction bot for NBA matches came up. This idea
caught on quickly and our minds started to put together the story that we wanted to explore. 

## Step 1 - Analyze our Data

Without data there is no pipeline. Luckily for us the [nba](www.nba.com) offers an api with a lot of current and
historical datapoints. Additionally, there is an easy-to-use python wrapper out there, that made our lives even easier
([nba_api](https://readthedocs.org/projects/nba-api/)).  

After some rummaging through the many endpoints, we found data for every regular season match going back to 2000. 
This raw data contains the two teams, the date, time and season of the match as well as a bunch of 
game stats. Exactly what we were looking for!

### Did Steph Curry change how tha game is played?

With data in hand, it was time to explore our data. As we were looking to predict three pointers thrown in a match it 
only seemed fitting to analyze how the king of three-pointers, Stephen Curry, impacted the role that three-pointers play
in nba matches. 
As a reference point the date of [this](https://www.youtube.com/watch?v=GEMVGHoenXM) legendary game of
the Golden State Warriors, Curry's team, against Oklahoma City, was chosen. 


![](../assets/posts/three-pointer-prediction/DriftDetectionPipeline.png "Planned drift detection pipeline")

### Evidently 

![](../assets/posts/three-pointer-prediction/currys_drift.png "Distribution of three pointers before and after the legendary GSWvsOKC")

Check out our blogpost on the evidently integration [here](https://blog.zenml.io/zenml-loves-evidently/) to learn more.


## Step 2 - Build our Continuous Pipelines 

![](../assets/posts/three-pointer-prediction/Training_and_Inference_Pipeline.png "Diagram showing the planned Architecture")


### Mlflow tracking


### Kubeflow pipeline

![](../assets/posts/three-pointer-prediction/kubeflowstack.png "Excerpt from jupyter notebook demonstrating
how to start with kubeflow pipelines")


### Discord Step

"If a tree falls in a forest and no one is around to hear it, does it make a sound?". Well we won't tackle that 
philosophical question here. But unlike falling trees in forests, we want our predictions to be heard; or at least read. 
For this we implemented a small discord-posting step that takes our zenhack one step further. Once we deploy the 
training and prediction pipelines on a schedule we can look forward to the most up to date predictions on our  
discord channel.

Here is the very first prediction made:

![](../assets/posts/three-pointer-prediction/Prediction.png "Diagram showing the planned Architecture")



## The Endgame

This zenhack was a special one for us, as there was an additional motive behind it. ...

* Link to Hamzas talk 


## Conclusion

...

## Your Turn

* Try it our for yourself in our [repository](https://github.com/zenml-io/nba-ml-pipeline)

Image credit: Photo by [Markus Spiske](https://unsplash.com/@markusspiske) on [unsplash](https://unsplash.com)
