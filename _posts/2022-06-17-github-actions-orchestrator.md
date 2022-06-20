---
layout: post
author: Michael Schuster
title: "Who needs Kubeflow when have Github Actions?"
description: ""
category: zenml
tags: zenml integrations cloud evergreen cicd mlops
publish_date: June 20, 2022
date: 2022-06-20T00:02:00Z
thumbnail: /assets/posts/github-actions-orchestrator/roman-synkevych-wX2L8L-fGeA-unsplash.jpg
image:
  path: /assets/posts/github-actions-orchestrator/roman-synkevych-wX2L8L-fGeA-unsplash.jpg
---

Move over Kubeflow! GitHub Actions is the new sheriff in town!

We're really proud of our Kubeflow integration. It gives you a ton of power and flexibility and is a production-ready tool. But we also know that for many of you it's one step too many. Setting up a Kubernetes cluster is probably nobody's ideal way to spend their time, and it certainly requires some time investment to maintain.

We thought this was a concern worth addressing so I worked to build an alternative during the ZenHack Day we recently ran. [GitHub Actions](https://docs.github.com/en/actions) is a platform that allows you to execute arbitrary software development workflows right in your GitHub repository. It is most commonly used for CI/CD pipelines, but using the GitHub Actions orchestrator ZenML now enables you to easily run and schedule your machine learning pipelines as GitHub Actions workflows.

## GitHub Actions: best in class for what?

Most technical decisions come with various kinds of tradeoffs, and it's worth taking a moment to assess why you might want to use the GitHub Actions orchestrator in the first place.

Let's start with the downsides:

- You don't have as much flexibility as with a tool like Kubeflow in terms of specifying exactly what kinds of hardware are used to run your steps.
- The orchestrator itself runs on the hardware that GitHub Actions provides (generously and [for free](https://github.blog/2019-08-08-github-actions-now-supports-ci-cd/)). This isn't the fastest or or most performant infrastructure setup, and it generally is much slower than even your local CPU machine. There are also memory and storage constraints to [the machines they provide](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources) as GitHub Actions runners.
- GitHub offers no guarantees about when your actions will be executed; at peak times you might be waiting a while before the hardware is allocated and provisioned to run. If you are planning on running ZenML pipelines on a schedule (every ten minutes, for example) then this might not work as expected.

So what's the point, then? These are indeed some serious downsides. Firstly and foremostly, there's the cost: running your pipelines on GitHub Actions is **free**. If you're interested in running your pipelines in the cloud on serverless infrastructure, there's probably no easier way to get started than to try out this orchestrator.

You are also spared the pain of maintaining a Kubernetes cluster. Once you've configured it (see below for instructions) there's basically nothing you have to do on an ongoing basis. I hope you're sold on trying it out and want to get started, so let's not hold off any more.

(Note that some of the commands in this tutorial rely on environment variables or a specific working directory from previous commands, so be sure to run them in the same shell. In this tutorial we're going to use [Microsoft's Azure platform](https://azure.microsoft.com/) for cloud storage and our MySQL database, but it works just as well on AWS or GCP.

## Prerequisites

This tutorial assumes that you have:
* [Python](https://www.python.org/) installed (version 3.7-3.9)
* [Git](https://git-scm.com/) installed
* a [GitHub](https://github.com/) account
* [Docker](https://www.docker.com/) installed and running

## Azure Setup

### Create an account

If you don't have an Azure account yet, go to https://azure.microsoft.com/en-gb/free/ and create one.

### Create a resource group

[Resource groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups) are a concept in Azure that allows us to bundle different resources that share a similar lifecycle. We'll create a new resource group for this tutorial so we'll be able to differentiate them from other resources in our account and easily delete them at the end.

Go to [the Azure portal](https://portal.azure.com/#home), click the hamburger button in the top left to open up the portal menu. Then, hover over the `Resource groups` section until a popup appears and click on the `+ Create` button:
![Resource group step 1](../assets/posts/github-actions-orchestrator/resource_group_0.png)
Select a region and enter a name for your resource group before clicking on `Review + create`:
![Resource group step 2](../assets/posts/github-actions-orchestrator/resource_group_1.png)
Verify that all the information is correct and click on `Create`:
![Resource group step 3](../assets/posts/github-actions-orchestrator/resource_group_2.png)

### Create a storage account

An [Azure storage account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal) is a grouping of Azure data storage objects which also provides a namespace and authentication options to access them. We'll need a storage account to hold the blob storage container we'll create in the next step.

Open up the portal menu again, but this time hover over the `Storage accounts` section and click on the `+ Create` button in the popup once it appears: 
![Storage account step 1](../assets/posts/github-actions-orchestrator/storage_account_0.png)

Select your previously created **resource group**, a **region** and a **globally unique name** and then click on `Review + create`:

![Storage account step 2](../assets/posts/github-actions-orchestrator/storage_account_1.png)

Make sure that all the values are correct and click on `Create`:

![Storage account step 3](../assets/posts/github-actions-orchestrator/storage_account_2.png)

Wait until the deployment is finished and click on `Go to resource` to open up your newly created storage account:

![Storage account step 4](../assets/posts/github-actions-orchestrator/storage_account_3.png)

In the left menu, select `Access keys`:

![Storage account step 5](../assets/posts/github-actions-orchestrator/storage_account_4.png)

Click on `Show keys`, and once the keys are visible, note down the **storage account name** and the value of the **Key** field of either key1 or key2.
We're going to use them for the `<STORAGE_ACCOUNT_NAME>` and `<STORAGE_ACCOUNT_KEY>` placeholders later.

![Storage account step 6](../assets/posts/github-actions-orchestrator/storage_account_5.png)

### Create an Azure Blob Storage Container

Next, we're going to create an [Azure Blob Storage Container](https://docs.microsoft.com/en-us/azure/storage/blobs/). It will be used by ZenML to store the output artifacts of all our pipeline steps.
To do so, select `Containers` in the Data storage section of the storage account:

![Blob storage container step 1](../assets/posts/github-actions-orchestrator/container_0.png)

Then click the `+ Container` button on the top to create a new container:

![Blob storage container step 2](../assets/posts/github-actions-orchestrator/container_1.png)

Choose a name for the container and note it down. We're going to use it later for the `<BLOB_STORAGE_CONTAINER_NAME>` placeholder. Then create the container by clicking the `Create` button.

![Blob storage container step 3](../assets/posts/github-actions-orchestrator/container_2.png)
### Set up a MySQL database

Now let's set up a managed MySQL database. This will act as ZenML's metadata store and store metadata regarding our pipeline runs which will enable features like caching and establish a consistent lineage between our pipeline steps.

Open up the portal menu and click on `+ Create a resource`:

![MySQL database step 1](../assets/posts/github-actions-orchestrator/mysql_0.png)

Search for `Azure Database for MySQL` and once found click on `Create`:

![MySQL database step 2](../assets/posts/github-actions-orchestrator/mysql_1.png)

Make sure you select `Flexible server` and then continue by clicking the `Create` button:

![MySQL database step 3](../assets/posts/github-actions-orchestrator/mysql_2.png)

Select a **resource group** and **region** and fill in values for the **server name** as well as **admin username** and **password**. Note down the username and password you chose as we're going to need them later for the `<MYSQL_USERNAME>` and `<MYSQL_PASSWORD>` placeholders. Then click on `Next: Networking`:

![MySQL database step 4](../assets/posts/github-actions-orchestrator/mysql_3.png)

Now click on `Add 0.0.0.0 - 255.255.255.255` to allow access from all public IPs. This is necessary so the machines running our GitHub Actions can access this database. It will still require username, password as well as a SSL certificate to authenticate.

![MySQL database step 5](../assets/posts/github-actions-orchestrator/mysql_4.png)

In the opened up popup, click on `Continue`:

![MySQL database step 6](../assets/posts/github-actions-orchestrator/mysql_5.png)

Now click on `Review + create`:

![MySQL database step 7](../assets/posts/github-actions-orchestrator/mysql_6.png)

Verify the configuration and click the `Create` button:

![MySQL database step 8](../assets/posts/github-actions-orchestrator/mysql_7.png)

Now we'll have to wait until the deployment is finished (this might take ~15 minutes).

**Note**: If the deployment fails for some reason, delete the resource and restart from the beginning of [this section](#set-up-a-mysql-database).

Once the deployment is finished, click on `Go to resource`:

![MySQL database step 9](../assets/posts/github-actions-orchestrator/mysql_8.png)

On the overview page of your MySQL server resource, note down the server name in the top right. We'll use it later for the `<MYSQL_SERVER_NAME>` placeholder.

![MySQL database step 10](../assets/posts/github-actions-orchestrator/mysql_9.png)

Then click on `Networking` in the left menu:

![MySQL database step 11](../assets/posts/github-actions-orchestrator/mysql_10.png)

To finish up the Azure setup, click on `Download SSL Certificate` on the top. Make sure to note down the path to the certificate file which we'll use for the `<PATH_TO_SSL_CERTIFICATE>` placeholder in a later step.

![MySQL database step 12](../assets/posts/github-actions-orchestrator/mysql_11.png)


## GitHub Setup
### Create a GitHub Personal Access Token

Next up, we'll need to create a [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) that ZenML will use to authenticate with the GitHub API in order to store secrets and upload Docker images.

1) Go to https://github.com, click on your profile image in the top right corner and select `Settings`:

![PAT step 1](../assets/posts/github-actions-orchestrator/pat_0.png)

2) Scroll to the bottom and click on `Developer Settings` on the left side:

![PAT step 2](../assets/posts/github-actions-orchestrator/pat_1.png)

3) Select `Personal access tokens` and click on `Generate new token`:

![PAT step 3](../assets/posts/github-actions-orchestrator/pat_2.png)

![PAT step 4](../assets/posts/github-actions-orchestrator/pat_3.png)

4) Give your token a descriptive name for future reference and select the `repo` and `write:packages` scopes:

![PAT step 5](../assets/posts/github-actions-orchestrator/pat_4.png)

5) Scroll to the bottom and click on `Generate token`. This will bring you to a page that allows you to copy your newly generated token:

![PAT step 6](../assets/posts/github-actions-orchestrator/pat_5.png)

Now that we've got our token, let's store it in an environment variable for future steps. We'll also store our GitHub username that this token was created for. Replace the `<PLACEHOLDERS>` in the following command and run it:
```bash
export GITHUB_USERNAME=<GITHUB_USERNAME>
export GITHUB_AUTHENTICATION_TOKEN=<PERSONAL_ACCESS_TOKEN>
```

### Login to the Container registry

When we'll run our pipeline later, ZenML will build a Docker image for us which will be used to execute the steps of the pipeline. In order to access this image inside GitHub Actions workflow, we'll push it to the GitHub container registry. Running the following command will use the personal access token created in the previous step to authenticate our local Docker client with this container registry:
```bash
echo "$GITHUB_AUTHENTICATION_TOKEN" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin
```

**Note**: If you run into issues during this step, make sure you've set the environment variables in the previous step and Docker is running on your machine.

### Fork and clone the tutorial repository

Time to fork and clone an [example repository](https://github.com/zenml-io/github-actions-orchestrator-tutorial) which contains a very simple ZenML pipeline that trains 
a SKLearn SVC classifier on the [digits dataset](https://scikit-learn.org/stable/auto_examples/datasets/plot_digits_last_image.html).

If you're new to ZenML, let's quickly go over some [basic concepts](https://docs.zenml.io/core-concepts#basics-steps-and-pipelines) that help you understand what the code in this repository is doing:
* A **pipeline** in ZenML allows you to group a series of steps in whatever order makes sense for your particular use case. The [example pipeline](https://github.com/zenml-io/github-actions-orchestrator-tutorial/blob/main/pipelines/training_pipeline/training_pipeline.py) consists of three steps which import data, train a model and evaluate the model.
* A **step** is very similar to a Python function and contains arbitrary business logic. The three steps in our example do the following:
    - The [data loader step](https://github.com/zenml-io/github-actions-orchestrator-tutorial/blob/main/steps/data_loader_step/data_loader_step.py) loads the digits dataset and splits it into train and test set.
    - The [trainer step](https://github.com/zenml-io/github-actions-orchestrator-tutorial/blob/main/steps/trainer_step/trainer_step.py) trains a SKLearn SVC classifier on the training set returned by the data loader step.
    - The [evaluator step](https://github.com/zenml-io/github-actions-orchestrator-tutorial/blob/main/steps/evaluator_step/evaluator_step.py) evaluates the model returned by the trainer step on the test set.


Let's get going:

1. Go to https://github.com/zenml-io/github-actions-orchestrator-tutorial
2. Click on `Fork` in the top right:

    ![Fork step 1](../assets/posts/github-actions-orchestrator/fork_0.png)

3. Click on `Create fork`:

    ![Fork step 2](../assets/posts/github-actions-orchestrator/fork_1.png)

4. Clone the repository to your local machine:
    ```bash
    git clone git@github.com:"$GITHUB_USERNAME"/github-actions-orchestrator-tutorial.git
    # or `git clone https://github.com/"$GITHUB_USERNAME"/github-actions-orchestrator-tutorial.git` if you want to authenticate with HTTPS instead of SSL
    cd github-actions-orchestrator-tutorial
    ```

## ZenML Setup

Now that we're done setting up and configuring all our infrastructure and external dependencies, it's time to install ZenML and configure a ZenML stack that connects all these elements together.

### Installation

Let's install ZenML and all the additional packages that we're going to need to run our pipeline:
```bash
pip install zenml
zenml integration install github azure
```

We're also going to initialize a [ZenML repository](https://docs.zenml.io/developer-guide/repo-and-config#the-zenml-repository) to indicate which directories and files ZenML should include
when building Docker images:
```bash
zenml init
```
### Registering the stack

A [ZenML stack](https://docs.zenml.io/advanced-guide/stacks-components-flavors) consists of many components which all play a role in making your ML pipeline run in a smooth and reproducible manner. Let's register all the components that we're going to need for this tutorial!

* The **orchestrator** is responsible for running all the steps in your machine learning pipeline. In this tutorial we'll use the new GitHub Actions orchestrator which, as the name already indicates, uses GitHub Actions workflows to orchestrate your ZenML pipeline. Registering the orchestrator is as simple as running the following command:
    ```bash
    zenml orchestrator register github_orchestrator --flavor=github  
    ```

* We'll also need to configure a **container registry** which will point ZenML to a Docker registry to store the images that ZenML builds in order to run your pipeline. Luckily, your GitHub account already comes with a free container registry! To register it simply run:
    ```bash
    zenml container-registry register github_container_registry \
        --flavor=github \
        --automatic_token_authentication=true \
        --uri=ghcr.io/"$GITHUB_USERNAME"
    ```

* The **secrets manager** is used to securely store all your credentials so ZenML can use them to authenticate with other components like your metadata or artifact store. We're going to use a secrets manager implementation that stores these credentials as [encrypted GitHub secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets):
    ```bash
    zenml secrets-manager register github_secrets_manager \
        --flavor=github \
        --owner="$GITHUB_USERNAME" \
        --repository=github-actions-orchestrator-tutorial
    ```

* **Metadata stores** keep track of all the metadata associated with pipeline runs. They enable [ZenML's caching functionality](https://docs.zenml.io/developer-guide/caching) and allow us to query the parameters and inputs/outputs of steps of past pipeline runs. We'll register the MySQL database we created before with the following command (after replacing `<MYSQL_SERVER_NAME>` with the value we [noted down](#set-up-a-mysql-database)):
    ```bash
    zenml metadata-store register azure_metadata_store \
        --flavor=mysql \
        --secret=azure_mysql_auth \
        --database=zenml \
        --host=<MYSQL_SERVER_NAME>
    ```

* The **artifact store** stores all the artifacts that get passed as inputs and outputs of your pipeline steps. To register our blob storage container, replace the `<BLOB_STORAGE_CONTAINER_PATH>` placeholder in the following command with the path we saved when [creating the blob storage container](#create-an-azure-blob-storage-container) and run it:
    ```bash
    # The `az://` in front of the container name tells ZenML that this is an Azure container that it needs to read from/write to
    zenml artifact-store register azure_artifact_store \
        --flavor=azure \
        --authentication_secret=azure_store_auth \
        --path=az://<BLOB_STORAGE_CONTAINER_NAME>
    ```

These are all the components that we're going to use for this tutorial, but ZenML offers additional components like:
* **Step operators** to run individual steps of your pipeline in specialized environments.
* **Model deployers** to deploy your trained machine learning model in production.
* And many more. Check out [our docs](https://docs.zenml.io/advanced-guide/stacks-components-flavors#stacks) for a full list of available components.

With all components registered, we can now create and activate our ZenML stack. This makes sure ZenML knows which components to use when we're going to run our pipeline later.
```bash
zenml stack register github_actions_stack \
    -o github_orchestrator \
    -x github_secrets_manager \
    -c github_container_registry \
    -m azure_metadata_store \
    -a azure_artifact_store \
    --set
```

### Registering the secrets

Once the stack is active, we can register the secrets that ZenML needs to authenticate with some of our stack components.

Let's start with the secret for our metadata store. For this, we'll use some of the information we've saved when [setting up the MySQL database](#set-up-a-mysql-database) earlier. More specifically, we're going to the need:
- the username and password to authenticate with the MySQL database
- the path to the SSL certificate that we downloaded (make sure to use an absolute path with your user home directory expanded, e.g. `/home/username/certificate.crt.pem` instead of `~/certificate.crt.pem`)

Replace the `<PLACEHOLDERS>` in the following command with those concrete values and run it:
```bash
# the `@` prefix in front of the SSL certificate path tells ZenML to load the secret value from a file instead of using the string that was passed as the argument value
zenml secret register azure_mysql_auth \
    --schema=mysql \
    --user=<MYSQL_USERNAME> \
    --password=<MYSQL_PASSWORD> \
    --ssl_ca=@<PATH_TO_SSL_CERTIFICATE>
```

For the artifact store secret, we're going to need the **storage account name** and **key** that we saved when we [created our storage account earlier](#create-a-storage-account).
Replace the `<PLACEHOLDERS>` in the following command with those concrete values and run it:
```bash
zenml secret register azure_store_auth \
    --schema=azure \
    --account_name=<STORAGE_ACCOUNT_NAME> \
    --account_key=<STORAGE_ACCOUNT_KEY>
```

## Run the pipeline

That was quite a lot of setup, but luckily we're (almost) done now.
Let's execute the python script that "runs" our pipeline and quickly discuss what it is doing:
```bash
python run.py
```

This script runs a ZenML pipeline using our active GitHub stack. The orchestrator will now build a Docker image with our pipeline code and all the requirements installed and push it to the GitHub container registry.
Once the image is pushed, the orchestrator will write a [GitHub Actions workflow file](https://docs.github.com/en/actions/using-workflows/about-workflows) to the directory `.github/workflows`. Pushing this workflow
file will trigger the actual execution of our ZenML pipeline. We'll explain later at how to automate this step, but for our first pipeline run there is one last configuration step we need to do: We need to make sure
our GitHub Actions are allowed to pull the Docker image that ZenML just pushed.

1. Wait until the python script has finished running so the Docker image is pushed to GitHub.
2. Head to `https://github.com/users/<GITHUB_USERNAME>/packages/container/package/zenml-github-actions` (replace `<GITHUB_USERNAME>` with your GitHub username) and select `Package settings` on the right side:
    
    ![Package permissions step 1](../assets/posts/github-actions-orchestrator/package_permissions_0.png)

3. In the `Manage Actions access` section, click on `Add Repository`:
    
    ![Package permissions step 2](../assets/posts/github-actions-orchestrator/package_permissions_1.png)

4. Search for your forked repository `github-actions-orchestrator-tutorial` and give it read permissions. Your package settings should then look like this:

    ![Package permissions step 3](../assets/posts/github-actions-orchestrator/package_permissions_2.png)

Done! Now all that's left to do is commit and push the workflow file:
```bash
git add .github/workflows
git commit -m "Add ZenML pipeline workflow"
git push
```

If we now check out the GitHub Actions for our repository here `https://github.com/<GITHUB_USERNAME>/github-actions-orchestrator-tutorial/actions` we should see our pipeline running! 🎉

![Running pipeline](../assets/posts/github-actions-orchestrator/success_0.png)

![Finished pipeline](../assets/posts/github-actions-orchestrator/success_1.png)

## Automate the committing and pushing

If we want the orchestrator to automatically commit and push the workflow file for us, we can enable it with the following command:
```bash
zenml orchestrator update github_orchestrator --push=true
```

After this update, calling `python run.py` should automatically build and push a Docker image, commit and push the workflow file which will in turn run our pipeline on GitHub Actions.

## Delete Azure Resources

Once we're done experimenting, let's delete all the resources we created on Azure so we don't waste any compute/money. As we've bundled it all in one resource group, this step is very easy. Go [the Azure portal](https://portal.azure.com/#home) and select your resource group in the list of resources:

![Cleanup step 1](../assets/posts/github-actions-orchestrator/cleanup_0.png)

Next click on `Delete resource group` on the top:

![Cleanup step 2](../assets/posts/github-actions-orchestrator/cleanup_1.png)

In the popup on the right side, type the resource group name and click `Delete`:

![Cleanup step 3](../assets/posts/github-actions-orchestrator/cleanup_2.png)

This will take a few minutes, but after it's finished all the resources we created should be gone.

## TODO: Call to action

[*Image Credit: Photo by [Roman Synkevych](https://unsplash.com/@synkevych) on [Unsplash](https://unsplash.com/s/photos/github)*]