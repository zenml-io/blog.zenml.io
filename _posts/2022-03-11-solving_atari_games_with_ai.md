---
layout: post
author: Ayush Singh
title: Solving Atari Games with Reinforcement Learning (AI)
description: "We trained a model to solve Atari games using reinforcement learning. We used the Deep Q algorithm as the basis of our implementation. It allowed us to get a working solution fairly quickly."
publish_date: March 11, 2022
date: 2022-03-11T10:20:00Z
tags: tensorflow machine-learning mlops evergreen applied-zenml pipelines reinforcement-learning
category: zenml
crosspost:
  url: https://blog.tensorflow.org/2020/02/atari-games-with-reinforcement-learning.html
  name: Reinforcement Learning Blog
thumbnail: /assets/posts/atari.gif
image:
  path: /assets/posts/atari.gif
  height: 100
  width: 100
---

Reinforcement learning is a type of machine learning that works on a problem that is solved by a model that is trying to learn to perform actions in a way that maximizes the reward in a particular situation. In Supervised learning, we are given the target label which acts as the ground truth for the model so that we can train the model to predict the label for unseen examples but In reinforcement learning, there is no target label but the reinforcement agent decides what to do to perform the given task or action in a particular situation and the agent learns from it's experience.

In this article, we will be using zenml to build a model that can solve Atari games using reinforcement learning. We will be using the [Atari 2600](https://en.wikipedia.org/wiki/Atari_2600) game environment. We will be using the [Deep Q-Learning](https://en.wikipedia.org/wiki/Deep_Q-learning) algorithm to solve the game. We had made use of this Github repo [Building a Powerful DQN in TensorFlow 2.0](https://github.com/sebtheiler/tutorials/tree/main/dqn) to showcase how we can Integrate zenml to build End to End reinforcement learning applications.

ZenML is an extensible, open-source MLOps framework to create production-ready machine learning pipelines. Built for data scientists, it has a simple, flexible syntax, is cloud- and tool-agnostic, and has interfaces/abstractions that are catered towards ML workflows.
ZenML pipelines execute ML-specific workflows from sourcing data to splitting, preprocessing, training, all the way to the evaluation of results and even serving.

## Setting up the project

We suggest you make one virtual environment and then work on these things. You can create a virtual environment using conda by following steps:-

```
conda create -n envname python=x.x anaconda
conda activate envname
```

Before running this project, you must install some python packages in your environment which you can do by following steps:-

```python
git clone https://github.com/zenml-io/zenfiles.git
cd Atari-Game-Player
pip install -r requirements.txt
```

We're ready to go now. You can run the code, using the run_pipeline.py script.

```python
python run_pipeline.py train
```

## Explanation of codebase and the pipeline steps

We have `trainin_pipeline.py` script which is the main script that runs the training pipeline. The following is the code for the training pipeline:-

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
    :param train: The function that will be called inside the train_pipeline function. This is the
    function that will be called
    """
    game_wrapper = game_wrap()
    main_dqn, target_dqn = build_dqn(game_wrapper)
    replay_buffer = replay_buffer()
    agent = agent(game_wrapper, replay_buffer, main_dqn, target_dqn)
    frame_number, rewards, loss_list = get_information_meta(agent)
    train(game_wrapper, loss_list, rewards, frame_number, agent)
```

We can see we have several steps/components in this pipeline, so let's break it down and talk about each step in detail. All the steps can be found in ``steps/``` folder.

- `game_wrap`: This is a function that returns a GameWrapper object. The GameWrapper object wraps over the game that you want to train on. The GameWrapper class wraps the Open AI Gym environment and provides some useful functions such as resetting the environment and keeping track of useful statistics such as lives left.

- `build_dqn`: It builds the DQN model in Keras.

- `replay_buffer`: The replay buffer is a class that holds all the experiences a DQN has seen, and samples from it randomly to train the DQN. It takes care of managing the stored experiences and sampling them on demand.

- `agent`: Implements a standard DDDQN agent

- `get_information_meta`: If we're loading from a checkpoint, load the information from the checkpoint. Otherwise, start from scratch. This is a step that returns the frame number, rewards, and loss list.

- `train`: We initialize the agent, the game environment, and the TensorBoard writer. Then, we train the agent until the game is over.

![Pipeline Steps](/assets/posts/pipeline_steps.PNG)

Now, we have seen about the steps in the pipeline and now let's see how to run the pipeline using the `run_pipeline` function. We are importing every step from the steps folder and then giving it to the `train_pipeline` function to run the pipeline. We can see that the pipeline is a function that takes in a function as an argument.

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

If you have noticed that some of the steps in this pipeline requires custom materializer to be used, so let's have a look at the custom materializer.

### A Note on Materializer

The precise way that data passes between the steps is dictated by materializers. The data that flows through steps are stored as artifacts and artifacts are stored in artifact stores. The logic that governs the reading and writing of data to and from the artifact stores lives in the materializers.

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

The handle_input and handle_return functions are important.

- `handle_input` is responsible for reading the artifact(Artifacts is a common ML term used to describe the output created by a particular step.) from the artifact store.
- `handle_return` is responsible for writing the artifact to the artifact store.

## Conclusion

Deep Q Network are not the newest and most efficient algorithm to play games. But they are still very effective and can be used to play games like Atari games. They lay the foundation for reinforcement learning. In this post we have seen how to build a DQN and train it to play games like Atari games. We have made use of zenml to build production grade pipelines that are reproducible and scalable.

If you’re interested in learning more about ZenML, visit our [Github page](https://github.com/zenml-io/zenml), [read our docs](https://docs.zenml.io/).If you have questions or want to talk through your specific use case, feel free to [reach out to us on Slack](https://zenml.io/slack-invite/) !