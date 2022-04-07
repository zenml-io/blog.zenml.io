---
layout: post
author: Hamza Tahir
title: ""It's the data, silly!" How data-centric AI is driving MLOps."
description: "ML practitioners today are embracing data-centric machine learning, because of its substantive effect on MLOps practices. In this article, we take a brief excursion into how data-centric machine learning is fueling MLOps best practices, and why you should care about this change."
category: mlops
tags: mlops evergreen bigger-picture education machine-learning pipeline
publish_date: April 07, 2022
date: 2022-04-07T00:02:00Z
thumbnail: /assets/posts/matt-squire/matt-squire-profile.jpeg
image:
  path: /assets/posts/matt-squire/matt-squire-profile.jpeg
---





What even is a MLOps pipeline, and why is it relevant to my work? A classically trained data scientist could be forgiven for this sentiment as the ML in production (MLOps) scene gains more and more hype.


There is an ever-increasing plethora of resources around MLOps (see the end of this article) and an increasing amount regarding the shift from model-centric to data-centric machine learning. However, few speak about the link between data-centric machine learning 
and how it is driving MLOps practices today. In this article, we go deeper into how a pipeline-driven approach to machine learning is one of the best ways to set up an ML team up for MLOps success.

## MLOps is not just about deploying models

<div align="center">
  <img src="../assets/posts/data-centric-ml/mlops_tweet.png" width="700" />
</div>

When speaking about MLOps, developers often confuse it with the simple act of deployment. However, conversations such as the above do not simply refer to deploying models. Machine Learning engineering tackles a broader set of challenges that span more than merely wrapping up a model in a server application and deploying it.

ML development may be broken down into the following relatively simple processes. 

<div align="center">
  <img src="../assets/posts/data-centric-ml/mlops_process_0.png" width="700" />
</div>

Taken in silos, these processes don't sound too hard: 

