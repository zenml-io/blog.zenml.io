---
layout: post
author: Felix Altenberger
title: "How to Turn PyTorch Code with W&B Tracking into ML Pipelines"
description: "Rewrite PyTorch code as a ZenML pipeline and add experiment tracking with TensorBoard, Weights & Biases, and MLflow."
category: zenml
tags: zenml integrations mlops tooling pipelines pytorch wandb mlflow tensorboard
publish_date: October 27, 2022
date: 2022-10-27T00:02:00Z
thumbnail: /assets/posts/pytorch_wandb/pytorch_wandb.gif
image:
path: /assets/posts/pytorch_wandb/pytorch_wandb.png
---

![poster](/assets/posts/pytorch_wandb/pytorch_wandb.png)

## 🔥 Motivation
It's 2022, anyone can train a machine learning (ML) model these days. 
Libraries like [PyTorch](https://pytorch.org/), [Tensorflow](https://www.tensorflow.org/), and [Scikit-learn](https://scikit-learn.org/stable/index.html) have lowered the entry barrier so much, you can get started in minutes.

Needless to say, there are tons of notebooks and tutorials out there that walk you through step-by-step.
While there are values in tutorials and notebooks, especially in the exploration stage, they are often not sufficient for production use cases.
The folks from Neptune wrote a good [post](https://neptune.ai/blog/should-you-use-jupyter-notebooks-in-production) on the pros and cons of using notebooks in production machine learning (ML). I will leave the judgment to you depending on your use cases.

![poster](/assets/posts/pytorch_wandb/meme.jpg)

The majority of codes you'd find in [quickstarts](https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html) and tutorials are optimized for learning and exploring.
The question is how do you transform these codes so that they can be used for production ML? Or is that even possible?

With ZenML, yes it is 🚀.

In this post, I will show you how to turn vanilla PyTorch codes into a production-ready ML pipeline that can be run on any cloud infrastructure while incorporating the best practices of MLOps.

In short, you'll learn how to -

+ Turn a vanilla PyTorch code into ZenML pipelines.
+ Visualize the pipeline on an interactive dashboard.
+ Use the Weights & Biases experiment tracker to track results and share them.
+ Switch to other experiment trackers with little code changes.

For those who prefer video, we showcased this during a community meetup on October 26, 2022. Otherwise, let's dive in!

<iframe width="560" height="316" src="https://www.youtube-nocookie.com/embed/YLKueXpAT8o" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## ☕️ Installation
First, let's install all the necessary packages with:

```shell
pip install "zenml[server]" torchvision
```

To start working on your project, initialize a ZenML repository within your current directory with:
```shell
zenml init
```
This creates a `.zen` hidden folder in your current directory that stores the ZenML configs and management tools.

ZenML comes with various integrations, let's install the ones we will be using in this post:
```shell
zenml integration install pytorch wandb tensorboard mlflow -y
```
More integrations [here](https://zenml.io/integrations).


## Converting PyTorch Code to ZenML

From https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html

```python
from zenml.pipelines import pipeline


@pipeline(enable_cache=False)
def pytorch_experiment_tracking_pipeline(
    load_training_data,
    model_definition,
    train_test,
):
    """Train, evaluate, and deploy a model."""
    train_dataloader, test_dataloader = load_training_data()
    model = model_definition()
    train_test(model, train_dataloader, test_dataloader)
```

```python
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision.transforms import ToTensor
from zenml.steps import step, Output

@step
def load_data() -> Output(
    train_dataloader=DataLoader, test_dataloader=DataLoader
):
    """Load the Fashion MNIST dataset as tuple of torch Datasets."""
    batch_size = 64

    # Download training data from open datasets.
    training_data = datasets.FashionMNIST(
        root="data",
        train=True,
        download=True,
        transform=ToTensor(),
    )

    # Download test data from open datasets.
    test_data = datasets.FashionMNIST(
        root="data",
        train=False,
        download=True,
        transform=ToTensor(),
    )

    # Create data loaders.
    train_dataloader = DataLoader(training_data, batch_size=batch_size)
    test_dataloader = DataLoader(test_data, batch_size=batch_size)

    return train_dataloader, test_dataloader
```

```python
from torch import nn
from zenml.steps import step


class NeuralNetwork(nn.Module):
    def __init__(self):
        super(NeuralNetwork, self).__init__()
        self.flatten = nn.Flatten()
        self.linear_relu_stack = nn.Sequential(
            nn.Linear(28 * 28, 512),
            nn.ReLU(),
            nn.Linear(512, 512),
            nn.ReLU(),
            nn.Linear(512, 10),
        )

    def forward(self, x):
        x = self.flatten(x)
        logits = self.linear_relu_stack(x)
        return logits


@step
def load_model() -> nn.Module:
    """Define a PyTorch classification model."""
    model = NeuralNetwork()
    print(model)
    return model
```

```python
import torch
from torch import nn
from torch.utils.data import DataLoader
from zenml.steps import Output, step, StepContext


def train(dataloader, model, loss_fn, optimizer, device, global_step):
    """Train a model for one epoch."""
    size = len(dataloader.dataset)
    model.train()
    correct, accuracy = 0, 0
    for batch, (X, y) in enumerate(dataloader):
        X, y = X.to(device), y.to(device)

        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)
        correct += (pred.argmax(1) == y).type(torch.float).sum().item()

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            step_in_epoch = (batch + 1) * len(X)
            current_step = global_step + step_in_epoch
            loss = loss.item()
            accuracy = 100 * correct / step_in_epoch

            # Naive tracking
            print(f"Loss: {loss:>7f}")
            print(f"Accuracy: {accuracy:>0.1f}%")

    return accuracy


def test(dataloader, model, loss_fn, device, global_step):
    """Test a model on the validation / test dataset."""
    size = len(dataloader.dataset)
    num_batches = len(dataloader)
    model.eval()
    test_loss, correct = 0, 0
    with torch.no_grad():
        for X, y in dataloader:
            X, y = X.to(device), y.to(device)
            pred = model(X)
            test_loss += loss_fn(pred, y).item()
            correct += (pred.argmax(1) == y).type(torch.float).sum().item()
    test_loss /= num_batches
    test_accuracy = 100 * correct / size

    # Naive tracking
    print(f"Test Loss: {test_loss:>8f}")
    print(f"Test Accuracy: {(test_accuracy):>0.1f}%")

    return test_accuracy


@step
def train_test(
    model: nn.Module,
    train_dataloader: DataLoader, 
    test_dataloader: DataLoader, 
    context: StepContext,
) -> Output(trained_model=nn.Module, test_acc=float):
    """Train and simultaneously evaluate a torch model on given dataloaders."""
    device = "cuda" if torch.cuda.is_available() else "cpu"
    lr = 1e-3
    epochs = 5

    model = model.to(device)
    loss_fn = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    test_acc = 0
    for t in range(epochs):
        print(f"Epoch {t+1}\n-------------------------------")
        global_step = t * len(train_dataloader)
        train_acc = train(train_dataloader, model, loss_fn, optimizer, device, global_step)
        test_acc = test(test_dataloader, model, loss_fn, device, global_step)
    print("Done!")

    # Naive tracking
    print("Final test accuracy: ", test_acc)

    return model, test_acc
```

```python
pytorch_experiment_tracking_pipeline(
    load_training_data=load_data(),
    model_definition=load_model(),
    train_test=train_test(),
).run(unlisted=True)
```

## Exprtiment Tracking with TensorBoard

```python
import os
import torch
from torch import nn
from torch.utils.data import DataLoader
from zenml.steps import Output, step, StepContext
from torch.utils.tensorboard import SummaryWriter


def train(dataloader, model, loss_fn, optimizer, device, tensorboard_writer, global_step):
    """Train a model for one epoch.

    From https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html.
    """
    size = len(dataloader.dataset)
    model.train()
    correct, accuracy = 0, 0
    for batch, (X, y) in enumerate(dataloader):
        X, y = X.to(device), y.to(device)

        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)
        correct += (pred.argmax(1) == y).type(torch.float).sum().item()

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            step_in_epoch = (batch + 1) * len(X)
            current_step = global_step + step_in_epoch
            loss = loss.item()
            accuracy = 100 * correct / step_in_epoch

            # Tensorboard tracking
            tensorboard_writer.add_scalar("Loss/train", loss, current_step)
            tensorboard_writer.add_scalar("Accuracy/train", accuracy, current_step)

    return accuracy


def test(dataloader, model, loss_fn, device, tensorboard_writer, global_step):
    """Test a model on the validation / test dataset.
    
    From https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html.
    """
    size = len(dataloader.dataset)
    num_batches = len(dataloader)
    model.eval()
    test_loss, correct = 0, 0
    with torch.no_grad():
        for X, y in dataloader:
            X, y = X.to(device), y.to(device)
            pred = model(X)
            test_loss += loss_fn(pred, y).item()
            correct += (pred.argmax(1) == y).type(torch.float).sum().item()
    test_loss /= num_batches
    test_accuracy = 100 * correct / size

    # Tensorboard tracking
    tensorboard_writer.add_scalar("Loss/test", test_loss, global_step)
    tensorboard_writer.add_scalar("Accuracy/test", test_accuracy, global_step)

    return test_accuracy


@step
def train_test(
    model: nn.Module,
    train_dataloader: DataLoader, 
    test_dataloader: DataLoader, 
    context: StepContext,
) -> Output(trained_model=nn.Module, test_acc=float):
    """Train and simultaneously evaluate a torch model on given dataloaders."""
    device = "cuda" if torch.cuda.is_available() else "cpu"
    tensorboard_writer = None
    lr = 1e-3
    epochs = 5
    
    # Tensorboard tracking
    log_dir = os.path.join(
        context.get_output_artifact_uri(output_name="trained_model"), "logs"
    )
    tensorboard_writer = SummaryWriter(log_dir)

    model = model.to(device)
    loss_fn = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    test_acc = 0
    for t in range(epochs):
        print(f"Epoch {t+1}\n-------------------------------")
        global_step = t * len(train_dataloader)
        train_acc = train(train_dataloader, model, loss_fn, optimizer, device, tensorboard_writer, global_step)
        test_acc = test(test_dataloader, model, loss_fn, device, tensorboard_writer, global_step)
    print("Done!")
    return model, test_acc
```

```python
from zenml.integrations.tensorboard.visualizers import visualize_tensorboard


pytorch_experiment_tracking_pipeline(
    load_training_data=load_data(),
    model_definition=load_model(),
    train_test=train_test(),
).run(unlisted=True)

visualize_tensorboard(
    pipeline_name="pytorch_experiment_tracking_pipeline",
    step_name="train_test",
)
```

## Experiment Tracking with W&B

```shell
zenml experiment-tracker register wandb_tracker --flavor=wandb --api_key=<WANDB_SECRET> --entity=<WANDB_ENTITY> --project_name=<WANDB_PROJECT>
zenml stack register wandb_stack -a default -o default -e wandb_tracker --set
```

```python
import torch
from torch import nn
from torch.utils.data import DataLoader
from zenml.steps import Output, step, StepContext
import wandb


def train(dataloader, model, loss_fn, optimizer, device, tensorboard_writer, global_step):
    """Train a model for one epoch."""
    size = len(dataloader.dataset)
    model.train()
    correct, accuracy = 0, 0
    for batch, (X, y) in enumerate(dataloader):
        X, y = X.to(device), y.to(device)

        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)
        correct += (pred.argmax(1) == y).type(torch.float).sum().item()

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            step_in_epoch = (batch + 1) * len(X)
            current_step = global_step + step_in_epoch
            loss = loss.item()
            accuracy = 100 * correct / step_in_epoch

            # W&B tracking
            wandb.log(
                {
                    "Train Loss": loss, 
                    "Train Accuracy": accuracy
                }, 
                step=global_step
            )
    return accuracy


def test(dataloader, model, loss_fn, device, tensorboard_writer, global_step):
    """Test a model on the validation / test dataset."""
    size = len(dataloader.dataset)
    num_batches = len(dataloader)
    model.eval()
    test_loss, correct = 0, 0
    with torch.no_grad():
        for X, y in dataloader:
            X, y = X.to(device), y.to(device)
            pred = model(X)
            test_loss += loss_fn(pred, y).item()
            correct += (pred.argmax(1) == y).type(torch.float).sum().item()
    test_loss /= num_batches
    test_accuracy = 100 * correct / size

    # W&B tracking
    wandb.log(
        {"Test Loss": test_loss, "Test Accuracy": test_accuracy}, 
        step=global_step
    )
    return test_accuracy

@step(enable_cache=False, experiment_tracker="wandb_tracker")
def train_test(
    model: nn.Module,
    train_dataloader: DataLoader, 
    test_dataloader: DataLoader, 
    context: StepContext,
) -> Output(trained_model=nn.Module, test_acc=float):
    """Train and simultaneously evaluate a torch model on given dataloaders."""
    device = "cuda" if torch.cuda.is_available() else "cpu"
    tensorboard_writer = None
    lr = 1e-3
    epochs = 5

    # W&B tracking
    wandb.log({"epochs": epochs, "lr": lr})
    wandb.watch(model)

    model = model.to(device)
    loss_fn = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    test_acc = 0
    for t in range(epochs):
        print(f"Epoch {t+1}\n-------------------------------")
        global_step = t * len(train_dataloader)
        train_acc = train(train_dataloader, model, loss_fn, optimizer, device, tensorboard_writer, global_step)
        test_acc = test(test_dataloader, model, loss_fn, device, tensorboard_writer, global_step)
    print("Done!")

    return model, test_acc
```

```python
pytorch_experiment_tracking_pipeline(
    load_training_data=load_data(),
    model_definition=load_model(),
    train_test=train_test(),
).run(unlisted=True)
```

## Experiment Tracking with MLflow

```shell
zenml experiment-tracker register mlflow_tracker --flavor=mlflow
zenml stack register mlflow_stack -a default -o default -e mlflow_tracker --set
```

```python
import mlflow
import torch
from torch import nn
from torch.utils.data import DataLoader
from zenml.steps import Output, step, StepContext


def train(dataloader, model, loss_fn, optimizer, device, global_step):
    """Train a model for one epoch.

    From https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html.
    """
    size = len(dataloader.dataset)
    model.train()
    correct, accuracy = 0, 0
    for batch, (X, y) in enumerate(dataloader):
        X, y = X.to(device), y.to(device)

        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)
        correct += (pred.argmax(1) == y).type(torch.float).sum().item()

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            step_in_epoch = (batch + 1) * len(X)
            current_step = global_step + step_in_epoch
            loss = loss.item()
            accuracy = 100 * correct / step_in_epoch

            # MLflow tracking
            mlflow.log_metric("Loss/train", loss, step=current_step)
            mlflow.log_metric("Accuracy/train", accuracy, step=current_step)

    return accuracy


def test(dataloader, model, loss_fn, device, global_step):
    """Test a model on the validation / test dataset.
    
    From https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html.
    """
    size = len(dataloader.dataset)
    num_batches = len(dataloader)
    model.eval()
    test_loss, correct = 0, 0
    with torch.no_grad():
        for X, y in dataloader:
            X, y = X.to(device), y.to(device)
            pred = model(X)
            test_loss += loss_fn(pred, y).item()
            correct += (pred.argmax(1) == y).type(torch.float).sum().item()
    test_loss /= num_batches
    test_accuracy = 100 * correct / size

    # MLflow tracking
    mlflow.log_metric("Loss/test", test_loss, global_step)
    mlflow.log_metric("Accuracy/test", test_accuracy, global_step)

    return test_accuracy


@step(enable_cache=False, experiment_tracker="mlflow_tracker")
def train_test(
    model: nn.Module,
    train_dataloader: DataLoader, 
    test_dataloader: DataLoader, 
    context: StepContext,
) -> Output(trained_model=nn.Module, test_acc=float):
    """Train and simultaneously evaluate a torch model on given dataloaders."""
    device = "cuda" if torch.cuda.is_available() else "cpu"
    tensorboard_writer = None
    lr = 1e-3
    epochs = 5

    # MLFlow tracking
    mlflow.pytorch.log_model(model, "model")

    model = model.to(device)
    loss_fn = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    test_acc = 0
    for t in range(epochs):
        print(f"Epoch {t+1}\n-------------------------------")
        global_step = t * len(train_dataloader)
        train_acc = train(train_dataloader, model, loss_fn, optimizer, device, global_step)
        test_acc = test(test_dataloader, model, loss_fn, device, global_step)
    print("Done!")

    return model, test_acc
```

```python
pytorch_experiment_tracking_pipeline(
    load_training_data=load_data(),
    model_definition=load_model(),
    train_test=train_test(),
).run(unlisted=True)
```

```python
from zenml.integrations.mlflow.mlflow_utils import get_tracking_uri
print(get_tracking_uri())
```

```shell
mlflow ui --backend-store-uri="<TRACKING_URI>" --port=4497
```
