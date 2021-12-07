---
layout: post
author: Hamza Tahir
title: Spot the difference in ML costs
description: "Spot instances are a great option for anyone training machine
learning models; they're much cheaper than other on-demand options, albeit with
some drawbacks."
category: mlops
tags: cloud machine-learning zenml legacy
publish_date: January 28th, 2021
date: 2021-01-28T00:02:00Z
thumbnail: /assets/posts/12factor.svg
image:
  path: /assets/posts/12factors.png
  height: 1910
  width: 1000
---

Every organization at any scale understands that leveraging the public cloud is a trade-off between convenience and
cost. While cloud providers like Google, Amazon and Microsoft have immensely reduced the barrier of entry for
machine learning, GPU costs are still at a premium.

There is an [increasing fear in the machine learning community](https://venturebeat.com/2020/06/01/ai-machine-learning-openai-gpt-3-size-isnt-everything/)
that the true power of machine learning is still within the hands of the few.
The flagship example of this is OpenAI's massive GPT-3 model containing 175 billion parameters, a memory footprint of
350GB and reportedly costing at least [$4.6 million](https://lambdalabs.com/blog/demystifying-gpt-3/) to train.
The trend also looks set to continue: Rumours consistently circulate regarding the next generation GPT-4's size, with some estimates ranging in the order of
[**trillions** of parameters](https://www.metaculus.com/questions/4852/how-many-parameters-will-gpt-4-have-if-it-is-released-in-billions-of-parameters/).
Even with more efficient training techniques, these models will still cost in the order of millions to train.

For the rest of the ML community, there is now an increasing reliance on their secret weapon: Transfer learning. Just recently,
the excellent [HuggingFace](https://huggingface.co/) library [announced a simple method](https://twitter.com/huggingface/status/1351560093658198022)
to fine-tune large-scale parameter models on a single cloud GPU. This gives hope to ML practitioners that even if they
are unable to train models from scratch, utilizing the immense power of modern-day
machine learning models is still within reach.

## The need for the cloud

Whether training from scratch, or fine-tuning, it is still clear that public cloud providers offer the most convenient
path to provision and utilize compute resources for most ML practitioners out there. However, even for fine-tuning tasks or
smaller models, these costs can quickly grow and become unmanageable. For example, here is a simple breakdown of much
it costs to train a machine learning model on a relatively mid-tier configuration suitable for many machine learning tasks:

```
| Provider | Configuration           | Cost ($/h)    |
|----------|-------------------------|---------------|
| GCP      | n1-standard-16 with P4  | 1.36          |
| Azure    | NV6 with M60            | 1.14          |
| AWS      | g3.4xlarge with M60     | 1.14          |
```

Bear in mind that the above costs are just for one training run. Most machine learning projects go through much more
experimentation phases, and these numbers add up quickly. Therefore, most ML teams who do not have vast budgets on their
hands usually resort to sampling their datasets and portioning out big training runs for when they are sure.
This can be slow and tedious, not to mention hard to coordinate. It can also lead to teams converging to the wrong
results. If the smaller, sampled datasets are not representative of the larger dataset, it can lead to frustrating and diverging
results as the models develop.

## Spot instances: A perfect fit for ML experimentation

Would it not be easy if ML practitioners had the luxury to launch experiments without having to fret so much about the
costs exploding over time? There might be just be a solution, offered by all major cloud providers, and severely underutilized
by the machine learning community: **Preemptible/Spot instances.**

The word preemptible instance is largely a Google Cloud Platform term, while spot instance is used by AWS/Azure. Whatever you call it,
the concept is the same: These instances cost a fraction of the cost of normal instances, and the only catch is that there is no
guarantee that the instance stays up all the time. Usually, this means that within 24 hours the instance is shut down by the provider.

These sorts of instances are a mechanism for the cloud providers to maximize the utilization of all their resources at any
given time. They are intended for batched, non-critical workloads.
Most trainings jobs for the majority of the use-cases out there take less than 24 hours to complete. And even if the
job is interrupted before that happens, they can almost always be restarted from checkpoints.

## Cost comparison: 80% cost reduction

Therefore, machine learning training fits the intended use of spot instances perfectly.
By using these instances, practitioners stand to gain massive cost reductions. We have conducted a rough analysis
across the three major cloud providers to showcase the cost benefits. The raw data can be found [here](https://docs.google.com/spreadsheets/d/1wErQviA3sI22fh3BscO4CMJyg6w1Qqi468O1bCxUFhc/edit?usp=sharing).
Feel free to share the doc and leave a comment if you find something to add. Here is a snapshot, with the same configurations as before:

```
| Provider | Configuration           | Cost ($/h) | Spot Cost ($/h) | Savings |
|----------|-------------------------|------------|---------------------------|
| GCP      | n1-standard-16 with P4  | 1.36       | 0.38            | 72%     |
| Azure    | NV6 with M60            | 1.14       | 0.20            | 82%     |
| AWS      | g3.4xlarge with M60     | 1.14       | 0.34            | 70%     |
```

Note: All costs in the US region, AWS instance pricing as of January 28, 14:00 CET.

As can be seen, depending on the configuration, there is up to **82%** cost reduction by using spot instances, with the
average cost savings across multiple cloud and configurations being rougly **74%**. This can equate to hundreds of dollars worth of
savings. Especially for hobbyists, smaller companies, or smaller departments experimenting with
Machine Learning, this may mean the difference between getting a model deployed vs crashing and burning before lift-off.

Using this technique is not new: Way back in 2018, the FastAI team [trained ImageNet in 18 minutes with 16 AWS spot
instances](https://www.fast.ai/2018/08/10/fastai-diu-imagenet/). This cost $40 at the time, and was the most public
display of the insane cost benefits of spot instances in the community.

However, given the trend of increasingly big models, and the increasing adoption of AI worldwide, I can only see the
need for spot instance training increasing over time. Given the dramatic difference in costs, it is almost a no-brainer
to use spot instance training as a primary mechanism for training, at least in the experimentation phase.

## ZenML: A simple tool to orchestrate spot instance training

If you’re looking for a head start for spot instance training, check out [ZenML](https://github.com/zenml-io/zenml),
an open-source MLOps framework for reproducible machine learning. Running spot pipeline in ZenML, is as easy as :

```python
training_pipeline.run(
    backend=OrchestratorGCPBackend(
        preemptible=True,  # reduce costs by using preemptible (spot) instances
        machine_type='n1-standard-4',
        gpu='nvidia-tesla-k80',
        gpu_count=1,
    )
)
```

[See gist here](https://gist.github.com/htahir1/62dc4baa12560e8b88ce156f76aaab5f)

ZenML not only zips your code up to the instance, it also makes sure the right CUDA-drivers are enabled to take advantage of the
accelerator of your choice. It provisions the instance, and spins it down when the pipeline is done. Not to mention the other benefits of
experiment tracking, versioning and metadata management which is
provided anyway by the framework. Give it a spin yourself: A full code example can be found [here](https://github.com/zenml-io/zenml/tree/main/examples).

AWS and Azure support is on the horizon, and we'd love your feedback on the current setup. If you like what you see,
leave us a [star at the GitHub repo](https://github.com/zenml-io/zenml)!
