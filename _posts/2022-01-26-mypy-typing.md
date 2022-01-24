---
layout: post
author: Alex Strick van Linschoten
title: "Type hints are good for the soul, or how we use mypy at ZenML"
description: ""
category: zenml
tags: tooling python tech-startup
publish_date: January 26, 2022
date: 2022-01-26T00:02:00Z
thumbnail: /assets/posts/mypy-typing/mypy-logo.png
image:
  path: /assets/posts/mypy-typing/mypy-logo.png
  # height: 1910
  # width: 1000
---

This one gets a bit technical, but stick with me. Imagine you come across the following code in some codebase:

```python
dates = [...]

def process_date(input):
	date = extract_date(input)
	dates.append(date)
	return date
```

If you were calling this function somewhere in your own code, how would you reason about how to use it? We have an `extract_date` function (defined elsewhere in the code), but we have no real sense of what this input parameter would be. Are we taking in strings as input? Are we taking in `datetime.datetime` objects? Does the `extract_date` function accept both, or do we need to ensure that we are only taking a specific type? And what does it even return? A `datetime.datetime` object? A string?

The fact that there are so many unknowns in even this very trivial example suggests a bigger problem: given that Python is a dynamically-typed language, how do we ensure that our codebase is robust? We not only care that things work as we'd expect them to work, but also that this code won't require excess maintenance or troubleshooting as long as it is part of our codebase.

The dynamic nature of Python allows us to develop with speed and be flexible, but that comes with a cost. If you're not being careful, it can be easy to trade short-term expediencey for long-term maintainability. This is the problem that type hinting tries to solve from a variety of angles. You use typecheckers like [`mypy`](http://mypy-lang.org/) to make sure you're actually doing what you said you would do in your code in terms of the types you're passing around between functions, and you have a boost in readability and communication that comes from your annotated function signatures. In the end, we want code that's easy to use, read and maintain. Type hints help move you a bit closer to that goal.

At ZenML, we use type hints and type checking extensively both in our codebase as well as our day-to-day workflow. This was something we introduced in a systematic way — [thanks](https://github.com/zenml-io/zenml/pull/117) [Michael](https://github.com/zenml-io/zenml/pull/137)! — for the [post-0.5.0 ZenML](https://blog.zenml.io/release_0_5_x/) and we haven't looked back!

I personally didn't have much experience working with types in Python prior to joining ZenML, so I read the first part of [Patrick Viafore](https://www.linkedin.com/in/patviafore)'s excellent book, ['Robust Python'](https://www.amazon.com/Robust-Python-Write-Clean-Maintainable/dp/1098100662?tag=soumet-20), to understand more. (I wrote a series of articles summarising the chapters in detail [here](https://mlops.systems/categories/#robustpython), so check that out if you want to dive a bit deeper.)

## Refresher: how are type hints used in Python?

Before getting into the specific details of how we use all this at ZenML, a quick review is probably in order. Take a look at the following type-hinted code:

```python
name: str = "alex"

def some_function(some_number: int, some_text: str = "some text") -> str:
	# your code goes here
	return "" # returns a string
```

You can see the different places that type annotations might appear. You can annotate variables in your code. I’ve seen this one less often, but it’s possible. Then you can have type annotations for the parameters when defining functions (some even with default values assigned). You can also have type annotations for the return value of those functions.

Note that type hints are not used at runtime, so in that sense they are completely optional and don’t affect how your code runs when it’s passed through the Python interpreter. (Type hints were introduced in Python 3.5, though there is a way to achieve the same effect using comments and a standard way of listing type annotations that way if you are stuck with a Python 2.7 😱 codebase.)

With some type annotations added to our code, we can use a typechecker like `mypy` to see whether things are really as we imagine. In Viafore’s own words:

> “type checkers are what allow the type annotations to transcend from communication method to a safety net. It is a form of static analysis.”

If your codebase uses type annotations to communicate intent, and you’re using `mypy` to catch any of those type errors, remember that typecheckers only catch this certain type of errors. You still need to be doing testing and all the other best practices to help catch the rest.



# How does all of this work in practice for us?

- mypy
- pre-commit checks
- strict mode

# Restate why all of this stuff is helpful

# tips for implementing type hints in a legacy codebase

- stuff from ch. 7