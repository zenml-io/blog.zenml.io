---
layout: post
author: Benedikt Koller
title: 12 Factors of Reproducible Machine Learning in Production
publish_date: September 28th, 2020
category: zenml
tags: [bigger-picture, devops]
date: 2020-09-28T10:20:00Z
thumbnail: /assets/posts/12factor.svg
tags: legacy
image:
  path: /assets/posts/12factors.png
  height: 1200
  width: 628
---

The last two decades have yielded us some great understandings about Software Development. A big part of that is due to the emergence of DevOps and it’s wide adoption throughout the industry.

Leading software companies follow identical patterns: Fast iterations in software development followed by Continuous Integration, Continuous Delivery, Continuous Deployment. Every artefact is tested on its ability to provide value, always has a state of readiness and is deployed through automation.

As a field, Machine Learning differs from traditional software development, but we can still borrow many learnings and adapt them to “our” industry. For the last few years, we’ve been doing Machine Learning projects in production, so beyond proof-of-concepts, and our goals where the same is in software development: reproducibility. So we built a pipeline orchestrator, strong automations and established a workflow to achieve exactly that.

Why not just Jupyter Notebooks? Well, how long does it take to construct a Notebook from scratch, with all processing steps, from scratch? And how easy is it to onboard new members to the team? Can you reproduce the results you’ve had two months ago, now, fast? Can you compare today's results against historic one’s? Can you give provenance over your data throughout training? And what happens if your model goes stale?

