---
layout: post
author: Alexej Penner
title: How to build a three-pointer prediction pipeline
description:
  "We challenged ourselves to put our own tool to the test and set up a few
  pipelines to answer two questions: Did Steph Curry change the game of
  basketball? And how many three-pointers will be in the next NBA game?"
category: zenml
tags: zenml pipelines tooling applied-zenml evergreen
publish_date: February 2, 2022
date: 2022-02-02T00:02:00Z
thumbnail: /assets/posts/three-pointer-prediction/hoop.jpg
image:
  path: /assets/posts/three-pointer-prediction/hoop.jpg
  # height: 1910
  # width: 1000
---

**Last updated:** November 14, 2022.

# The Gameplan

Before diving headfirst into this challenge lets start off with some background
information.

This challenge is what we call a ZenHack. A ZenHack is a small internal
hackathon with the intention of taking an idea into production using ZenML. This
serves a few purposes. For one, it gives us as the ZenML team a direct insight
into user experience. As such, one of the happy side effects is a bouquet of
fresh new user-stories, tasks and sometimes bugs to fix. Another benefit of our
ZenHack is to show off our newest features and how they can be assembled into a
killer machine learning stack.

For this ZenHack specifically we had quite a few new features to showcase. We
wanted to show off how to use [Evidently](https://evidentlyai.com/) for drift
detection, [MLFlow](https://mlflow.org/) for tracking our runs and
[Kubeflow Pipelines](https://www.kubeflow.org/) for the orchestration of
scheduled repeating pipeline runs.

![]({{ site.url }}/assets/posts/three-pointer-prediction/evidently+mlflow+discord+kubeflow.png)

As we have some hardcore NBA fans on the team, the idea of creating a prediction
bot for NBA matches came up. This idea caught on quickly and our minds started
to put together the story that we wanted to explore.

## Step 1 - Analyze our Data

Without data there is no pipeline. Luckily for us the [NBA](https://www.nba.com)
offers an API with a lot of current and historical datapoints. Additionally,
there is an easy-to-use Python wrapper out there, that made our lives even
easier ([nba_api](https://readthedocs.org/projects/nba-api/)).

After some rummaging through the many endpoints, we found data for every regular
season match going back to 2000. This raw data contains the two teams, the date,
time and season of the match as well as a bunch of game stats. Exactly what we
were looking for!

### Did Steph Curry change how the game is played?

With these stats in hand, it was time to explore the data. As we were looking to
predict three-pointers thrown in a match, it only seemed fitting to analyze how
the king of three-pointers, Stephen Curry, impacted the role that three-pointers
play in NBA matches. This sounds very much like a drift detection problem.
[Here](https://medium.com/data-from-the-trenches/a-primer-on-data-drift-18789ef252a6)
is a nice article explaining what data drift is.

To detect data drift you generally need a reference dataset. When new data comes
in, its distribution is compared to the reference data in order to determine if
data has drifted. This is exactly the question we want to answer here. Has Steph
Curry impacted the distribution of the amount of three-pointers in NBA matches?
To calculate this, we need to choose a point in time to delineate a 'before'
from an 'after' Curry. We chose the date of
[this legendary game](https://www.youtube.com/watch?v=GEMVGHoenXM) of the Golden
State Warriors, Curry's team, against Oklahoma City.

### Evidently

For drift detection we have an integration with
[Evidently](https://evidentlyai.com) that we can leverage. Evidently helps
evaluate and monitor machine learning data and models in production. Check out
[our blogpost](https://blog.zenml.io/zenml-loves-evidently/) on the Evidently
integration to learn more.

Regarding our question about Curry's impact, there are only a few steps needed
to perform the necessary data exploration.

1. We need to import the data from the nba -> `Importer Step`
2. We need to split our data around our chosen delineation date **2016-02-27**
   -> `Splitter Step`
3. We need to let Evidently do what it does best: analyze data ->
   `Drift Detector Step`

![]({{ site.url }}/assets/posts/three-pointer-prediction/DriftDetectionPipeline.png "Planned drift detection pipeline")

With these steps implemented and easily connected within a ZenML pipeline, all
that is left to do is to run the pipeline and look at the beautiful
visualization that Evidently offers:

![]({{ site.url }}/assets/posts/three-pointer-prediction/currys_drift.png "Distribution of three pointers before and after the legendary GSWvsOKC")

As you can see here, we were quickly able to go from data and initial question
to a full-blown pipeline and an answer to our question. It appears that the data
has drifted ever since 2016-02-27. This might not be undeniable proof for the
claim made about Stephen Curry's impact on the game. But it is a compelling
correlation.

## Step 2 - Building our Continuous Pipelines

With the data exploration behind us, let's advance onto the continuous
pipelines. Within our brainstorming session we came up with a diagram very
similar to the one below, albeit a bit less organized.

![]({{ site.url }}/assets/posts/three-pointer-prediction/Training_and_Inference_Pipeline.png "Diagram showing the planned Architecture")

Let us unpack this diagram together. The objective of this ZenHack was for us to
periodically receive predictions for upcoming NBA matches in our discord
channel. So what do we need to get there? Well, on the highest level of
abstraction we need two separate entities. One **continuous training pipeline**
and a **prediction pipeline**.

### Training pipeline

![]({{ site.url }}/assets/posts/three-pointer-prediction/Training_pipeline.png "Diagram showing the planned Architecture")

The training pipeline needs to take in historical data for a given timeframe and
spit out a trained model at the other end. Here is a short description for all
the steps we deemed necessary to get from input to output.

1. Importer - Imports data from nba.com for a given set of seasons
2. Feature Engineer - Additionally filter data by time and add Opponent column
   to each row
3. Encode - Encode Season ID and Team Abbreviations for the benefit of the model
4. ML Splitter - Split the dataset into train, eval and test set
5. Trainer - Train a model to predict on the data
6. Tester - Test the performance of the model

On the other branch:

1. Drift Splitter - Split data at seven days ago
2. Drift Detector - Check if the last seven days of games have drifted away from
   the past years of data
3. Drift Alert - Send a message to Discord so that we can intervene

### Prediction Pipeline

![]({{ site.url }}/assets/posts/three-pointer-prediction/Prediction_pipeline.png "Diagram showing the planned Architecture")

The prediction pipeline on the other hand needs a schedule for upcoming matches
as the input and should post our prediction to our Discord chat. To achieve this
we have also split the problem into a few distinct steps.

1. Importer - Import game schedule from a different data source
2. Preprocessor - Massage data into the same table format that the model was
   trained and apply the same encoding
   - Note that this is another point where **ZenML** makes it super easy to take
     outputs from steps in different pipelines
3. Extract Next Week Data - Here we filter to only use the next week's schedule
4. Model Picker - Decide which model to pick based on scores of the test set in
   the training pipeline
5. Predictor - Run an inference on the matches for the upcoming week
6. Post Prediction - This step has actually turned into two
   - Data Postprocessor - To turn one hot encodings back into a human-readable
     form
   - Discord Poster - To post our predictions to Discord

### MLFlow tracking

The [MLFlow Tracking](https://mlflow.org/docs/latest/tracking.html) component is
an API and UI for logging parameters, code versions, metrics, and output files
when running your machine learning code and for later visualizing the results.

<del>We are currently actively working on deeply integrating with MLflow and making
it as easy as possible to utilize MLFlow within your ZenML pipelines. For this
ZenHack we used MLflow tracking for its visualization. Keep your eyes peeled,
though; we have some more MLFlow-related features coming up in our next
releases.</del>
(UPDATE: As of November 2022 we have a full-fledged MLFlow integration part of 
the ZenML Expirement Tracking stack component. You can read more about it
[here](https://docs.zenml.io/component-gallery/experiment-trackers/mlflow))


Within our ZenHack only two lines of code were really necessary to liftoff with
MLFlow.

1. Enable MLFlow for a step

```python
@step(experiment_tracker=experiment_tracker.name)
def tf_trainer(....):
    ...
```

This configures the MLFlow backend and the experiment name and establishes a
connection between a ZenML pipeline run and a MLFlow run.

2. Select what to log in code

```python
...
mlflow.sklearn.autolog()
clf = RandomForestRegressor(max_depth=config.max_depth)
...
```

And with just that, we have MLFlow tracking in our pipeline. The MLFLow ui can
now be started from within our Jupyter notebook:

```
!mlflow ui --backend-store-uri '{local_mlflow_backend()}' --port 4999
```

And like that we can use the MLFlow ui to quickly compare runs and analyze the
different runs.

### Kubeflow Pipelines and Scheduled Runs

[Kubeflow Pipelines](https://www.kubeflow.org/docs/components/pipelines/introduction/)
is a platform for building and deploying portable, scalable machine learning
workflows based on Docker containers.

Check out our [docs](https://github.com/zenml-io/zenfiles) to find out how to
quickly go from standard pipeline orchestration to using Kubeflow Pipelines for
your own applications.

Within our ZenHack we used Kubeflow as the orchestration backend for our
scheduled training. After some configuration steps (see screenshot below)
Kubeflow Pipelines runs locally.

![]({{ site.url }}/assets/posts/three-pointer-prediction/kubeflowstack.png "Excerpt from Jupyter notebook demonstrating
how to start with Kubeflow Pipelines")

The Python script that is called in the last line of the screenshot instantiates
the pipeline and starts a scheduled run. For demonstration purposes we have
chosen to repeat every 10 minutes here.

```python
train_pipe = training_pipeline(
    importer=game_data_importer(),
    ...
    drift_alert=discord_alert(),
)

train_pipe.run(
    schedule=Schedule(start_time=datetime.now(), interval_second=600)
    )
```

### Discord Step

"If a tree falls in a forest and no one is around to hear it, does it make a
sound?". Well, we won't tackle that philosophical question here. But what is the
point of training and prediction on models if those predictions are never heard
or seen?

This is why we implemented a small Discord-posting step that takes our ZenHack a
step further — pun intended!. Once we deploy the training and prediction
pipelines on a schedule we can see the prediction for the upcoming game on
Discord.

Here is the very first prediction posted at 10:39 CET on 30.01.2022:

!["Prediction posted to discord"]({{ site.url }}/assets/posts/three-pointer-prediction/Prediction.png)

And somehow our very first prediction came true. Approximately four and a half
hours later Orlando Magic concluded their
[match](https://statsdmz.nba.com/pdfs/20220130/20220130_DALORL_book.pdf) against
the Dallas Mavericks with 11 three-pointers.

## The Endgame

This ZenHack was a special one for us as there was an additional motive behind
it. We had the privilege of presenting ZenML at a Meetup organized by
[MLOps.community](https://mlops.community/) on January 26, 2022. Just in time
for this meetup we pulled off a clutch play of our own: with just a few minutes
to spare we put together all the pipelines within the ZenHack and released ZenML
0.6.0 so that participants could code along while we walked through the ZenHack.

<div class="embed-responsive embed-responsive-16by9 mb-5">
    <iframe class="embed-responsive-item" src="https://www.youtube.com/embed/Ne-dt9tu11g"  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

In this video of the meetup you'll see our co-founder and CTO
[Hamza Tahir](https://www.linkedin.com/in/hamzatahirofficial/) lead an
interactive live-coding session together with
[Ben Epstein](https://www.linkedin.com/in/ben-epstein/), using the substance of
this ZenHack as a basis.

## Conclusion

This ZenHack truly was a fun adventure for us to embark upon. I learned a ton
and would like to just sum it all up with these conclusions:

### What you should take away from this

1. If you too want a Discord bot that predicts NBA games for you, checkout the
   code [here](https://github.com/zenml-io/zenfiles/tree/main). Feel free to
   improve the underlying models or steps and open a pull request! We are eager
   for your feedback, so if you run into any issues or if you like what you see,
   come join us on [Slack](https://zenml.io/slack-invite/) and let us know!

2. If you have an idea similar to ours and quickly want to go from **idea** to
   **continuous training/inference**, then **ZenML** is the way to get there.

### What I took away from it

1. Personally, I got to know ZenML from a very different angle which is an
   awesome way to inform our vision going forward.
2. These ZenHacks are an amazing way to really test out our code from the
   perspective of a user. The few smaller issues we found during this ZenHack
   were directly put into tickets and many have been solved already. It is a
   real testament to how fast we can move as a
   [team](https://zenml.io/team/#team) 💪. It is a real privilege working
   together with everyone here.

[_Image credit: Photo by [Markus Spiske](https://unsplash.com/@markusspiske) on
[unsplash](https://unsplash.com)_]
