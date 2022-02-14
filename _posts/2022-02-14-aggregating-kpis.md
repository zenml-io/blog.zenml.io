---
layout: post
author: James W. Browne
title: Aggregating and Reporting KPIs on a Schedule
description: "Low barrier of entry reporting pipeline to collect, store, and
display key performance indicators without a data lake."
category: tech-startup
tags: tech-startup python tooling
publish_date: February 14, 2022
date: 2022-02-09T00:02:00Z
thumbnail: /assets/posts/aggregating-kpis/kpi.jpg
image:
  path: /assets/posts/aggregating-kpis/kpi.jpg
---

As somebody who has attempted to work a variety of jobs that all start with
"data..." I have had the importance of having data to guide your decision-making
process in business (or just life in general!) drilled into me. At the same
time, I am also acutely aware of how long and slow of a process it can be to
set up a data warehouse architecture from scratch, especially when you try to
adhere to all the best practice guides and keep everything future-proof.

So, keeping in mind the great Donald Knuth’s advice about premature
optimization being the root of all evil, this post details a lean approach to
tracking important business metrics for a software startup.

## Key Performance Indicators

To make sure you are on the right track as a business, it is always good to
find some easily trackable numeric values that correlate with the financial
success of your business, also known as Key Performance Indicators (KPIs). In
the Software-as-a-Service startup space, there is of course plenty of existing
work that an entrepreneur can use to guide their choice of metrics, such as
this Substack post by David Sacks and Ethan Ruby:
[The SaaS Metrics That Matter](https://sacks.substack.com/p/the-saas-metrics-that-matter).

Although having many KPIs can be useful, the data scientists among the
readership will know how hard multivariate optimization is. Increasing one
metric can simultaneously lead to the decrease of another and vice versa, so
even with these data you are still at a loss on how to act. For this reason, it
is also important to decide on a so-called
[North Star Metric](https://mixpanel.com/blog/north-star-metric/) to guide your
course, the optimization of which should be the final arbiter of how to act. At
ZenML we have decided to use the number of unique active users as our north
star metric, though even this can be viewed in slightly different ways,
depending on which time scale you aggregate on (daily, weekly, monthly).

For a bit more detail on ZenML’s metrics, check out our Substack post written
by Hamza:
[Of metrics and orbits](​​https://zenml.substack.com/p/of-metrics-and-orbits).

## KPI Collector Bot

KPIs can come from many different places and even those that don’t need any
significant computation to derive from raw data still need to be gathered
together and stored centrally if they are to be of any use for the business.
Being a tech startup that deals mostly in Python code, the obvious choice to
automate this gathering is a simple program written in Python, nicknamed the KPI
Collector Bot. Here at ZenML we currently use [Notion](https://www.notion.so/)
to manage our team knowledge base, so it makes sense to use their database
feature as an easy place to store the history of disparate KPIs in a central
place. At the same time, Notion is not the only place we want the gathered
metrics to go, so in addition to collecting, our automation solution also needs
to spread out the aggregated values to multiple destinations.

There are a plethora of data ingestion/processing/transformation tools out
there, sprung up in the last decade or so to deal with ever-increasing data
loads cropping up in the tech space (there is an old trope in big data that
claims that “90% of the world’s data has been created in the last two years”,
though I have not been able to find a credible source for that). But In the case
of our bot, the data in question are so small that there is no reason to go
beyond the standard tools available in Python, though
[Pandas](https://pandas.pydata.org/) provides a more user-friendly API to
interact with tabular data.

The structure of the bot is an ETL pipeline—though a very simple one—where
multiple data sources fan-in to a single collector and these collected data
then fan-out again to multiple destinations.

![KPI Collector Flow Chart](/assets/posts/aggregating-kpis/flowchart.png)

By structuring our code in an extensible fashion, it becomes easy to extend the
sources or destinations:

```python
Pipeline(
    sources=(
        Source(...),
        ...
    ),
    destinations=(
        Destination(...),
        ...
    ),
).process()
```

The main challenge involved here lies not in the processing of the data, but in
the disparate ways in which the data sources need to be accessed. In a perfect
world, every service would have a REST API endpoint that would let you simply
and efficiently request the data you want, however even today there are a
surprising number of platforms that do not report their data except in a web
interface designed for interactive (human) readers. Luckily there are plenty of
tools out there that allow you to programmatically crawl web pages, such as
[Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/). This allows
us for instance to extract the number of posts currently published on this very
blog in an easy way:

```python
import requests
from bs4 import BeautifulSoup  # type: ignore


def get_blog_stats() -> dict[str, int]:
    response = requests.get("https://blog.zenml.io/")
    if response.status_code == 200:
        links = BeautifulSoup(response.text, "html.parser").find_all(
            "a", class_="anthrazit"
        )
        return {"BLOG_TOTAL_POSTS": len(links)}
    else:
        return {}
```


For publically available sites this works, however, when data is behind a log-in
(either because it’s from a private project or a paid service) this approach can
still fall short. If all that is required is Basic Authentication or an API
token, the `requests` library in Python will handle it just fine, though more
complex authentication flows can be more challenging. For accessing analytics
for our [podcast (Pipeline Conversations–go listen to it if you’re a fan of long-form)](https://podcast.zenml.io/),
we used the fully-fledged crawling library [Scrapy](https://scrapy.org/), which
will [handle login forms just fine](https://python.gotrained.com/scrapy-formrequest-logging-in/).

If you are interested in seeing the KPI Collector in its entirety, watch this
space—as soon as it is made open source, the Github repository will be linked
here.

*James W. Browne is a Machine Learning Engineer at ZenML.*

[Image credit: Photo by
<a href="https://unsplash.com/@celpax?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Celpax</a>
on <a href="https://unsplash.com/s/photos/kpi?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>]
