---
layout: post
author: Baris Can Durak
title: Predicting the winner of a DotA 2 match using distributed deep learning pipelines
tags: legacy
publish_date: May 7th, 2020
date: 2020-05-01T10:20:00Z
category: zenml
tags: [applied-zenml, machinelearning, pipelines]
thumbnail: /assets/posts/dota2.svg
image:
  path: /assets/logo_sq.png
  height: 100
  width: 100
---

In the last decade, machine learning applications have proven their capabilities and potential in various
applications. Especially in the past few years, they have gained rapid prominence in the gaming industry and now
there are countless projects creating an endless array of models interacting with different games.

As a machine learning engineer and a person who very much enjoys being a part of the gaming community,
I have always wanted to dip my toes into this pool and to give it a shot myself. I have created a project using
our framework at [ZenML](https://zenml.io/) called ZenML. Today, I would like to show you how I created a
simple, yet powerful, end-to-end ML pipeline which aims to predict the winning team in a game of DotA 2.

Before we dive in, I would like to take a step back and briefly talk about the game for those who are
not that familiar with DotA 2.

### DotA 2

[DotA 2](http://blog.dota2.com), or also known as Defense of the Ancients 2, is an online strategy game developed
by the company Valve. The game puts two teams of five players against each other, where the main objective of each
team is to destroy the enemy team's main building before the other.

At the start of each game, players get to select a character to play from a selection of **more
than 110** heroes. Each hero comes equipped with its own unique talents and skill set. While you progress throughout
the game (which usually takes 30 to 60 minutes), you have to battle the enemy heroes, manage your economy, and
coordinate with your team to destroy the enemy's base.

The game has a significantly large player base. As I am writing this blog post, there are 600,000+ active
players in the game. Additionally, with the emergence of e-sports in the last decade, it has also become
one of the leading titles in the industry with tournaments for 30+ million dollars.

![the_international_2019](/assets/posts/predicting_winner_dota/dota_scene.jpeg)

Last year's _The International_, the main event organized by Valve every year, had a prize pool of $34.3 million
and reached almost [2 million online viewers](https://escharts.com/tournaments/dota2/international-2019)
during the finals.

From a creative perspective, an online game with **a large player base** where each match is **unique due
to the dynamics of hero selections** provides a perfect ground and potential for
any machine learning practitioner to build a cool project. Perhaps one of the coolest and most popular examples
can be found right [here](https://openai.com/blog/openai-five/).

Now, let's get back to the project!

### The Dataset

The DotA community is amazingly data driven and open for sharing.
Within the scope of this project, I have used a dataset that includes all the parsed data from more than **3.5 million
public matches** (from January 2015 to December 2015), which can be found
[here](https://blog.opendota.com/2015/12/20/datadump/). Full credits of data collection and publication must go to the
great people over at [OpenDota (formerly YASP)](https://www.opendota.com/).

For this project, I have put the dataset on a table in [Google BigQuery](https://cloud.google.com/bigquery),
which allows for easier exploration of the data, and is a database ZenML can automatically plug into.
Please let me know if you would like access to this BigQuery table as well - I am working on making it more
accessible to the community.Each entry in the table (which corresponds to a single match) includes a large number of features
ranging from first blood timings, gold advantages, barracks status to hero picks.

### The Goal

Each hero in DotA 2 has its own strengths and weaknesses. As a result, some heroes are naturally better or worse when
they are played against certain opponents. Selecting the right hero to play can easily be the distinguishing factor between a
victory and a defeat. That is why drafting plays such an important role in the game.

The **goal** of this project is to put this idea to test and understand whether we can make a sensible prediction about
the outcome of the game based solely on the selection of heroes.

### The Model

Before I talk about the architecture of the model, I would like to put an emphasis on two important challenges:

1. Each hero in DotA 2 has its own skills and role within the game. Unfortunately, it is impossible
   to put this information into a format that is directly interpretable by a machine learning model.
2. DotA 2 is a team game and each team has 5 heroes. What makes up a good team is not just about selecting 5
   powerful heroes but building a joint composition of heroes with good compatibility with each other while maintaining a
   powerful opposition to the enemy team.

I need to figure out a way to represent each hero separately, and moreover, I have to represent the concept
of a team. In order to overcome these problems, I got a little bit of inspiration from [natural language processing (NLP)
models](https://machinelearningmastery.com/what-are-word-embeddings/).

I have treated heroes in the selection pool like words in a dictionary, i.e., the first layer in the architecture is
an embedding layer, which learns how to create a representation for each individual hero. Moreover, as words come
together and form sentences, in this case, the heroes come together and form teams. Since the order of heroes also
does not play a role, I have used an average pooling layer, which pools up the 5 heroes within the same team.
The output of this pooling layer is then fed to a fully connected network which ultimately makes the prediction.

# Creating the pipeline

In order to put everything into a single end-to-end pipeline with ZenML, all I have written was a single YAML
file. In this section, I will briefly mention some of the critical blocks in this file that are relevant to our topic.
However, if you would like to learn about further details, you can check our docs [here](https://docs.zenml.io/).

We start off with the feature selection. Each key under the main key `features` will denote the name of a data column
that is utilized during the training. In our dataset, each column holds an integer value ranging from 0 to 112.
This value represents the id of a selected hero for that player in that match. For instance, `p_2_hero_id` holds the
index of the hero `Player 2` has selected. Furthermore, `Player 0` to `Player 4` form the first team, whereas
`Player 5` to `Player 9` form the second.

```yaml
features:
  p_0_hero_id: {} # hero id of player 0
  p_1_hero_id: {} # hero id of player 1
  p_2_hero_id: {} # hero id of player 2
  p_3_hero_id: {} # hero id of player 3
  p_4_hero_id: {} # hero id of player 4
  p_5_hero_id: {} # hero id of player 5
  p_6_hero_id: {} # hero id of player 6
  p_7_hero_id: {} # hero id of player 7
  p_8_hero_id: {} # hero id of player 8
  p_9_hero_id: {} # hero id of player 9
```

As for the label, the configuration is quite trivial. The problem can be interpreted as a binary classification
problem (thus the binary cross-entropy loss function) and I have selected the data column `radiant_win`, which holds
the value of either `0` or `1`, depending on the outcome of the game. Ultimately, the model is evaluated on its
accuracy.

```yaml
labels:
  radiant_win:
    loss: binary_crossentropy
    metrics: [accuracy]
```

The `split` key is used to configure how the pipeline reads the data from the source and splits it into a training and
an evaluation dataset. The first part of the block is quite self-explanatory - it is an 80-20 split. However, the second
part needs some explanation.

Amongst the 3.5 million matches, we have only used a match if:

- the mode of the game was either `all pick` or `all draft`
- the game was played by 10 human players (so no bots)
- the game was won by either one of the teams
- the game was either a `normal` game or a `ranked` game
- the game was played during either patch 6.84 or patch 6.85 (getting rid of the infamous 'ho ho ha ha' patch)

In the end, we had a total of **2.835.720** matches remaining.

Small note: If you would like to learn what the constant values stand for, you can check
[here](https://github.com/odota/dotaconstants).

```yaml
split:
  index_ratio:
    train: 0.8 # train dataset ratio
    eval: 0.2 # eval dataset ratio
  where:
    - "(game_mode = 1 or game_mode = 22)" # all pick or all draft
    - "human_players = 10" # no bots
    - "(radiant_win = 0 or radiant_win = 1)" # one side won
    - "(lobby_type = 0 or lobby_type = 7)" # normal or ranked
    - "timestamp >= '2015-05-01T00:00:00'" # starting from 6.84
    - "timestamp <= '2015-12-16T00:00:00'" # until the end of 6.85
```

Ultimately, there is the `trainer` configuration. I will not go over the details, but in a short explanation, it
creates a simple feedforward neural network dealing with a binary classification problem. As explained before, the
input goes through an embedding layer first, followed by an average pooling layer. The output is fed into fully
connected layers, which ultimately handle the prediction.

```yaml
trainer:
  architecture: feedforward # a feedforward network
  type: classification # a classification task
  train_steps: 60000 # the total number of batches to be used in the training
  save_checkpoints_steps: 2000 # the number of steps, after which the evaluation will periodically be recorded
  train_batch_size: 256 # the size of a training batch
  eval_batch_size: 256 # the size of an evaluation batch
  last_activation: sigmoid # the activation function in the output layer
  num_output_units: 1 # the number of units in the output layer
  optimizer: adam # the type of the optimizer
  layers:
    - { input_dim: 113, output_dim: 16, type: embedding } # embedding layer / second try with output_dim:3
    - { pool_size: 5, strides: 5, type: average_pooling } # pooling layer
    - { type: flatten } # flattening
    - { type: dense, units: 32 } # dense layer
```

# Results

By using different variations of the aforementioned config file, I have created two pipelines with different
embedding dimensions, respectively 16 and 3.

In total, it took roughly 50 minutes to completely execute the first pipeline, whereas the second pipeline took only 21.
The drastic difference between the execution time of both runs is due to [caching](<(https://docs.zenml.io/docs/developer_guide/caching)>).
Whilst working on a project on ZenML, you can choose to save the outputs of your intermediate steps within your
pipeline. Because once you execute a similar pipeline, this might come in handy.

For instance, in our case, I have initially ran the first pipeline. Once it was finished, I ran the second pipeline,
where every step from the data ingestion up until the embedding layer was identical. So, the second pipeline opted to
safely skip these steps and use the intermediate outputs from the first pipeline, saving both time and computation cost.

Additionally, almost every step along the way such as data ingestion or pre-processing was handled in a distributed
manner except for the training (which is a feature coming soon).

As for the actual results, both models achieved a similar accuracy around **59-60%** on the validation dataset. Considering
the small set of features and the limited number of matches, they were both deemed to be successful, bearing in
mind that the predictions are practically made right after the drafting phase and before the actual gameplay starts.

# Conclusion

DotA 2 is an ever-changing game. Some heroes can be extremely good or terribly bad depending on the current version of
the game. But one thing which always stays the same is the fact that drafting is an integral part of any game in DotA2
and this project shows that it plays a critical role in the outcome of the game.

It is also important to note that this was achieved by a model, which relied solely on the hero picks without any
additional information. Taking all the other available features into consideration, it barely scratched the surface of
what is possible when it comes to analyzing different aspects of a DotA 2 match. I am already building up to another
follow-up project (possibly with a follow-up blog post) in my head with a deeper look into the output of the embedding
layer with different heroes.

On a more general level, it is also important to note that this whole experiment was conducted using an end-to-end
pipeline which required just a yaml configuration file to execute. Since _serving_ is one of the features that
we are planning to publish soon, this yaml file could very well be the only thing standing between a developer and
a deployed model in an application.

Finally, if you are interested in ZenML, you can find more details on our website right
[here](https://zenml.io/). Additionally, if you have any questions or any other cool ideas which can be applied
to this dataset, feel free to reach me at [baris@zenml.io](mailto:baris@zenml.io).
