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

Before diving headfirst into this challenge, we got together as a team and brainstormed what our ZenHack was going to
be about. A ZenHack is a small internal hackathon with the intention of taking an idea into production using zenml. 
This serves a few purposes. 
For one, it gives us as the zenml team a direct insight into user experience. As such one of
the side effects is a bouquet of fresh new user-stories, tasks and sometimes bugs to fix. 
Another benefit of our ZenHack is to show off our newest features and how they can be assembled into a killer
machine learning stack. For this ZenHack specifically we had quite a few new features to showcase. Within this 
ZenHack we wanted to show off how to use [evidently](https://evidentlyai.com/) for drift detection, 
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

### Did Steph Curry change how the game is played?

With data in hand, it was time to explore our data. As we were looking to predict three pointers thrown in a match it 
only seemed fitting to analyze how the king of three-pointers, Stephen Curry, impacted the role that three-pointers play
in nba matches. This sounds very much like a drift detection problem. 
[Here](https://medium.com/data-from-the-trenches/a-primer-on-data-drift-18789ef252a6) is a nice article explaining what
data drift is. 

To detect datadrift you generally need a reference dataset. When new data comes in, its distribution is compared to the 
reference data, in order to determine if data has drifted.
This is exactly the question we want to answer here. Has Stephen Curry impacted the distribution of the amount of 
three-pointers in nba matches? To calculate this, we need to choose a point in time to delineate a 'before' from an
'after' Curry. We chose the date of [this](https://www.youtube.com/watch?v=GEMVGHoenXM) legendary game of
the Golden State Warriors, Curry's team, against Oklahoma City. 


### Evidently 


![](../assets/posts/three-pointer-prediction/DriftDetectionPipeline.png "Planned drift detection pipeline")
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
philosophical question here. But what is the point of training and prediction on models if those predictions
are never heard or seen?

This is why we implemented a small discord-posting step that takes our ZenHack a step further. Once we deploy the 
training and prediction pipelines on a schedule we can see the prediction for the upcoming game on discord.

Here is the very first prediction posted at 10:39 CET on 30.01.2022:

!["Prediction posted to discord"](../assets/posts/three-pointer-prediction/Prediction.png)

And somehow our very first prediction came true. Approximately 4 1/2 hours later Orlando Magic concluded their 
[match](https://statsdmz.nba.com/pdfs/20220130/20220130_DALORL_book.pdf) against the Dallas Mavericks with 11 
three pointers.


## The Endgame

This ZenHack was a special one for us, as there was an additional motive behind it. We had the privilege of presenting 
ZenML at a Meetup organized by [MLPs-community](https://mlops.community/) on the 26.01.2022. Just in time for this 
meetup we pulled off a clutch play of our own. With just a few minutes to spare we put together all the pipelines 
within the ZenHack and release ZenML 0.6.0 so participants could code along.

Checkout our founder Hamza Tahir walk through this ZenHack for this meetup on the Youtube channel of 
[MLPs-community](https://www.youtube.com/c/MLOpscommunity). 

## Conclusion

...

## Your Turn


* Try it our for yourself in our [repository](https://github.com/zenml-io/nba-ml-pipeline)

Image credit: Photo by [Markus Spiske](https://unsplash.com/@markusspiske) on [unsplash](https://unsplash.com)
