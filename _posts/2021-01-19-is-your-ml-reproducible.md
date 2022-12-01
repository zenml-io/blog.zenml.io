---
layout: post
author: Hamza Tahir
title: Is your Machine Learning Reproducible?
description: "Short answer: not really, but it can become better!"
publish_date: January 19th, 2021
category: mlops
tags: machine-learning reproducibility zenml legacy evergreen
date: 2021-01-19T00:02:00Z
thumbnail: /assets/posts/reproducibility-thumb.svg
image:
  path: /assets/posts/reproducibility.png
  height: 1910
  width: 1000
---

**Last updated:** February 16, 2022.

It is now widely agreed that
[reproducibility is an important aspect of any scientific endeavor](https://blog.ml.cmu.edu/2020/08/31/5-reproducibility/).
With Machine Learning being a scientific discipline, as well as an engineering
one, reproducibility is equally important here.

There is widespread fear in the ML community that we are living through a
[reproducibility crisis](https://www.wired.com/story/artificial-intelligence-confronts-reproducibility-crisis).
Efforts like the
[Papers with Code Reproducibility Challenge](https://paperswithcode.com/rc2020),
signaled a clear call-to-action for practitioners, after a 2016 Nature survey
revealed that
[70% of results are non-reproducible](https://www.nature.com/news/1-500-scientists-lift-the-lid-on-reproducibility-1.19970).

While a lot of the talk amongst the community has centered on
[reproducing machine learning results in research](https://www.sciencedirect.com/science/article/pii/S2666389920300933),
there has been less focus on the production side of things. Therefore, today
let’s focus more on the topic of reproducible ML in production and create a
larger conversation around it.

## Why is reproducibility important?

<div class="text-center py-3 blockquote">
  “If you can’t repeat it, you can’t trust it” - All Ops Teams
</div>

A good question to start with is why exactly reproducibility is important, for
machine learning in particular. Here are list of benefits one gains by ensuring
reproducibility:

- Increases **trust**
- Promotes **explainability** of ML results
- Increases **reliability**
- Fulfills **ethical**, **legal**, and **regulatory** requirements

Concretely, ML models tend to go through a lifecycle of being destroyed, forged
anew and re-created as
[development evolves from rudimentary notebook snippets to a testable, productionized codebase](https://blog.zenml.io/technical_debt/).
Therefore, we better make sure that every time a model is (re-) trained, the
results are what we expect them to be.

## What's the big deal?

One would think that reproducibility in production ML should be easy. After all,
most machine learning is scripting. How hard can it be to simply execute a bunch
of scripts again at a later stage and come to the exact same result, right?

**wrong**

Reproducibility of machine learning is hard because it spans many different
disciplines, from understanding non-deterministic algorithmic behaviors, to
software engineering best practices. Leaving aside the fact that most machine
learning code quality tends to err towards the low side (due to the experimental
nature of the work), there is an inherent complexity to ML which makes things
even harder.

E.g. Just training a model on the same data with the same configuration does not
mean the same model is produced. Perhaps one could achieve a similar _overall_
accuracy (or whatever other metric), but even a slight change in parameters
might skew metrics for slices of your data - leading to
[sometimes very unpleasant results](https://www.theverge.com/2018/1/12/16882408/google-racist-gorillas-photo-recognition-algorithm-ai)

So, how can we ensure that stuff like does not happen? In my opinion, one can
break down reproducibility in the following aspects:

- The code
- The configuration
- The environment
- The data

Let's look at each of these in turn.

### Code

Checking code into a version control system like Git ensures a clean trace of
how code evolves, and the ability to rollback to any point in history. However,
Git alone is not a fix for reproducibility, but only for one aspect of it.

In reality, reproducibility in production is solved by version control, testing
of code as well as integrations, and idempotent deployment automation. This is
hard to apply in practice. E.g. The main tool for ML is Jupyter notebooks, which
are notoriously difficult to check into version control. Even worse, most
notebook code is not sequential in its execution, and can have an arbitrary,
impossible to reproduce, sequence of execution.

But even if ML practitioners follow a pattern of refactoring their code into
separate modules, simply checking modules into source control is still not
enough to ensure reproducibility. One needs to link the commit history to model
training runs and models. This can be achieved e.g. by enforcing a standard in
your team that pins a git sha to experiment runs. That way there is a global
unique ID that ties the code and configuration (see below) to the results it
produced.

### Configuration

Software Engineering preaches separation of application code and application
configuration to allow for predictable and deterministic software behavior
across environments. This actually translates well in a machine learning code:
E.g. one can separate the model definition and training loop code, from the
associated hyper-parameters which define the configuration.

The first step to unlock reproducibility is to actually separate configuration
from code in the first place. For me this means, the code itself should NOT
define:

- Features
- Labels
- Split parameters (e.g. 80-20 split)
- Preprocessing parameters (e.g. the fact that data was normalized)
- Training hyper-parameters (including pre-processing parameters)
- Evaluation criteria, .e.g, metrics

Ideally all these are tracked separately in a
[declarative config](https://blog.zenml.io/declarative_configs_for_mlops/) that
is human readable.

### Environment

If a ML result is produced on a dev local machine, there is a high chance it is
not going to be reproducible. Why? Because developers, especially relatively
inexperienced ones, are not super diligent in creating and maintaining proper
virtual environments.

The obvious solution for this one is containerizing applications, with lets say,
[Docker](https://docker.com/). However, here is another example of when skills
of ML practitioners begin diverging from conventional software engineers. Most
data scientists are not trained in these matters, and require proper
organizational support to help and encourage them to produce containerized
applications.

### Data

And finally, we arrive at the data. Data versioning has become one of the most
discussed topics in the production machine learning community. Unlike code, you
can't simply check data into version control easily (although tools like
[DVC](https://dvc.org) are attempting just that).

In the same way as code, achieving basic versioning of data does not necessarily
ensure reproducibility. There is a whole bunch of metadata associated with how
data is utilized in machine learning development, all of which is necessary to
persist to ensure trainings are reproducible.

Here is a simple, but common, example that illustrates this point. If you have
ever worked with machine learning, have you ever created a folder/storage bucket
somewhere that has random files in varying preprocessing states? Something like,
`normalized_1.json` or perhaps even timestamped `12_02_19.csv`? Technically, a
timestamped file is versioned data, but that does not mean associated runs with
it are reproducible: One would have to know how, when and where (i.e. the
aforementioned metadata) these versioned files are used to ensure
reproducibility.

### Concrete Example

While it may fall outside the scope of this blog, the open-source MLOps
framework ZenML showcases a clear example of putting these principles in action
[here](https://docs.zenml.io/benefits/ensuring-ml-reproducibility.html)

## Conclusion

Reproducibility in machine learning is not trivial, and ensuring it in
production is even harder. ML teams need to be fully aware of the precise
aspects to track in their processes to unlock reproducibility.

If you’re looking for a head start to enable reproducibility: check out
[ZenML](https://github.com/zenml-io/zenml), an open-source MLOps framework for
reproducible machine learning - and leave a star while you're there.

Also, hop on over to our [Slack Channel](https://zenml.io/slack-invite) if you
want to continue the discussion.

I’ll be back in a few days to talk about using Git in a machine learning
setting - stay tuned!
