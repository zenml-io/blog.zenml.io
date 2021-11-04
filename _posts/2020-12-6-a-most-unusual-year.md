---
layout: post
author: ZenML Team
title: A most unusual year
publish_date: December 26th, 2020
category: tech-startup
tags: covid tech-startup
date: 2020-12-26T00:02:00Z
thumbnail: /assets/posts/a_most_unusual_year.svg
tags: legacy
image:
  path: /assets/posts/a_most_unusual_year.png
  height: 1200
  width: 628
---

As this is the end of the year, it's a great chance to remind yourself: how did we get here?

Let me begin with a flashback to 2019. As a company, we're focussed on optimizing remaining useful live of industrial assets through clever use of Machine Learning for predictive analysis, root-cause analysis and other forms of reasoning. We managed to secure a few big projects and very promising POCs, and across the board we were able to show good results. One of our projects even got government funding, providing a nice runway going forward.

We got the traditionally lengthy sales cycles with many leading industry players started, and we even hired our first full-time employee.

All was set up for first commercial success of our approach and our "asset optimization platform" in 2020.

Then the pandemic hit. Within a few weeks, all our sales leads fizzled away - millions of euros in deal sizes, disappeared in thin air. By March, we were looking at an empty sales funnel.

We had find a new path. We took stock, and we acted entrepreneurial.

## A look at what we've got

Taking stock of what we actually had, in terms of intellectual property, was a great recap of our journey so far [(if you're interested, check out a talk I recently gave on what we learned about ML pipelines)](https://www.youtube.com/watch?v=UDfxoKmc8qc). To summarize, we had to our name:

- A great team (experienced ML engineers, Ops expertise and a good entrepreneurial fit)
- A purpose-built tech stack for reproducible ML pipelines
- Experience running small and large projects
- A good network of other startups and developers in ML-related positions across the globe

## Talking to people

We saw the economic effects of the pandemic very early - at least from an european perspective. After taking close stock, we had to understand how (and if) Machine Learning would continue to play a role for our leads and network. Taking a page out of the great UX researchers I've had the chance to work with over my career, we decided to do user interviews. Lo and behold, after doing ~30 early interviews, a picture emerged.

Teams engaged in ML projects lost significant chunks of time on unrepeatable projects as well as managing dysfunctional franken-infrastructures. Teams not yet engaged in ML feared it to be a black hole for time and effort to build up a reliable tech stack for getting experiments into production, as existing systems would need integration at many stages of the ML lifecycle.

An interesting side-fact became clear to us, too: there was a lot of skepticism towards ML-based SaaS products, but a lot of trust towards dev-tooling.

More importantly, however - we had solved exactly the problems our interviewees faced for ourselves. We were sitting on something commercially relevant, and we were looking at a great opportunity.

## Understanding your market, part one

With this new-found confirmation we set out to transform our tech-stack from internal-facing supportive tooling to an actual product. Looking at the market, a split was noticeable.

On the one side, open-source tooling like Kubeflow and MLFlow was solving aspects of the MLOps problem space, but posed significant investments to the teams we were talking to in our interviews. Tooling was either missing the point of Data Scientists, or alienated product leads and DevOps teams with convoluted, messy or badly documented paths from experiment to production.

On the other side were very expensive commercial solutions, attempting to solve large chunks of the ML lifecycle with proprietary offerings.

## Commercial-first

Given the layout of the MLOps market, we spotted an opportunity to flip the proverbial table. Don't get me wrong, we're not radical geniuses, we much rather are interested observers of entrepreneurial trends. Given the success of Stripe, Segment and others, this constellation of players screamed "transactional business model" to us. A managed MLOps platform to train models easily in various public clouds, at linearly scaling prices, based on actual usage, not arbitrary license models or per-seat, and at a fraction of the going rates.

## Understanding the market, part two

By now we know: Our hypothesis, teams are just waiting for a managed MLOps solution with usage-based pricing and reproducible pipelines as focus, was off. This was not immediately clear to us, of course.

One of our smartest plays saved us in the end - we never stopped doing user interviews. We demo'ed our product status quo multiple times per week, we had two soft-launches and continuously engaged with the community on conferences, reddit, slack - you name it.

And people loved our take on MLOps. Our vision resonated deeply. All model trainings are guaranteed to be reproducible, tracking is deeply baked-in, integrations to popular tooling are easy and extensible - these are the key concerns of the teams we were talking to.

However, it would have been ludicrous to switch their tech-stacks to a commercial solution. No, if we wanted to drive adoption and actually have an impact on how the world dealt with MLOps, we had to give these teams the option to adopt our vision in their projects on their own terms. We had to open-source.

As I've written in the past, [we are huge proponents of open-source software](http://blog.zenml.io/open-source). Large parts of our own tooling wouldn't be possible without the work of open-source giants, on whose shoulders we can stand.

## The jury is still out

As of writing this, the jury is still out if we're leaving the dent in the universe that we want to leave behind. But, and this is a hugely rewarding feeling, we have all the right indications that we nailed it this time. We've breached 200 GitHub stars in less than a week of going public, we've been on the front page of Hackernews, we've been trending on GitHub, and ZenML is racing to 1000 `pip install`'s.

If you're running ML projects, or just personally got curious, head over to [ZenML's GitHub page](https://github.com/zenml-io/zenml) and get started with reproducible Machine Learning!
