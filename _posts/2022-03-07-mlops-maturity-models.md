---
layout: post
author: Alex Strick van Linschoten
title: "Everything you ever wanted to know about MLOps maturity models"
description: "An exploration of some frameworks created by Google and Microsoft that can help think through improvements to how machine learning models get developed and deployed in production."
category: mlops
tags: zenml mlops evergreen bigger-picture devops
publish_date: March 7, 2022
date: 2022-03-07T00:02:00Z
thumbnail: /assets/posts/mlops-maturity-models/maturitymodels-tbx.png
image:
  path: /assets/posts/mlops-maturity-models/maturitymodels-tbx.png
---

In January 2020, both [Microsoft](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/mlops/mlops-maturity-model) and [Google](https://cloud.google.com/architecture/mlops-continuous-delivery-and-automation-pipelines-in-machine-learning) released what they referred to as 'maturity' models for MLOps. These outlined a series of levels that described the full spectrum of practices among organizations training and deploying machine learning models. A little later that same year, Google released an '[AI Adoption Framework](https://services.google.com/fh/files/misc/ai_adoption_framework_whitepaper.pdf)' that tackled similar ground from a different angle. They offered their take on how to go from worst practices to best practices in terms of MLOps.

These frameworks are commonly referred to when thinking through how an organization is approaching machine learning workflows, so it's worth being aware of what these models propose as well as whether there are other options for assessing your own practices.

## Everyone Starts at Zero

[Microsoft's model](https://docs.microsoft.com/en-us/azure/architecture/example-scenario/mlops/mlops-maturity-model) is the most fine-grained in terms of how it distinguishes progress through the levels. It outlines five separate levels (starting at zero) that can be used to understand the extent of MLOps adoption and maturity in an organization.

![Microsoft's MLOps Maturity Framework]({{ site.url }}/assets/posts/mlops-maturity-models/microsoft-framework.png)

Google's level 0 corresponds to that of Microsoft, where everything is manual and there is no automation anywhere. Not only are processes script-driven and manual, but the teams involved in working no the various parts of developing or deploying a model are siloed from each other. After models are 'deployed', there is no way of checking how that model is doing or using some kind of feedback loop to catch errors or to roll back if needed.

At this point, the frameworks start to diverge somewhat. Microsoft's level 1 ("DevOps, but no MLOps") describes the beginnings of automation, where releases are still "painful" but builds and tests are automated and there is some limited feedback introduced. The next level is where the training process is automated — with the environment (data, infrastructure, code) versioned and reproducible — making releases of models manual but less painful than before. Some centralized tracking of model performance has also started be introduced at this point.

Level 3 focuses on the automation of model deployment, including A/B (and more complex) testing of models as well as full lineage and traceability of models. The overall environments (from training to test to production) are all fully managed and automated.

Level 4 is the final stage where everything is fully automated, allowing for easy monitoring and where improvements or errors are handled without the need for manual intervention.

## Google's Leap from Level Zero to One

Google's assessment of 'maturity' in MLOps also relates to automation. 

> “The level of automation of these steps defines the maturity of the ML process, which reflects the velocity of training new models given new data or training new models given new implementations.” ([source](https://cloud.google.com/architecture/mlops-continuous-delivery-and-automation-pipelines-in-machine-learning))

To Google, MLOps is therefore about how agile you can be when you’re going through your process. The real challenge, as they see it, "isn't building an ML model, the challenge is building an integrated ML system and to continuously operate it in production”.

Unfortunately, the leap from the fully manual level to level 1 ("ML Pipeline Automation") is a pretty sizeable one. This makes the Google framework harder to use as a diagnostic tool, since in many ways you either are doing MLOps or you aren't; there isn't much in the way of transitional steps between the two.

![Google's Level One]({{ site.url }}/assets/posts/mlops-maturity-models/google-level-one.png)

Level 1 focuses on the automation of the whole machine learning workflow and work cycle for a single pipeline. At this level, everything is completely automated, including the provision for retraining the entire pipeline when needed, full validation across data, code and models and so on.

![Google's Level Two]({{ site.url }}/assets/posts/mlops-maturity-models/google-level-two.png)

Level 2 takes this one step further, abstracting another level higher and includes automation for many pipelines. It's quite similar to level one, just with the ability to handle many models being trained, deployed and handled at the same time.

While it is useful to see how Google think about the most 'mature' implementation of MLOps, it doesn't help much if you are seeking to reach that yourself. It doesn't make sense to try to implement everything all at once, especially if you are a small organization.

A slightly different framing of how machine learning is treated within an organization can be found in the [Google Cloud AI Adoption Framework white paper](https://services.google.com/fh/files/misc/ai_adoption_framework_whitepaper.pdf), a 37-page report published in June 2020. An organization with some tangential or singular uses for machine learning is said to be in the 'tactical' phase of adoption. At a certain point the number of these machine learning systems might increase to where there are several active and this is the 'strategic' phase. When machine learning models become a key part of the organization and their success, then they can be said to have reached the 'transformational' phase. Even though it is a bit more of a business-focused outline of how an organization goes from little machine learning to a lot, there is still considerable overlap between this and the maturity model mentioned above.

## From Zero to Hero: A Roadmap to Improving Your MLOps Practices

The frameworks explained above are useful diagnostic references, but ultimately they are more descriptive than prescriptive: it's hard to know how to move through the levels if you're starting from the beginning. As with many other software engineering best practices, or with DevOps, adoption needn't simply be a boolean state. There are ways to incrementally work on improving how you iterate through the machine learning workflow from experimentation all the way to deployment (and responsively continue to iterate from there).

As [one guide](https://mlops.community/start-manually-then-automate/) to the
adoption of MLOps practices states, there may also be some value in starting
your process by working on all the steps manually. You'll likely learn a lot in
the process about all the implicit assumptions that your process contains, just
as taking a few hours to manually label your training data can be of tremendous
benefit when it comes to understanding how to best approach training your model.
(For an overview of some of the tools and options available to you as you
navigate this landscape, checkout [this useful
post](https://nimblebox.ai/blog/mlops-tools) by Thinesh Sridar over on [the
NimbleBox blog](https://nimblebox.ai/blog).)

One option to thinking through your process might be to look at [the MLOps Stack Template](https://ml-ops.org/content/state-of-mlops), a chart that encourages you to list the various technical decisions being made. The same author(s) have proposed an alternative version to the well-known '[Business Model Canvas](https://www.amazon.com/Business-Model-Generation-Visionaries-Challengers/dp/0470876417/ref=sr_1_1?sprefix=business%2Bmodel%252Caps%252C244&sr=8-1&keywords=business%2Bmodel&crid=I74Q44GZ7CSH&tag=soumet-20&qid=1646587883)' in the form of an '[MLOps Stack Canvas](https://ml-ops.org/content/mlops-stack-canvas)' which you can use as a framework to think through these incremental improvements.

One final suggestion would be to take a look at a much early iteration from Google, their ['ML Test Score' paper](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/aad9f93b86b7addfea4c419b9100c6cdd26cacea.pdf) published in 2016/7. This is a far more practical take on how to approach 'production readiness' and the reduction of technical debt than the maturity frameworks. If you're looking for ways to improve your machine learning systems, I'd recommend giving it a read over the maturity frameworks.

## Level Up with ZenML

Even though we didn't start building ZenML with these frameworks and levels in mind, we do tackle much of the same issues. We believe that to jump through the MLOps maturity levels needn't be as painful as it currently is. Indeed, our goal is to help you move as quickly through towards a fully- or mostly-automated machine learning workflow. We see the best practices that guide you on this journey as following primarily from seeking to produce reproducible models and pipelines.

Our framework allows you to use the tools which you know and love, connecting them together in a way that covers the whole workflow from experimentation to deployment and onwards with continuous monitoring and training.

If you're interested in learning more about ZenML, how we help you bring all
your tools together and grow in MLOps maturity, visit [our Github
page](https://github.com/zenml-io/zenml), [read our
docs](https://docs.zenml.io/) and [test out our showcase
examples](https://blog.zenml.io/examples-cli/). If you have questions or want to
talk through your specific use case, feel free to [reach out to us on
Slack](https://zenml.io/slack-invite/)!
