---
layout: post
author: Felix Altenberger
title: "Transforming Vanilla PyTorch Codes into Production Ready ML Pipeline - Without Selling Your Soul"
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

Needless to say, there are tons of quickstart notebooks out there that will walk you through step-by-step.
While there are values in quickstarts, especially in the early stages, the codes you see in quickstarts often look very different in production.

Or, is it?

Is there a way we could transform quickstart codes so that they are usable for production ML? 

Is that even possible?!

With ZenML, yes it is 🚀.

![poster](/assets/posts/pytorch_wandb/meme.jpg)


In this post, I will show you how to turn vanilla PyTorch codes into a production-ready ML pipeline that can be run on any cloud infrastructure while incorporating the best practices of MLOps.

Next, I'll also show how you can use ZenML with experiment trackers like [Weights & Biases](https://wandb.ai/) (W&B) and swap it out for other trackers such as [MLflow](https://mlflow.org/) or [Tensorboard](https://www.tensorflow.org/tensorboard) with little code changes.

By the end of the post, you'll learn how to -

+ Transform a vanilla PyTorch code into ZenML pipelines.
+ Visualize the pipeline on an interactive dashboard.
+ Use the W&B experiment tracker to track results and share them.
+ Switch to other experiment trackers like Tensorboard and MLflow.

For those who prefer video, we showcased this during a community meetup on October 26, 2022. Otherwise, let's dive in!

