---
layout: post
author: Michael Schuster
title: "Who needs Kubeflow when you have Github Actions"
description: ""
category: zenml
tags: zenml release-notes
publish_date: June 17, 2022
date: 2022-06-17T00:02:00Z
thumbnail: /assets/posts/release_0_9_0/allison-louise-xABgmlX4ABE-unsplash.jpg
image:
  path: /assets/posts/release_0_9_0/allison-louise-xABgmlX4ABE-unsplash.jpg
---

Note: 
* The commands in this tutorial depend on each other, so make sure to run them in the same terminal (otherwise some environment variables might not be set or the working directory will be wrong)

* In this tutorial we're going to use Azure for cloud storage and our MySQL database, but it works just as well on AWS or GCP.

## Prerequisites

This tutorial assumes that you have
* Docker installed
* git installed
* python installed (3.7-3.9)

## Azure Setup

### Create an account
### Create an Azure Blob Storage Container


Note down:
- <ACCOUNT_NAME>
- <ACCOUNT_KEY>
- <BLOB_STORAGE_CONTAINER_PATH>

### Host a MySQL database

Azure Database for MySQL


Note down: 
- <USERNAME>
- <PASSWORD>
- <HOST>
- <DATABASE_NAME>

Download:
- <PATH_TO_SSL_SERVER_CERTIFICATE>
- <SSL_CLIENT_CERTIFICATE>
- <SSL_CLIENT_KEY>

## GitHub Setup


### Create and clone a GitHub repository


```bash
git clone <>
cd <>
```


### Create a GitHub Personal Access Token



Let's set the values for this 

```bash
# Set environment variables for your GitHub username as well as the personal access token that you created earlier.
# These will be used to authenticate with the GitHub API in order to store credentials as GitHub secrets.
export GITHUB_USERNAME=<GITHUB_USERNAME>
export GITHUB_AUTHENTICATION_TOKEN=<GITHUB_AUTHENTICATION_TOKEN>
```


### Login to the Container registry

When we'll run our pipeline later, ZenML will build a Docker image for us which will be used to execute the steps of the pipeline. In order to access this image inside GitHub Actions workflow, we'll push it to the GitHub container registry. Running the following command will use the personal access token created in the previous step to authenticate our Docker client with this container registry:
```bash
docker login ghcr.io -u $GITHUB_USERNAME -p $GITHUB_AUTHENTICATION_TOKEN
```

## ZenML Setup

Now that we're done configuring all our infrastructure and external dependencies, it's time to install ZenML and configure a ZenML stack that connects all these elements together.


### Installation

- Virtualenv

```bash
pip install zenml
zenml integration install github azure
```

### Registering the stack

A ZenML stack consists of many components which all play a role in making your ML pipeline run in a smooth and reproducible manner. Let's go over all the components that we'll use for this example ...


The **orchestrator** is responsible for running all the steps in your machine learning pipeline. In this tutorial we'll use the GitHub Actions orchestrator which, as the name already indicates, uses GitHub Action workflows to run your ZenML pipeline.
Registering the orchestrator is as simple as running the following command:
```bash
zenml orchestrator register github_orchestrator --flavor=github  
```

We'll also need a **container registry** which will store the Docker images that ZenML builds in order to run your pipeline. Luckily, your GitHub account already comes with a free container registry! To register it simply run:
```bash
zenml container-registry register github_container_registry \
    --flavor=github \
    --automatic_token_authentication=true \
    --uri=ghcr.io/$GITHUB_USERNAME
```

The **secrets manager** is used to securely store all your credentials so ZenML can use them to authenticate with other components like your metadata or artifact store. We're going to use a secrets manager implementation that stores these credentials as [encrypted GitHub secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets):
```bash
zenml secrets_manager register github_secrets_manager \
    --flavor=github \
    --owner=$GITHUB_USERNAME \
    --repository=zenml-github-actions-tutorial
```

(If you've used a different name when [creating your GitHub repository earlier](#create-a-github-repository) (or reused an existing repository), replace the `zenml-github-actions-tutorial` with the name of the GitHub repository that you're using for this tutorial.)

**Metadata stores** 
```bash
zenml metadata-store register azure_metadata_store \
    --flavor=mysql \
    --secret=azure_mysql_secret \
    --host=<HOST> \
    --database=<DATABASE_NAME> \
```

The **artifact store** stores all the artifacts that get passed as inputs and outputs of your pipeline steps. To register it, replace the `<BLOB_STORAGE_CONTAINER_PATH>` placeholder in the following command with the path we saved when [creating the blob storage container](#create-an-azure-blob-storage-container) and run it:
```bash
zenml artifact-store register azure_artifact_store \
    --flavor=azure \
    --authentication_secret=azure_store_auth \
    --path=<BLOB_STORAGE_CONTAINER_PATH>
```

These are all the components that we're going to use for this tutorial, but ZenML offers additional components like:
* **Step operators** to run individual steps of your pipeline in specialized environments.
* **Model deployers** to deploy your trained machine learning model in production.
* And many more. Check out [our docs](https://docs.zenml.io/advanced-guide/stacks-components-flavors#stacks) for a full list of available components.

With all components registered, we can now create and activate our ZenML stack. This makes sure ZenML knows which components to use when we're going to run our pipeline later.
```bash
zenml stack register github_actions_stack \
    -o github_orchestrator \
    -s github_secrets_manager \
    -c github_container_registry \
    -m azure_metadata_store \
    -a azure_artifact_store \
    --set
```

### Registering the secrets

Once the stack is active, we can register the secrets that ZenML needs to authenticate with some of our stack components.

Let's start with the secret for our metadata store. For this, we're going to need some of the information we've saved when [hosting the MySQL database](#host-a-mysql-database) earlier. More specifically, we're going to the need:
- the username and password to authenticate with the MySQL database
- paths to the three SSL certificates that we downloaded

Replace the `<PLACEHOLDERS>` in the following command with those concrete values and run it:
```bash
# the @ prefix in front of the SSL certificate paths tells ZenML to load the secret value from a file instead of using the string that was passed as the argument value
zenml secret register azure_mysql_secret \
    --schema=mysql \
    --user=<USERNAME> \
    --password=<PASSWORD> \
    --ssl_ca=@<PATH_TO_SSL_SERVER_CERTIFICATE> \
    --ssl_cert=@<PATH_TO_SSL_CLIENT_CERTIFICATE> \
    --ssl_key=@<PATH_TO_SSL_CLIENT_KEY>
```

For the artifact store secret, we're going to need the **account name** and **account key** that we saved when we [created our blob storage container](#create-an-azure-blob-storage-container).
Replace the `<PLACEHOLDERS>` in the following command with those concrete values and run it:
```bash
zenml secret register azure_store_auth \
    --schema=azure \
    --account_name=<ACCOUNT_NAME> \
    --account_key=<ACCOUNT_KEY>
```

## Create the pipeline


## Run the pipeline