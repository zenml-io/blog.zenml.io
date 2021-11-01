---
layout: post
author: Benedikt Koller
title: >
    MLOps: Learning from history
publish_date: November 9th, 2020
date: 2020-11-09T10:20:00Z
thumbnail: /assets/posts/learning.svg
image:
  path: /assets/posts/sharing-mlops_learning_from_history.png
  height: 1200
  width: 628
---

TL;DR: Running successful ML teams and projects requires cross-functional collaboration within the executing team.

That sentence alone does not help anyone. It feels unsubstantiated, and someone playing bullshit bingo might luck out just on that one sentence - and yet, it’s true. Why? Because it’s taking the main driver behind the DevOps revolution in software development and applies it to Machine Learning.

If you’re familiar with what DevOps stands for, where it came from and why it’s such a game-changer, feel free to skip to [the conclusion](#a-better-way).

For everyone else, a quick refresher.

## Why did “software people” come up with DevOps?
Flashback to the 2000s (sorry if this triggers PTSD for my fellow Ops guys out there). Software Development is a barren wasteland. Developers write code until it works on their computer, send an email to QA and Ops to please do their thing now. Nobody knows who the people in QA are, all they are doing is complaining about bugs that can’t be reproduced. Ops are the angry guys from the basement, and somehow they get mad just because code sometimes SEGFAULTs, but it can’t have been a fault on our side, it never SEGFAULTs on my machine.

This is not a healthy way to run a business. The late 2000s were full of stories of companies that failed, simply because their internal software development process was too slow to keep up with the market.

Meet “DevOps”: A new and revolutionary way of dealing with software development. What if we could deliver our software more often, and faster, to our customers? And what if it broke less in production? What if our Devs, QA, and Ops could be happier at work? And, what if we would build up less technical debt along the way? 

## But, how?

How, you ask? Let developers, testers, AND operators work in unison, together, and own the entire process, rather than separate them into silos!
From an orbital perspective, software development can be roughly broken down into a handful of stages:

* Coding  
* Building / Packaging  
* Testing  
* Deployment  
* Monitoring  

Allowing teams to own the entire process, rather than just a single aspect, created a deeper understanding of all software lifecycle aspects across the functions in a team. Suddenly, everyone was a part of the development team. Testers had to be able to understand and write code because tests had to be automated. Ops guys built abstractions to the underlying hardware so that others could run software independently. Developers had to acknowledge that software is only done when being exposed successfully to customers.

Yes, there are many ways to mess this up. You might say it’s even impossible to get it right. These ideas have spawned many closely related methodologies and team designs (e.g. SREs at Google, Netflix’s Platform Engineering team, etc. pp.). But evidence confirms: getting all lifecycle functions to work (more) cross-functional will leave you better off than in a siloed environment. 

## A pessimistic look at the state of Machine Learning teams
Obviously, I’m trying to go somewhere with this. Machine Learning as a discipline is exactly where software development was in the early 2000s: just before the dawn of DevOps. Unless you’re in some hotshot startup, you own all data, and every one of your engineers is a core contributor to Kubeflow, your reality will look a bit bleak:

* ML teams have little to no influence over the data they get. The data might be owned by a different team, or worse, a customer.  
* There is no close communication between ML and data owners.  
* Schemas and feature quality changes.  
* The delivery of data is not standardized.  
* ML teams have to run their own infrastructure. Support from your Platform team ended at “Here, I created an AWS IAM account for you”.  
* Nobody in your ML team has prior experience as a Software Developer.  

## A better way
Nothing I’m about to say should sound like a revelation. I’ll paint the picture by using an example: A team running the search engine on an e-commerce platform. They need engineers with an understanding of high-performance processing, databases, and API design. They will need to be able to rely on the upstream product data staying consistent. They need to understand how their search engine is used in the frontend, and what performance metrics they need to be able to provide. They need to own the APIs used by downstream teams, e.g. the Frontend or your mobile app. Abstracted, they need to get

* The right cross-functional resources/skills  
* Structured upstream data as input  
* Clear business requirements  
* Full ownership of their service   

The same applies to Machine Learning teams if they’re supposed to be successful:

### Skills 
Your team will be responsible for preprocessing input data it receives, training ML models, evaluating fulfillment of business criteria, and delivering results to downstream stakeholders. Therefore, the skills your team will need are:

* Software Engineering to write performant standardized preprocessing code and to expose results as a service
* Operations/SRE to build reproducible ML pipelines and reliable model serving services, both with potentially high resource demand  
* Machine Learning to build performant models  
* Data Science to evaluate input data and output results  

### Upstream input

Data needs to be reliable if a team is supposed to generate value from it. The team and the upstream data provider need to agree on the frequency of data provision, data format, and data quality. The easiest and best agreement can be found in code, e.g. through data ingestion pipelines with strong data validation built-in, but it can be beneficial later on to establish a feature store for your Machine Learning team. Horizontally aligned Data Operations teams can help if more than one team is reliant on similar data.

### Business objectives
Surprisingly many projects fail due to muddy business objectives. Business stakeholders and the ML team need to come together and thoroughly define what the business is trying to achieve, and how it affects the model performance indicators. At a minimum, the business and the team need to answer these questions:

* How to deal with false-positives, false-negatives?  
* Do predictions need to be real-time, or is batch inference fine?   
* What biases need to be accounted for?   
* Which downstream services need to consume model results?  

### Ownership
Probably the most controversial point in this blogpost concerns ownership. After transitioning multiple teams across companies towards full ownership of their software development lifecycle I’m a firm believer in the approach. Teams need to be responsible for providing the actual value, not just the artifact itself. It drives healthy decision-making (e.g. how big can the final model be, how much resources can it use), and it breeds a deeper understanding of the actual needs of downstream consumers. After all, if the served model does not create a positive impact on someone downstream, the efforts of the team should have been applied elsewhere.

## What now?
Your teams are now cross-functional, and everyone is eager to jump to work. But what now? How does the work of a successful ML team look like in production? We got you covered on that front, too - check out our blog post on the [12 factors of reproducible Machine Learning in production](https://blog.zenml.io/12-factors-of-ml-in-production/).

