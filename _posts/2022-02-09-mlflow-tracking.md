---
layout: post
author: Alex Strick van Linschoten
title:
  How to improve your experimentation workflows with MLflow Tracking and ZenML
description:
  "Use MLflow Tracking to automatically ensure that you're capturing data,
  metadata and hyperparameters that contribute to how you are training your
  models. Use the UI interface to compare experiments, and let ZenML handle the
  boring setup details."
category: zenml
tags: zenml tooling applied-zenml integrations evergreen
publish_date: February 9, 2022
date: 2022-02-09T00:02:00Z
thumbnail: /assets/posts/mlflow-tracking/mlflow-logo.jpeg
image:
  path: /assets/posts/mlflow-tracking/mlflow-logo.jpeg
  # height: 1910
  # width: 1000
---

Most professional or so-called 'citizen' data scientists will be familiar with
the scenario that sees you spending a day trying out a dozen different model
training configurations in which you experiment with various hyper parameters or
perhaps different pre-trained models. As evening falls, you emerge from the haze
of experimentation and you ask yourself: which of my experiments offered the
best results for the problem I'm trying to solve?

At this point, especially for smaller use cases or where you were unsure if a
hunch was worth pursuing and just wanted to try a few things out, you might be
left empty-handed, unable to give an answer one way or another beyond some hunch
that there _was_ one set of parameters that really performed well, if only you
could remember what they were… And if someone asked you to reproduce the steps
it took you to create a particular model, would you even be able to do that?

<iframe src="https://giphy.com/embed/NzQSHl01OBLkk" width="480" height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/angry-computer-regular-show-NzQSHl01OBLkk">via GIPHY</a></p>

