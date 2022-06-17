---
layout: post
author: Ayush Singh
title: Segmenting Stomach and Intestines from MRI Scans Using ZenML
description: "We built an end to end production-grade pipeline using ZenML for a computer vision problem where our problem was to segment stomach and intestine from MRI scans."
publish_date: May 27, 2022
date: 2022-05-27T10:20:00Z
tags: machine-learning mlops evergreen applied-zenml pipelines zenfile
category: zenml
thumbnail: /assets/posts/customer-churn/poster.jpg
image:
  path: /assets/posts/customer-churn/poster.jpg
  height: 100
  width: 100
---

[Gastrointestinal cancer](https://en.wikipedia.org/wiki/Gastrointestinal_cancer#:~:text=Gastrointestinal%20cancer%20refers%20to%20malignant,large%20intestine%2C%20rectum%20and%20anus.) refers to malignant conditions of the gastrointestinal tract (GI tract) and accessory organs of digestion such as stomach, esophagus and other organs of digestion. During treatment of gastrointestinal cancer, doctors must manually outline the position of the stomach and intestines in order to adjust the direction of the x-ray beams to increase the dose delivery to the tumor and avoid the stomach and intestines. This is a time-consuming and labor intensive process that can prolong treatments from 15 minutes a day to an hour a day. Doctors needs a method to automate this process.

So I will create a model to automatically segment the stomach and intestines on Magnetic resonance imaging (MRI) scans. We will be using data from UW-Madison GI Tract Image Segmentation Competiton to build our model.