We’ve faced all of these issues, and more, and now took our experience to deduce 12 factors (as a nod to the [12 factor app](https://12factor.net/)) that build the backbone of successful ML in production.

## 1. Versioning

While obvious to basically all Software Engineers, version control is not an universally accepted methodology among Data Scientists. Let me quote the folks at Gitlab as a quick primer:

> Version control facilitates coordination, sharing, and collaboration across the entire software development team. Version control software enables teams to work in distributed and asynchronous environments, manage changes and versions of code and artifacts, and resolve merge conflicts and related anomalies.

In short, versioning lets you safely manage the moving parts of Software Development.

As a special form of Software Development, Machine Learning has unique requirements. First, it has not one but two moving parts: Code and Data. Second, model trainings happen in (fast) iterations and introduce a high variance of code (e.g. splitting, preprocessing, models).

As soon as data can be subject to change it needs to be versioned to be able to reproducibly and repeatably conduct experiments and train models. Cruder forms of versioning (read: hard-copies) can go a long way, but especially in team scenarios shared, immutable version control becomes critical.

Version control of code is even more key. In addition to above's quote, preprocessing code is not just relevant at training but also at serving time and needs to be immutably correlatable with models. Serverless functions can provide an easy-access way to achieve a middle ground between the workflow of Data Scientists and production-ready requirements.

**TL;DR:** You need to version your code, and you need to version your data.

## 2. Explicit feature dependencies

In a perfect world, whatever produces your input data will forever produce exactly the same data, at least structurally. But the world is not perfect, you're consuming data from an upstream service that's built by humans and might be subject to change. Features will change, eventually. At best, your models fail outright, but at worst they'll just silently start to produce garbage results.

Explicitly defined feature dependencies allow for transparent failure as early as possible. Well-designed systems will accommodate feature dependencies both in continuous training as well as at serving time.

**TL;DR:** Make your feature dependencies explicit in your code.

## 3. Descriptive training and preprocessing

Good software is descriptive - it can be read and understood easily without reading every line of code.

And while Machine Learning is a unique flavor of Software Development it doesn't exempt practitioners from following established coding guidelines. Basic understanding of coding standard essentials can be picked up with very little effort and in a short amount of time.

Code for both preprocessing and models should follow [PEP8](https://www.python.org/dev/peps/pep-0008/). It should consist of meaningful object names and contain helpful comments. Following PEP8 will improve code legibility, reduce complexity and speed up debugging. Programming paradigms such as [SOLID](https://en.wikipedia.org/wiki/SOLID) provide thought frameworks to make code more maintainable, understandable and flexible for future use cases.

Configuration should be separated from code. Don't hardcode your split ratios, provide them at runtime through configuration. As known from hyperparameter tuning, a well-separated configuration increases speed of iterations significantly and makes codebases reusable.

**TL;DR:** Write readable code and separate code from configuration.

## 4. Reproducibility of trainings

If you can't reproduce training results you can't trust the results. While this is somewhat the overarching theme of this blogpost, there are nuances to reproducibility. Not just do you need to be able to reproduce a training yourself, the entire team should be able to do so. Obscuring trainings in Jupyter Notebooks on someones PC or on some VM on AWS is the literal inverse of a reproducible training.

By using pipelines to train models entire teams gain both access and transparency over conducted experiments and training runs. Bundled with a reusable codebase and a separation from configuration, everyone can successfully relaunch any training at any point in time.

**TL;DR:** Use pipelines and automation.

## 5. Testing

Testing comes in many shapes and forms. To give two examples:

- [Unit testing](https://en.wikipedia.org/wiki/Unit_testing) is testing on an atomic level - every function is tested individually on it's own specific criteria.
- [Integration testing](https://en.wikipedia.org/wiki/Integration_testing) is taking an inverse approach - all elements of a codebase are tested as a group, in conjunction and with clones/mocks of up- and downstream services.

Both paradigms are good starting points for Machine Learning. Preprocessing code is predestined for unit testing - do transforms yield the right results given various inputs? Models are a great use case for integration tests - does your model produce comparable results to evaluation at serving time in a production environment?

**TL;DR:** Test your code, test your models.

## 6. Drift / Continuous training

Drift is a legit problem for production scenarios. You need to account for drift as soon as there is even a slight possibility that data might change (e.g. user input, upstream service volatility). Two measures can mitigate risk exposure:

- Data monitoring for production systems. Establish automated reporting mechanisms to alert teams of changing data, even beyond explicitly defined feature dependencies.
- Continuous training on newly incoming data. Well-automated pipelines can be rerun on newly recorded data and offer comparability to historic training results to show performance degradation as well as offer a quick way to promote newly trained models into production, given better model performance.

**TL;DR:** If you data can change run a continuous training pipeline.

## 7. Tracking of results

Excel is not a good way to track experiment results. And not just Excel, any decentralized, manual form of tracking will yield non-authoritative and therefore untrustworthy information.

The right approach are automated methods to record training results in a centralized data store. Automation ensures the reliable tracking of every training run, and allows for a later comparability of training runs against each other. Centralized storage of results give transparency across teams and allows for continuous analysis.

**TL;DR:** Track results via automation.

## 8. Experimentation vs Production models

Understanding datasets requires effort. Commonly, this understanding is gathered through experimentation, especially when operating in fields with a lot of hidden domain knowledge. Start a Jupyter Notebook, get some/all of the data into a Pandas Dataframe, do some hours of out-of-sequence magic, train a first model, evaluate results - Job done. Well, unfortunately not.

Experiments serve a purpose in the lifecycle of Machine Learning. The results of these Experiments are however not models, but understanding. Models from explorative Jupyter Notebooks are proof for understanding, not production-ready artefacts. Gained understanding will need more molding and fitting into production-ready training pipelines.

All understandings unrelated to domain-specific knowledge can however be automated. Generate statistics on each data version you’re using to skip any one-time, ad-hoc exploratory work you might have had to do in Jupyter Notebooks, and move straight to the first pipelines. The earlier you experiment in pipelines, the earlier you can collaborate on intermediate results and the earlier you’ll receive production-ready models.

**TL;DR:** Notebooks are not production-ready, so experiment in pipelines early on.

## 9. Training-Serving-Skew

The avoidance of skewed training and serving environments is often reduced to correctly embedding all data preprocessing into the model serving environments. This is absolutely correct, and you need to adhere to this rule. However, it is also a too narrow interpretation of Training-Serving-Skew.

A little detour to ancient DevOps history: In 2006 the CTO of Amazon, Werner Vogels, coined the term “You build it, you run it”. It’s a descriptive phrase for extending the responsibility of Developers to not only writing but also running the software they build.

A similar dynamic is required for Machine Learning projects - an understanding of both the upstream generation of data and the downstream usage of generated Models is within the responsibility of Data Scientists. What system generates your data for training? Can it break, what’s the system SLO (service level objective), is it the same as for serving? How is your model served? What’s the runtime environment, and how are your preprocessing functions applied during serving? These are questions that Data Scientists need to understand and find answers to.

**TL;DR:** Correctly embed preprocessing to serving, and make sure you understand up- and downstream of your data.

## 10. Comparability

From the point in time that introduces a second training script to a project comparability becomes a fundamental part of any future work. If the results of the second model can not, at all, be compared to the first model, waste was generated and at least one of the two models is superfluous, if not both.

By definition, all model trainings that are trying to solve the same problem need to be comparable, otherwise they are not solving the same problem. And while iterations will change the definition of what to compare models on over time, the technical possibility to compare model trainings needs to be built into training architecture as a first-class citizen early on.

**TL;DR:** Build your pipelines so you can easily compare training results across pipelines.

## 11. Monitoring

As a very rough description, Machine Learning models are supposed to solve a problem by learning from data. To solve this problem, compute resources are allocated. First to training the model, later to serving the model. The abstract entity (e.g. the person or the department) responsible for spending the resources during training carries the responsibility forward to serving. Plenty of negative degradations can occur in the lifecycle of a model: Data can drift, models can become bottlenecks for overall performance and bias is a real issue.

The effect: Data Scientists and teams are responsible for monitoring the models they produce. Not necessarily in the implementation of that monitoring, if bigger organizations are at play, but for sure for the understanding and interpretation of monitoring data. At its minimum, a model needs to be monitored for input data, inference times, resource usage (read: CPU, RAM) and output data.

**TL;DR:** Again: you build it, you run it. Monitoring models in production is a part of data science in production.

## 12. Deployability of Models

On a technical level every model training pipeline needs to produce an artefact deployable to production. The model results might be horrible, no questions asked, but it needs to end up wrapped up into an artefact you can directly move towards a production environment.

This is a common theme in Software Development - it’s called Continuous Delivery. Teams should be able to deploy their software at any given moment, and iteration cycles need to be quick enough to accommodate that goal.

A similar approach needs to be taken with Machine Learning. It’ll enforce first and foremost a conversation about reality and the expectations towards models. All stakeholders need to be aware of what's even theoretically possible regarding model results. All stakeholders need to agree on a way to deploy a model, and where it fits into the bigger software architecture around it. It will however also lead to strong automations, and by necessity the adoption of a majority of the factors outlined in the prior paragraphs.

**TL;DR:** Every training pipeline needs to produce a deployable artefact, not “just” a model.

## Closing

This is by no means an exhaustive list. It’s the combination of our experience, and you’re welcome to use it as a boilerplate to benchmark your production architecture, or as a blueprint to design your own.

We used these factors as the guiding principles for ZenML, our ML orchestrator. So before you start from scratch: Sign up and give us a run for your money!

To read more about ZenML head over to our [website](https://zenml.io)for more details. If you want to start using ZenML for your own ML production environment, [contact us](mailto:support@zenml.io)!
