---
layout: post
author: Ayush Singh
title: Solving Atari Games with Reinforcement Learning (AI)
description: "We trained a model to solve Atari games using reinforcement learning. We used the Deep Q algorithm as the basis of our implementation. It allowed us to get a working solution fairly quickly."
publish_date: March 17, 2022
date: 2022-03-17T10:20:00Z
tags: tensorflow machine-learning mlops evergreen applied-zenml pipelines reinforcement-learning
category: zenml
thumbnail: /assets/posts/atari.gif
image:
  path: /assets/posts/atari.gif
  height: 100
  width: 100
---

Reinforcement learning is a type of machine learning in which an agent tries to perform actions in a way that maximizes the reward for a particular situation. In supervised learning, we are given the target label which acts as the ground truth for the model so that we can train the model to predict the label for unseen examples. In reinforcement learning, by contrast, there is no target label but the reinforcement agent decides what to do to perform the given task or action in a particular situation and the agent learns from its experience.

According to Wikipedia, 'reinforcement learning' is an area of machine learning inspired by behavioural psychology, concerned with how software agents ought to take actions in an environment so as to maximize some notion of cumulative reward.

An application of reinforcement learning in the field of computational finance is where you want to have a model handle automated trading of stocks and shares. Here the agent is the specific software needed to make trades, the environment is other traders, the state is price history, the possible actions are buy or sell or hold, and the reward is profit/loss.

Another application of reinforcement learning in the field of operations research is exemplified by the challenge taken on by a company like Uber. When calculating how to route vehicles, a naive application of this might be a reinforcement learning algorithm. In this case, the agent is the vehicle routing software, the environment is the stochastic demand, the state is the vehicle locations, capacity and depot requests, the action is the particular route taken by a vehicle, and the reward is the travel costs.