This would be one of those times where it's worth reminding ourselves that data
science includes the word 'science', and that we need to be careful around how
we track and reason about models. The workflows and practice of machine learning
is sufficiently complicated (and often non-deterministic) that we need rigorous
ways of ensuring that we really are doing what we think we are doing, and that
we can reproduce our work. (It's not for nothing that 'reproducibility' is
[often](https://petewarden.com/2018/03/19/the-machine-learning-reproducibility-crisis/)
[paired](https://www.technologyreview.com/2019/02/18/137357/machine-learning-is-contributing-to-a-reproducibility-crisis-within-science/)
with 'crisis'.)

There are manual ways that you could use to help address this problem, but
they're unlikely to be sufficient. Will your spreadsheet experiment tracker
really capture _everything_ you needed to produce a particular model? (Think
about how the particular configuration or random split of data is so central to
how your model performs.) What you really want is something that will handle all
this tracking of data and parameters, in as automatic a way as is possible.

<iframe src="https://giphy.com/embed/JWuBH9rCO2uZuHBFpm" width="480" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/Giflytics-JWuBH9rCO2uZuHBFpm">via GIPHY</a></p>

# Why use MLflow Tracking?

Enter, [MLflow Tracking](https://mlflow.org/docs/latest/tracking.html), part of
[a wider ecosystem](https://mlflow.org/docs/latest/concepts.html) of tooling
offered by MLflow to help you train robust and reproducible models. Other
commonly-used pieces are
[the model registry](https://mlflow.org/docs/latest/model-registry.html) (which
stores any model artifacts created during the training process) as well as their
flexible suite of plugins and integrations allowing you to
[deploy the models](https://mlflow.org/docs/latest/models.html#built-in-deployment-tools)
you create.

MLflow Tracking is what allows you to track all those little parts of your model
training workflow. Not only does it hook into an artifact store of your choosing
(such as that offered by ZenML), but it offers a really useful UI interface
which you can use to inspect pipeline runs and experiments you conduct. If you
want to compare the performance or accuracy of several experiments (i.e.
pipeline runs), some diagrams and charts are only a few clicks away. This
flexible interface goes a really long way to solving some of the problems
mentioned earlier.

One really useful feature offered by MLflow Tracking is that of
[automatic logging](https://mlflow.org/docs/latest/tracking.html#automatic-logging).
Many commonly-used machine learning libraries (such as `scikit-learn`, Pytorch,
`fastai` and Tensorflow / Keras) support this. You either call
`mlflow.autolog()` just before your training code, or you use a library-specific
version of that (e.g. `mlflow.sklearn.autolog()`). In this way, MLflow will
handle logging metrics, parameters and models without the need for explicit log
statements. (Note that you can also include the
[non-automated logging](https://mlflow.org/docs/latest/tracking.html#logging-data-to-runs)
of whatever custom properties are important for you.

## ZenML + MLflow Tracking = 🚀

If you're using ZenML to bring together the various tools in your machine
learning stack, you'll probably be eager to use some of this tracking goodness
and make your own experiments more robust. ZenML actually _already_ partly
supported what MLflow Tracking does in the sense that any artifacts going in or
out of the steps of your ZenML pipeline were being tracked, stored and versioned
in your artifact and metadata store. (You're welcome!) But until now we didn't
have a great way for you to interact with that metadata about your experiments
and pipeline runs that was non-programmatic and also visual.

MLflow Tracking gives you that ability to inspect the various experiments and
pipeline runs in the (local) web interface and is probably going to be a
friendlier way of interacting with and reasoning about your machine learning
experiments.

![Tracking machine learning training runs with MLFlow]({{ site.url }}/assets/posts/mlflow-tracking/mlflow-screenshot.png)

You could have used MLflow Tracking in the past, too, but with our latest
integration updates ZenML handles some of the boilerplate complicated setup that
comes with using MLflow. There are
[different ways](https://mlflow.org/docs/latest/tracking.html#where-runs-are-recorded)
of deploying the tracking infrastructure and servers and it isn't a completely
painless task to set all this up and to get going with MLflow Tracking. This is
where we make your life a bit easier: we setup everything you need to use it on
your (currently: local) machine, connecting the MLFlow Tracking interface to
your ZenML artifact store. It can be a bit tricky to configure the relevant
connections between the various modular pieces that talk to each other, and we
hide this from you beneath an abstraction.

We think that this ability to converse between the MLflow universe and the ZenML
universe is extremely powerful, and this approach is at the heart of what we are
trying to build with our tool to help you work with reproducible and robust
machine learning pipelines.

## Just tell me how to use it already!

The best place to see MLflow Tracking and ZenML being used together in a simple
use case is
[our example](https://github.com/zenml-io/zenml/tree/main/examples/mlflow_tracking)
that showcases the integration. It builds on the quickstart example, but shows
how you can add in MLflow to handle the tracking. Adding MLflow tracking to a
step is as simple as enabling the experiment tracker for a step. Now you're free to log
anything from within the step to mlflow. Here you can see how this is employed
in a model training step that uses the `autolog` feature I mentioned above:

```python
@step(experiment_tracker="<NAME_OF_EXPERIMENT_TRACKER>")
def tf_trainer(
   x_train: np.ndarray,
   y_train: np.ndarray,
) -> tf.keras.Model:
   """Train a neural net from scratch to recognize MNIST digits return our
   model or the learner"""
   
   # compile model

   mlflow.tensorflow.autolog()
   
   # train model
   
   return model
```

You can also log parameters, metrics and artifacts into nested runs, which will be children of the pipeline run. To do so, enable it in the settings like this:

```python
from zenml.integrations.mlflow.flavors.mlflow_experiment_tracker_flavor import MLFlowExperimentTrackerSettings

@step(
    experiment_tracker="<NAME_OF_EXPERIMENT_TRACKER>",
    settings={
        "experiment_tracker.mlflow": MLFlowExperimentTrackerSettings(
            nested=True
        )
    }
)
def tf_trainer(
    x_train: np.ndarray,
    y_train: np.ndarray,
) -> tf.keras.Model:
    """Train a neural net from scratch to recognize MNIST digits return our
    model or the learner"""
    
    # compile model

    mlflow.tensorflow.autolog()
    
    # train model
    
    return model
```

# Over to you now!

If you're inspired by this illustration of how you can make your machine
learning workflow that little bit more reproducible and robust, check out
[the full example](https://github.com/zenml-io/zenml/tree/main/examples/mlflow_tracking)
that illustrates the integration. If you use it in your own codebase, please do
let us know — [say hi on Slack](https://zenml.io/slack-invite/)! — and as always
if you have any questions, we're here for you.
