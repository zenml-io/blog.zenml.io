---
layout: post
author: Hamza Tahir
title: DUPLICATE
publish_date: May 1st, 2020
date: 2020-05-01T10:20:00Z
image:
  path: /assets/logo_sq.png
  height: 100
  width: 100
---

I use this article to test shit.

```yaml
split:
  index_ratio: {train: 0.7, eval: 0.3}
  ...


features:
  occupation: {}
  race: {}
  age: {}
  ...

evaluator:
  native_country: {}
  ..

labels:
  income_bracket:
    loss: binary_crossentropy
    metrics: [accuracy]

trainer:
  architecture: feedforward
  layers:
  - {type: dense, units: 128}
  - {type: dense, units: 128}
  - {type: dense, units: 64}
  last_activation: sigmoid
  train_batch_size: 16
  train_steps: 2500
  optimizer: adam
  ...
``
```