<iframe width="560" height="316" src="https://www.youtube-nocookie.com/embed/YLKueXpAT8o" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## ☕️ Installation
We highly recommend that you install ZenML in a virtual environment of your choice.
Read more [in our docs](https://docs.zenml.io/getting-started/installation).

Also note that if you're running this on an M1 Mac, we have a special guide [here](https://docs.zenml.io/getting-started/installation/m1-mac-installation) to set it up.

Now in your virtual environment, let's install all the necessary packages with:

```shell
pip install "zenml[server]==0.21.1" torchvision==0.14.0
```

To verify if the installation was successful type:

```shell
zenml version
```

in your terminal. If you don't encounter any error messages, we're now ready to start hacking!


To start working on your project, let's initialize a ZenML repository within your current directory with:

```shell
zenml init
```

This creates a `.zen` hidden folder in your current directory that stores the ZenML configs and management tools.

ZenML comes with various integrations, let's install the ones we will be using in this post:

```shell
zenml integration install pytorch wandb tensorboard mlflow -y
```

Wondering if you can use other tools instead? 
We have more integrations [here](https://zenml.io/integrations).


## ✅ Vanilla PyTorch Code
Now that we're done with the setups, lets take a look at the "hello world" of PyTorch on the [quickstart page](https://pytorch.org/tutorials/beginner/basics/quickstart_tutorial.html).

The codes look like the following.

```python
import torch
from torch import nn
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision.transforms import ToTensor

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

batch_size = 64

# Create data loaders.
train_dataloader = DataLoader(training_data, batch_size=batch_size)
test_dataloader = DataLoader(test_data, batch_size=batch_size)

for X, y in test_dataloader:
    print(f"Shape of X [N, C, H, W]: {X.shape}")
    print(f"Shape of y: {y.shape} {y.dtype}")
    break

# Get cpu or gpu device for training.
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Using {device} device")

# Define model
class NeuralNetwork(nn.Module):
    def __init__(self):
        super().__init__()
        self.flatten = nn.Flatten()
        self.linear_relu_stack = nn.Sequential(
            nn.Linear(28*28, 512),
            nn.ReLU(),
            nn.Linear(512, 512),
            nn.ReLU(),
            nn.Linear(512, 10)
        )

    def forward(self, x):
        x = self.flatten(x)
        logits = self.linear_relu_stack(x)
        return logits

model = NeuralNetwork().to(device)
print(model)

loss_fn = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=1e-3)

def train(dataloader, model, loss_fn, optimizer):
    size = len(dataloader.dataset)
    model.train()
    for batch, (X, y) in enumerate(dataloader):
        X, y = X.to(device), y.to(device)

        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            loss, current = loss.item(), batch * len(X)
            print(f"loss: {loss:>7f}  [{current:>5d}/{size:>5d}]")

def test(dataloader, model, loss_fn):
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
    correct /= size
    print(f"Test Error: \n Accuracy: {(100*correct):>0.1f}%, Avg loss: {test_loss:>8f} \n")


epochs = 5
for t in range(epochs):
    print(f"Epoch {t+1}\n-------------------------------")
    train(train_dataloader, model, loss_fn, optimizer)
    test(test_dataloader, model, loss_fn)
print("Done!")

```

You can put all the codes into a `.py` file, and it should run without a problem.

Now let's see how we can transform the codes into a ZenML pipeline.


## 🥳 Transforming PyTorch Codes into a ZenML Pipeline.
Before we start, I'd like to first tell you about the concept of *pipeline* and *step* in ZenML. This concept will come in handy later when we code.

In ZenML, a `pipeline` consists of a series of steps, organized in any order that makes sense for your use case.

The following illustration is a simple `pipeline` that consist of three `steps` running one after another.

![pipeline_steps](/assets/posts/pytorch_wandb/pipeline_step.gif)

Above is the exact `pipeline` and `steps` that we will construct from the vanilla PyTorch code.

Let's start coding the transformation.

First, we import all the modules we would need from `torch`, `torchvision` and `zenml`.

```python
import torch
from torch import nn
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision.transforms import ToTensor

from zenml.pipelines import pipeline
from zenml.steps import step, Output
```

Next, let's define the `pipeline`.

You can do this by putting a `@pipeline` decorator above the function definition.

```python
@pipeline
def pytorch_experiment_tracking_pipeline(
    load_data,
    load_model,
    train_test,
):
    """A `pipeline` to load data, load model, and train/evaluate the model."""
    train_dataloader, test_dataloader = load_data()
    model = load_model()
    train_test(model, train_dataloader, test_dataloader)
```
The pipeline we just wrote takes in three `steps` as the input namely - `load_data`, `load_model` and `train_test`. Each `step` runs sequentially one after another. 

Next, let's define what the `steps` actually do. 

We can define a `step` in the same way we define a `pipeline`, except we put a `@step` decorator now.

Let's start with the first `step` to load the data.

```python
@step
def load_data() -> Output(
    train_dataloader=DataLoader, test_dataloader=DataLoader
):
    """A `step` to load the Fashion MNIST dataset as tuple of torch Datasets."""
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

One of the best practices we keep when defining a `step` is type annotation.
In simple terms, this means we define the data type for all the inputs and outputs of a `step`.
This is a requirement when defining a `step`.

In the `load_data` step above, the outputs of the `step` are the train and test dataloaders of the `DataLoader` type in PyTorch.

All you have to do is append `Output(train_dataloader=DataLoader, test_dataloader=DataLoader)` to the function name.

Now, let's use the same method and define our next `step` to load the model.

```python
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
    """A `step` to define a PyTorch model."""
    model = NeuralNetwork()
    print(model)
    return model
```

And the last `step`, to train and evaluate the model.

```python
# Get cpu or gpu device for training.
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Using {device} device")

def train(dataloader, model, loss_fn, optimizer):
    """A function to train a model for one epoch."""
    size = len(dataloader.dataset)
    model.train()
    for batch, (X, y) in enumerate(dataloader):
        X, y = X.to(device), y.to(device)

        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            loss, current = loss.item(), batch * len(X)
            print(f"loss: {loss:>7f}  [{current:>5d}/{size:>5d}]")

def test(dataloader, model, loss_fn):
    """A function to test a model on the validation / test dataset."""
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
    correct /= size
    test_accuracy = 100*correct
    print(f"Test Error: \n Accuracy: {(100*correct):>0.1f}%, Avg loss: {test_loss:>8f} \n")

    return test_accuracy

@step
def train_test(
    model: nn.Module,
    train_dataloader: DataLoader, 
    test_dataloader: DataLoader
) -> Output(trained_model=nn.Module, test_acc=float):
    """A `step` to train and evaluate a torch model on given dataloaders."""
    lr = 1e-3
    epochs = 5

    model = model.to(device)
    loss_fn = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)
    test_acc = 0
    for t in range(epochs):
        print(f"Epoch {t+1}\n-------------------------------")
        train(train_dataloader, model, loss_fn, optimizer)
        test_acc = test(test_dataloader, model, loss_fn)
    print("Done!")

    return model, test_acc
```

We are now done with defining all the `steps` that takes place in a `pipeline`!

What's left now is to run it by:


```python
pytorch_experiment_tracking_pipeline(
    load_data=load_data(),
    load_model=load_model(),
    train_test=train_test(),
).run()
```

And that's it! 
How easy was that? It's basically just reorganizing the PyTorch codes into a series of `steps` and a `pipeline`.

If you put all the codes above in a `.py` script, it should run just like the vanilla PyTorch code in the quickstart.

So why does this matter?

You've just successfully converted vanilla PyTorch codes into a form that can be run on your local machine and additionally any cloud infrastructure. Structuring your code into steps and pipelines also ensures they are modular and easily maintainable. Not to mention that the code that you'd use in development is largely similar to the code in production saving a huge refactoring cost when codes transition from development to production.

These are among the many benefits of structuring your code with [ZenML pipelines from the get-go](https://blog.zenml.io/ml-pipelines-from-the-start/). 

Learn more about other ZenML features [here](https://zenml.io/features) which will save you a lot of time and resources in productionalizing ML models.

## 📊 ZenML Dashboard

ZenML comes with a handy dashboard that lets you visualize the pipeline you just run.
To launch the dashboard, type:
```shell
zenml up
```
in your terminal.
This spins up a local ZenServer and launches the dashboard in the browser at `http://127.0.0.1:8237)`.

![login](/assets/posts/pytorch_wandb/dashboard.gif)

Key in `default` as the username and leave the password empty, then click "Log in".
In the dashboard, you'll see all details about your Steps, Pipelines, Runs, Stacks and Stack Components.
There's also a neat visualization on the pipeline which lets you visually inspect your workflow.

This section shows you can use the ZenML server and dashboard locally to inspect runs.
But this is rarely the case in production where you'll need to collaborate and manage the workflow in a team.
For that you'll need to deploy ZenML in the cloud.
Read more about deploying ZenML on a cloud [here](https://docs.zenml.io/getting-started/deploying-zenml).

Up to this point, I've shown you how to transform vanilla PyTorch codes from the quickstart into ZenML pipeline and utilize the dashboard to manage and visualize the pipeline.

In the next section, I will show how you can add in more components (we call them Stack Components in ZenML) into your pipeline.

## ⚖ Experiment Tracking with W&B
In ZenML we introduce a concept of Stack and Stack Component.

A Stack is the configuration of the underlying infrastructure and choices around how your pipeline will be run.
In any Stack, there must be at least two basic Stack Components - and orchestrator and an artifact store.

These components are set up by default when you initialize the project.
In this section, we'd like to have a third Stack Component - Experiment Trackers, which let you track your ML experiment by logging various information about your models, dataset, metrics, etc.

View the list of types of Stack Components [here](https://docs.zenml.io/component-gallery/categories).

In this section I will show you how to add the Weights and Biases (W&B) experiment tracker into your stack.

First, we must register the experiment tracker 

```shell
zenml experiment-tracker register wandb_tracker --flavor=wandb --api_key=<WANDB_SECRET> --entity=<WANDB_ENTITY> --project_name=<WANDB_PROJECT>
zenml stack register wandb_stack -a default -o default -e wandb_tracker --set
```

We will continue to build on the code we used in the previous section.

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



## 🎬 Switching to Tensorboard Experiment Tracker

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

## 🌼 Switching to MLflow Experiment Tracker

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

## 💡 Conclusion
In this post you've learned how to - 

+ Transform a vanilla PyTorch code into ZenML pipelines.
+ Visualize the pipeline on an interactive dashboard.
+ Use the Weights & Biases experiment tracker to track results and share them.
+ Switch to other experiment trackers such as Tensorboard and MLflow with little code changes.

You've seen how convert vanilla PyTorch codes into production ready pipelines. But, not everyone is using PyTorch. The good news is that the steps are not very different whether you're converting from PyTorch or Tensorflow or Scikit-learn. As long as you structure the codes into steps and pipelines, it should work. My hope is that this post laid down the key ideas and concepts on how to do it.

Where to go next? If you're starting out with ZenML we recommend checking our of [quickstart](https://github.com/zenml-io/zenml/tree/main/examples/quickstart) here to learn more.

Questions? Join our Slack channel.