- Feature engineering is getting easier with feature stores such as [Feast](https://feast.dev/).
- The training loop is made easier by thousands of tools that help in the iterative process, from experiment tracking tools like [MLflow](https://mlflow.org/) and [Weights&Bases](https://wandb.ai/site) to advanced training frameworks like [PyTorch Lightning](https://www.pytorchlightning.ai/).
- Deploying models are also getting easier with the advent of advanced tooling such as [Seldon Core](https://github.com/SeldonIO/seldon-core), or managed services offered by all the major cloud providers.

However, the reality is that the process looks more like this:

<div align="center">
  <img src="../assets/posts/data-centric-ml/mlops_process_1.png" width="700" />
</div>

More than code, in machine learning **data** affects the output of the system directly. There are feedback loops that happen implcitly and often explcitly within the lifetime of a model that is deployed in production. While in classical software development, one could simply test and vet code as it passes through various stages to production, it is more complex and difficult to this in a system affected by data.

It is in these feedback loops where MLOps ultimately lives. It is not enough to do this process once: A successful ML team needs to execute this process over and over again, and in a manner that the system can be trusted. 

Said simply, MLOps is a set of practices that aims to deploy and maintain machine learning models in production reliably and efficiently. This is including and beyond getting these models deployed into production.

<div align="center">
  <img src="../assets/posts/data-centric-ml/mlops_process_2.png" width="700" />
</div>

## Post-deployment Woes

When looked at from this perspective, it is more intuitive to understand that the trouble starts after the first deployment. Here are just a few examples:

### Latency problems: 

If latency is not accounted for whilst developing ML models, it can have a huge impact on a business. You could lose [half your traffic](https://www.thinkwithgoogle.com/consumer-insights/consumer-trends/mobile-site-load-time-statistics/) with a slow load-up of your application. This means that when employing models in production, one needs to be cognizant of latency requirements in production.

### Maintaining fairness and avoiding bias

If left unchecked, bias can creep into a ML system very easily. [Microsoft's rogue racist Twitter bot](https://www.nytimes.com/2016/03/25/technology/microsoft-created-a-twitter-bot-to-learn-from-users-it-quickly-became-a-racist-jerk.html) is an example of not setting up systems to maintain fairness in ML development. If a model is not inspected closely (e.g. in terms of slicing metrics), then a practitioner risks that they might unintentionally model bias into the system. This is where examining data closely is critical to ensure a robust and fair system.

### Lack of explainability and auditability

If fairness is not maintained in a system, then legislators will be in their full right to come after ML practitioners. The [European Commission](https://ec.europa.eu/commission/presscorner/detail/en/IP_21_1682) is already rolling out new laws and checks, and we can only expect this to grow over time. Practitioners should be able to answer questions such as why a certain prediction was made, how a certain model was trained, and on which slice of data. These audit trails are all parts of the MLOps workflow.

### Painfully slow development cycles

Getting a model into production can take [up to a year for many companies](https://algorithmia.com/state-of-ml). That means going through the above process only once can cost hundreds of thousands of dollars, let alone having to do it again and again. Teams need to automate most of the tedious stuff away if they are to have any sort of argument for a legitimate ROI for machine learning being applied in a business.

### Model, concepts, and data drifts

The real world is not static. Training models on data that do not change are willingly ignoring the fact that this does not happen in the real world. The recent [disaster at Zillow](https://www.geekwire.com/2021/zillow-shutter-home-buying-business-lay-off-2k-employees-big-real-estate-bet-falters/) is illustrative of how drift can cost a business dearly. As the world changes, MLOps systems need to be robust to these changes and deal with them as they arise.

## Model-centric vs Data-centric Machine Learning

Andrew Ng recently popularized the term data-centric machine learning with his excellent talk in 2020. Watch the full video 
below:

<iframe width="560" height="315" src="https://www.youtube.com/embed/06-AZXmwHjo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The essence of the talk is as follows: You can get a lot of bang for your buck from your data by being data-centric rather than model-centric. This means that rather than iterating on the model/code and holding the data static in ML development, it would pay more dividends if you were to hold the code/model static (or even start with a simple model) and try to simulate real-world behavior with the data. This of course is in stark contrast to how ML is taught in crash courses and universities, where the process usually starts in a notebook with reading a static, well-prepared dataset, and training a model on it. 

<div align="center">
  <img src="../assets/posts/data-centric-ml/model_vs_data_centric.png" width="700" />
</div>

When taking a look at the challenges facing ML in production today, it is clear that a shift towards being data-centric is simply the natural mindset shift that is required. Latency problems can be solved by exposing data scientists to real-world data ingestion patterns. Fairness and bias can be avoided by inspecting the data at the moment of model training. Auditability trails can be kept if data is versioned and tracked as models are developed. The development cycle can also be accelerated vastly by creating data-centric workflows that can adapt to changing data. Finally, drift and data quality can be accounted for early on in the development process.

Here is an example of a model-centric decision vs a data-centric decision, that also showcases its link with MLOps. Let's say a data scientist has a dataset for the last year and is tasked with developing a model. The model-centric way of approaching such a task would be to use the entire data to train the model with a little bit leftover as a test set to verify the model metrics. Perhaps hyper-parameter tuning is applied to squeeze out the maximum accuracy from the model and data.

On the other hand, a data-centric decision, and a decision that would help ultimately in production, would be to partition the data in a way that a portion of it (let's say the first three quarters of the year) is used for the training process, and the last quarter is used as a separate dataset to see how the model drifts over time. This would perhaps incur a slight loss in accuracy for the model, but give key information about the behavior of the model by simulating it being deployed out in the real world. 

In the end, While being model-centric has its benefits, adding data-centric decisions into the mix is ultimately what is the best path forward when applying ML in the real world. With that, there is a natural synergy between this and the adoption of MLOps.

## Towards data-centric ML(Ops): From scripting to pipelines

A concrete shift to data-centric machine learning often involves an ML team shifting focus from script-based development to 
pipeline-based development. Machine learning lends itself very nicely to developing in terms of pipelines because most development does consist of a sequence of steps carried out in order.

Here it is important to make a distinction between data-driven pipelines vs task-driven pipelines.

Said another way, this means that serious teams develop ML code as chunks of steps, using some form of tooling to isolate the orchestration of execution of steps from each other. This has the following benefits:

Often this means stepping out of a notebook environment or finding some way of transporting notebook code to such a paradigm. 

## Takeaways

So, in short, here is the link between MLOps and data-centric machine learning:

- ML in production is different from ML in research and has a different set of challenges.
- These challenges are growing in relevance as the adoption of ML increases.
- MLOps helps solve these problems.
- MLOps is rooted in being more data-centric than model-centric.
- Developing pipelines help in being more data-centric.

I hope that helps to clarify the link between these two popular terms and gives beginner MLOps practitioners an indication of where to take their efforts as they develop internal ML tooling for their organizations.

Shameless plug: If you'd like to start the shift towards data-centric machine learning by developing ML pipelines, then you might want to take a look at [ZenML](https://github.com/zenml-io/zenml). It is designed with the following goals:

- Be simple and intuitive to give a simple path toward data-centric machine learning. 
- Be infrastructure and tooling agnostic across the MLOps stack.
- Start writing your pipeline in a notebook and carry it easily into the cloud with minimum effort.

## Resources

If you'd like to get more into MLOPs, I would recommend the following excellent resources to get started:

- MLOps Course MadeWithML: https://madewithml.com/

- CS 329S: Machine Learning Systems Design: https://mlsys.stanford.edu/

- Full Stack Deep Learning: https://fullstackdeeplearning.com/ 

- ZenBytes - learn MLOps through ZenML: https://github.com/zenml-io/zenbytes

## References

Some images inspired by Andrew Ng's "From Model-centric to Data-centric AI" on YouTube: https://www.youtube.com/watch?v=06-AZXmwHjo