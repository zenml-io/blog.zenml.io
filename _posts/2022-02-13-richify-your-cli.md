---
layout: post
author: Alex Strick van Linschoten
title: "Richify that CLI!"
description: "We recently reworked a number of parts of our CLI interface. Here are some quick wins we implemented along the way that can help you improve how users interact with your CLI via the popular open-source library, rich."
category: tech-startup
tags: tech-startup python tooling open-source zenml
publish_date: February 13, 2022
date: 2022-02-13T00:02:00Z
thumbnail: /assets/posts/richify-your-cli/rich-terminal.png
image:
  path: /assets/posts/richify-your-cli/rich-terminal.png
---

For an open-source tool without a web frontend, one of the main ways users will interact with [ZenML](https://github.com/zenml-io/zenml) is [our command-line interface or CLI](https://apidocs.zenml.io/0.6.1/cli/). I recently worked on an effort to improve the visual experience of anyone using our CLI by integrating the popular open-source library, [`rich`](https://github.com/Textualize/rich), into the code base.

The items that follow are what I consider to be low-hanging fruit for any CLI that is written in Python. You may already have custom solutions or use specific packages that offer certain features. It might be worth considering just getting all of that CLI and terminal goodness from [`rich`](https://github.com/Textualize/rich), however, given that it does so much for you with relatively little dependency bloating that you perhaps might expect.

## 1. All the Emojis!

![Some of the emojis available to you in `rich`](../assets/posts/richify-your-cli/emoji-sampler.png)

Let's cover the important one first 😉: `rich` offers full support for emojis in your CLI interfaces. I'm being slightly flippant here, but only slightly. You may be familiar with emojis as used in chat apps such as the winking face above, but there are hundreds of other, potentially more useful, emojis that you might want to use.

For the ZenML CLI, we went with a ✅ tick emoji to indicate that [an integration](https://docs.zenml.io/features/integrations) was installed when listing the available and supported integrations. We also chose a 👉 pointing hand emoji to indicate which component or stack was currently activated among the various configurations that we allow you to construct. Nothing too fancy in either case, but I think they're more useful and communicative as a user than the other options (like an asterisk, for example). (You'll see examples of how we used them below.)

You can view a list of all the supported emojis by running `python -m rich.emoji` (after `pip` installing `rich`).

## 2. Markdown parsing

![BEFORE AND AFTER PHOTO or gif showing paging through the markdown info](../assets/posts/richify-your-cli/emoji-sampler.png)

Our CLI allows users to view information about [the examples we provide](https://blog.zenml.io/examples-cli/) to showcase how ZenML works (and how it can be used). Each example already contains a markdown `README.md` file with information about the implementation, installation instructions and so on.

We didn't want to duplicate work that had already gone into creating those information sheets, so we used them to allow the user to learn about the examples. A simple `zenml example info mlflow_tracking` was used to output the raw text of the markdown file. For obvious reasons, this wasn't satisfactory from a usability perspective.

Now, with `rich`, we have a way to parse the raw markdown markup and display it as a rich document. What's more, we use [the `pager`](https://rich.readthedocs.io/en/stable/reference/console.html?highlight=pager#rich.console.Console.pager) which gives a familiar interface to anyone interacting with the info document. (In fact, it was searching for an option to handle this markdown parsing that first saw us discover `rich` and all the other things it does.)

## 3. Beautiful, Informative Tracebacks

![IMAGE or gif showing a rich traceback](../assets/posts/richify-your-cli/emoji-sampler.png)

Errors are often where the rubber meets the road in software projects. When you're developing you want those error messages to be informative, clear and not some kind of runic message you have to decode.

With `rich`, you get a complete redesign of how [tracebacks](https://rich.readthedocs.io/en/stable/traceback.html) are displayed, one that I have found far more useful when trying to understand why a particular code change has caused an error. Moreover, you have the option to have local variables displayed alongside the stack trace message, all neatly boxed up to make it clear what you're looking at.

Enabling this as the default way to display Python tracebacks is as simple as adding the following to somewhere that always gets loaded:

```python
from rich.traceback import install
install(show_locals=True)
```

## 4. `print()` gets a makeover

![BEFORE AND AFTER PHOTO showing a rich printout](../assets/posts/richify-your-cli/emoji-sampler.png)

Just like tracebacks in `rich` are better than the Python defaults, you also have a better `print`.

## 5. Inspect your objects

![the best ways to use rich's inspect](../assets/posts/richify-your-cli/emoji-sampler.png)

## 6. Status Spinners

![A gif showing the new spinner for init](../assets/posts/richify-your-cli/emoji-sampler.png)

## 7. Progress Bars

![A gif showing the zenml integration install process](../assets/posts/richify-your-cli/emoji-sampler.png)

## 8. Tables

![A before and after image](../assets/posts/richify-your-cli/emoji-sampler.png)

## 9. Customised message styles

![A gif showing a pipeline running with coloured output](../assets/posts/richify-your-cli/emoji-sampler.png)

## 10. The `rich` logging handler

[a code snippet? as an image?]

CTA: let us (and Will) know if you end up using these tips and the rich library to spruce up your CLI! Get the new ZenML 0.6.2 (or whatever) to use the latest richified CLI goodness. 

*Alex Strick van Linschoten is a Machine Learning Engineer at ZenML.*