In this article, I will be using ZenML to build a model that can solve Atari games using reinforcement learning. I will be using the [Atari 2600](https://en.wikipedia.org/wiki/Atari_2600) game environment. I will be using the [Deep Q-Learning](https://en.wikipedia.org/wiki/Deep_Q-learning) algorithm to solve the game. I found this Github repo, [Building a Powerful DQN in TensorFlow 2.0](https://github.com/sebtheiler/tutorials/tree/main/dqn), to get started with our solution. 

I will be using [OpenAI Gym](https://gym.openai.com/) which is a toolkit that provides a wide variety of simulated environments (Atari games, board games, 2D and 3D physical simulations, and so on), so you can train agents and compare them. I will be using the `BreakoutDeterministic-v4` environment from OpenAI Gym.

In the real world, building reinforcement learning applications can be challenging so I will be using [ZenML](https://zenml.io/) (an MLOps framework) which allows for the deployment of models which can be used across the organization. ZenML is an extensible, open-source MLOps framework to create production-ready machine learning pipelines. Built for data scientists, it has a simple, flexible syntax, is cloud- and tool-agnostic, and has interfaces/abstractions that are catered towards ML workflows. ZenML pipelines execute ML-specific workflows from sourcing data to splitting, preprocessing, training, all the way to the evaluation of results and even serving.

If you prefer consuming your content in video form, then [this](https://youtu.be/04DbbEzE9ig) video covers the same which we cover in this blogpost.

<div class="embed-responsive embed-responsive-16by9 mb-5">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/04DbbEzE9ig" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Setting up the project

I suggest you create and work out of a virtual environment. You can create a virtual environment using `conda` by following these steps, but of course you can also use whatever you're familiar with:

```shell
conda create -n envname python=x.x anaconda
conda activate envname
```

Before running this project, you must install some Python packages in your environment which you can do with the following steps:

```python
git clone https://github.com/zenml-io/zenfiles.git
cd atari-game-play
pip install -r requirements.txt
```

We're ready to go now. You can run the code, using the `run_pipeline.py` script.

```python
python run_pipeline.py
```

## How it works

The `training_pipeline.py` script is the main file that runs the training pipeline. In brief, the training pipeline consists of several steps which include:

- `game_wrap` which wraps over the game environment that you want to train on
- `build_dqn` which builds a Keras model
- `replay_buffer` which stores the past experiences of the agent
- `get_information_meta` which restores the model from a given checkpoint
- `train` which trains the dqn agent.

![Pipeline Steps](..\assets\posts\updatedreinforcementlearning.gif)

Every step is connected with each other in a way such that output from one step is given as input to another step. The following is the code for the training pipeline:

```python
from zenml.pipelines import pipeline


@pipeline
def train_pipeline(game_wrap, build_dqn, replay_buffer, agent, get_information_meta, train):
    """
    It trains the agent.

    :param game_wrap: This is a function that returns a GameWrapper object. The GameWrapper object wraps
    over the game that you want to train on. It has functions that can be used to get the available
    actions, get the current state, etc
    :param build_dqn: This is a function that returns a DQN. The parameters are the game_wrapper, which
    is the game wrapper object that we created earlier
    :param replay_buffer: The replay buffer is a class that holds all the experiences a DQN has seen,
    and samples from it randomly to train the DQN
    :param agent: The agent that will be used to play the game
    :param get_information_meta: This is a function that returns the frame number, rewards, and loss
    list
    :param train: The function that will be called inside the train_pipeline function
    """
    game_wrapper = game_wrap()
    main_dqn, target_dqn = build_dqn(game_wrapper)
    replay_buffer = replay_buffer()
    agent = agent(game_wrapper, replay_buffer, main_dqn, target_dqn)
    frame_number, rewards, loss_list = get_information_meta(agent)
    train(game_wrapper, loss_list, rewards, frame_number, agent)
```

We can see we have several steps that make up this pipeline, so let's break it down and talk about each step in detail. All the steps can be found in the ``steps/``` folder.

- `game_wrap`: This is a function that returns a GameWrapper object. The GameWrapper object wraps over the game that you want to train on. The GameWrapper class wraps the Open AI Gym environment and provides some useful functions such as resetting the environment and keeping track of useful statistics such as lives left.

- `build_dqn`: It builds the DQN model in Keras.

- `replay_buffer`: The replay buffer is a class that holds all the experiences a DQN has seen and samples from it randomly to train the DQN. It takes care of managing the stored experiences and sampling them on demand.

- `agent`: Implements a standard (Double Dueling Deep Q-Learning Network) DDDQN agent, you can learn more about it from [here](https://towardsdatascience.com/dueling-double-deep-q-learning-using-tensorflow-2-x-7bbbcec06a2a)

- `get_information_meta`: If we're loading from a checkpoint, load the information from the checkpoint. Otherwise, start from scratch. This is a step that returns the frame number, rewards, and loss list, frame number is the number of frames that have been played, rewards is the list of rewards that have been accumulated, loss list is the list of losses that have been accumulated.

- `train`: We initialize the agent, the game environment, and the TensorBoard writer. Then, we train the agent until the game is over.

![Steps in the ZenML pipeline used to train the agent]({{ site.url }}/assets/posts/pipeline_steps.PNG)

Now that you're familiar with the individual steps of the pipeline, let's take a look about how we run it with the `run_pipeline` function. We import every step from the steps folder. We can see that the pipeline is a function that takes various functions as arguments.

```python
from steps.game_wrap import game_wrap
from steps.build_dqn import build_dqn
from steps.replay_buffer import replay_buffer
from steps.agent import agent
from steps.get_information_meta import get_information_meta
from steps.train import train
from pipelines.training_pipeline import train_pipeline
import argparse
from materializer.dqn_custom_materializer import dqn_materializer

def run_training():
    training = train_pipeline(
        game_wrap().with_return_materializers(dqn_materializer),
        build_dqn(),
        replay_buffer().with_return_materializers(dqn_materializer),
        agent().with_return_materializers(dqn_materializer),
        get_information_meta(),
        train(),
    )

    training.run()
```

You'll probably have noticed that some of the steps in this pipeline require custom materializers to be used, so let's take a closer look at those.

### A custom materializer to pass data between the steps

The precise way that data passes between the steps is dictated by materializers. The data that flows through steps are stored as artifacts and artifacts are stored in artifact stores. The logic that governs the reading and writing of data to and from the artifact stores lives in the materializers. You can learn more about custom materializers in the [Materializer](https://docs.zenml.io/v/0.6.3/guides/index/custom-materializer) docs.

```python
DEFAULT_FILENAME = "PyEnvironment"

class dqn_materializer(BaseMaterializer):
    ASSOCIATED_TYPES = [Agent, GameWrapper, ReplayBuffer]

    def handle_input(
        self, data_type: Type[Any]
    ) -> Union[Agent, GameWrapper, ReplayBuffer]:
        """Reads a base sklearn label encoder from a pickle file."""
        super().handle_input(data_type)
        filepath = os.path.join(self.artifact.uri, DEFAULT_FILENAME)
        with fileio.open(filepath, "rb") as fid:
            clf = pickle.load(fid)
        return clf

    def handle_return(
        self, clf: Union[Agent, GameWrapper, ReplayBuffer],
    ) -> None:
        """Creates a pickle for a sklearn label encoder.
        Args:
            clf: A sklearn label encoder.
        """
        super().handle_return(clf)
        filepath = os.path.join(self.artifact.uri, DEFAULT_FILENAME)
        with fileio.open(filepath, "wb") as fid:
            pickle.dump(clf, fid)
```

The `handle_input` and `handle_return` methods are important for defining how the materializer knows how to do its job.

- `handle_input` is responsible for reading the artifact from the artifact store.
- `handle_return` is responsible for writing the artifact to the artifact store.

You can tune the configurations for the model training which you can find in `config.py` file. I urge you to increase the `batch_size` and `epochs` to get a better training result. You can also change the `learning_rate` to get a better training result. You can also fine-tune several other parameters in the `config.py` file.

## What we learned

Deep Q Networks are not the newest or most efficient algorithm when it comes to playing games. Nevertheless, they are still very effective and can be used for games like the Atari games described in this blogpost. They lay the foundation for reinforcement learning. In this post we have seen how to build a DQN and train it to play Atari games. We used ZenML to build production-grade pipelines that are reproducible and scalable.

If you’re interested in learning more about ZenML, visit our [Github page](https://github.com/zenml-io/zenml), [read our docs](https://docs.zenml.io/). If you have questions or want to talk through your specific use case, feel free to [reach out to us on Slack](https://zenml.io/slack-invite/)!
