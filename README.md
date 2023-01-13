# HMC Docker :whale:

- [Prerequisites](#prerequisites)
- [Quick start](#quick-start)
- [Using HMC](#using-hmc)
- [Running branches](#running-branches)
- [Under the hood](#under-the-hood-speedboat)
- [Containers](#containers)
- [Troubleshooting](#troubleshooting)
- [Remarks](#remarks)
- [License](#license)

## Prerequisites

- [Docker](https://www.docker.com)

- *Memory and CPU allocations may need to be increased for successful execution of hmi applications altogether. (On Preferences / Advanced)*

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) - minimum version 2.0.57
- [jq Json Processor](https://stedolan.github.io/jq)

- *The following documentation assumes that the current directory is `hmc-docker`.*

- All Azure resources (topics, subscriptions, inbound and outbound queues, and their corresponding connection strings) 
have been created and configured, see [Creating Azure Service Bus Resources](https://tools.hmcts.net/confluence/display/HMAN/Creating+Azure+Service+Bus+Resources) 
for details.

## Quick start

Checkout `hmc-docker` project:

```bash
git clone git@github.com:hmcts/hmc-docker.git
cd hmc-docker
```

### Set environment variables

Apply all of the environment variables set in `bin/env_variables_all.txt`, by running command

````
source bin/env_variables_all.txt
````

#### Azure specific environment variables

The following Azure environment variables need to be exported with the relevant values -  Azure Service Bus connection 
strings for queues and topics, and queue and topic names. 
 
These values should **not** be stored in any files under version control as they will store user specific values - see 
[Environment Variables](https://tools.hmcts.net/confluence/display/HMAN/Environment+Variables) for the recommended 
approach to setting these.

For details on getting the values for these environment variables, see [Creating Azure Service Bus Resources](https://tools.hmcts.net/confluence/display/HMAN/Creating+Azure+Service+Bus+Resources).



Once set these environment variables are used in the `hmi.yml` to configure the following docker containers

 - hmc-hmi-outbound-adapter
 - hmc-hmi-inbound-adapter
 - hmc-cft-hearing-service
 
```
export HMC_SERVICE_BUS_INBOUND_CONNECTION_STRING=xxx
export HMC_SERVICE_BUS_INBOUND_QUEUE=xxx

export HMC_SERVICE_BUS_OUTBOUND_CONNECTION_STRING=xxx
export HMC_SERVICE_BUS_OUTBOUND_QUEUE=xxx

export HMC_QUEUE_CONNECTION_STRING=xxx
export HMC_SERVICE_BUS_QUEUE=xxx
export HMC_OUTBOUND_QUEUE_CONNECTION_STRING=xxx
export HMC_OUTBOUND_SERVICE_BUS_QUEUE=xxx
export HMC_SERVICE_BUS_CONNECTION_STRING=xxx
export HMC_SERVICE_BUS_TOPIC=xxx
export HMC_SERVICE_BUS_SUBSCRIPTION=xxx

````

#### HMI/LA Specific Environment Variables

The following HMI environment variables need to be exported with the relevant values.

These values should **not** be stored in any files under version control as they will store user specific values - see
[Environment Variables](https://tools.hmcts.net/confluence/display/HMAN/Environment+Variables) for the recommended
approach to setting these.

Once set these environment variables are used in the `hmi.yml` to configure the following docker containers

- hmc-hmi-outbound-adapter
- hmc-cft-hearing-service

```
export FH_BASE_URL = ""
export CLIENT_ID = ""
export CLIENT_SECRET = ""
export SCOPE = ""
export HMI_BASE_URL = ""

````

### Pull latest container images

Login to the Azure Container registry:

```bash
./hmc login
```
Note:
if you experience any error with the above command, try `az login` first

For [Azure Authentication for pulling latest docker images](#azure-authentication-for-pulling-latest-docker-images)

Pulling latest Docker images:

```bash
./hmc compose pull
```

### Running initialisation steps

Note:
required only on the first run. Once executed, it doesn't need to be executed again

```bash
./hmc init
```

Creating and starting the containers:

```bash
./hmc compose up -d
```

Usage and commands available:

```bash
./hmc
```

## Using HMC

Verify HMC containers are running by hitting the `/health` endpoints and ensuring the response is

```bash
{"status":"UP"}
```

1. Outbound Adapter health can be verified using

 ```bash
curl http://localhost:4558/health
 ```

2. Inbound Adapter health can be verified using

```bash
curl http://localhost:4559/health
 ```

3. CFT Hearing Service can be run using

```bash
curl http://localhost:4561/health
 ```

## Running branches

By default, all HMC containers are running with the `latest` tag, built from the `master` branch.

### Switch to a branch

Using the `set` command, branches can be changed per project. It's possible to switch to remote branches but also to local branches

To switch to a remote branch the command is:

```bash
./hmc set <project> <remote_branch>
```

* `<project>` the service name as declared in the compose file, e.g. hmc-hmi-outbound-adapter-api, hmc-hmi-inbound-adapter-api
* `<remote_branch>` must be an existing **remote** branch for the selected project.

To switch to a local branch the command is:

```bash
./hmc set <project> <local_branch> <file://local_repository_path>
```
* `<project>` the service name as declared in the compose file, e.g. hmc-hmi-outbound-adapter-api, hmc-hmi-inbound-adapter-api
* `<local_branch>` must be an existing **local** branch for the selected project.
* `<file://local_repository_path>` path to the root of the local project repository

__Note__: when working with local branches, to be able to run any new set of local changes those must first be committed and the `switch to a local branch` and `Apply` procedure repeated.

Branches for a project can be listed using:

```bash
./hmc branches <project>
```

### Apply

When switching to a branch, a Docker image is built locally and the Docker compose configuration is updated.

However, to make that configuration effective, the Docker containers must be updated using:

```bash
./hmc compose up -d
```

### Revert to `master`

When a project has been switched to a branch, it can be reverted to `master` in 2 ways:

```bash
./hmc set <project> master
```

or

```bash
./hmc unset <project> [<projects...>]
```

The only difference is that `unset` allows for multiple projects to be reset to `master`.

In both cases, like with the `set` command, for the reset to be effective it requires the containers to be updated:

```bash
./hmc compose up -d
```

### Current branches

To know which branches are currently used, the `status` command can be used:

```bash
./hmc status
```

The 2nd part of the output indicates the current branches.
The output can either be of the form:

> No overrides, all using master

when no branches are used; or:

> Current overrides:
> hmc-hmi-outbound-adapter-api branch:HMC-12252 hash:ced648d

when branches are in use.

:information_source: *In addition to the `status` command, the current status is also displayed for every `compose` commands.*

## Under the hood :speedboat:

### Set

#### Non-`master` branches

When switching to a branch with the `set` command, the following actions take place:

1. The given branch is cloned in the temporary `.workspace` folder
2. If required, the project is built
3. A docker image is built
4. The Docker image is tagged as `hmcts/<project>:<branch>-<git hash>`
5. An entry is added to file `.tags.env` exporting an environment variable `<PROJECT>_TAG` with a value `<branch>-<git hash>` matching the Docker image tag

The `.tags.env` file is sourced whenever the `hmc compose` command is used and allows to override the Docker images version used in the Docker compose files.

Hence, to make that change effective, the containers must be updated using `./hmc compose up`.

#### `master` branch

When switching a project to `master` branch, the branch override is removed using the `unset` command detailed below.

### Unset

Given a list of 1 or more projects, for each project:

1. If `.tags.env` contains an entry for the project, the entry is removed

Similarly to when branches are set, for a change to `.tags.env` to be applied, the containers must be updated using `./hmc compose up`.

### Status

Retrieve from `.tags.env` the branches and compose files currently enabled and display them.

### Compose

```bash
./hmc compose [<docker-compose command> [options]]
```

The compose command acts as a wrapper around `docker-compose` and accept all commands and options supported by it.

:information_source: *For the complete documentation of Docker Compose CLI, see [Compose command-line reference](https://docs.docker.com/compose/reference/).*

Here are some useful commands:

#### Up

```bash
./hmc compose up [-d]
```

This command:
1. Create missing containers
2. Recreate outdated containers (= apply configuration changes)
3. Start all enabled containers

The `-d` (detached) option start the containers in the background.

#### Down

```bash
./hmc compose down [-v] [project]
```

This stops and destroys all composed containers.

If provided, the `-v` option will also clean the volumes.

Destroyed containers cannot be restarted. New containers will need to be built using the `up` command.

#### Ps

```bash
./hmc compose ps [<project>]
```

Gives the current state of all or specified composed projects.

#### Logs

```bash
./hmc compose logs [-f] [<project>]
```

Displays the logs for all or specified composed projects.

The `-f` (follow) option allows to follow the tail of the logs.

#### Start/stop

```bash
./hmc compose start [<project>]
./hmc compose stop [<project>]
```

Start or stop all or specified composed containers. Stopped containers can be restarted with the `start` command.

:warning: Please note: Re-starting a project with stop/start does **not** apply configuration changes. Instead, the `up` command should be used to that end.

#### Pull

```bash
./hmc compose pull [project]
```

Fetch the latest version of an image from its source. For the new version to be used, the associated container must be re-created using the `up` command.

## Containers

### Back-end

#### hmc-hmi-outbound-adapter-api

Outbound Adaptor will take care of all the necessary security enforcement that is required by HMI.

#### hmc-hmi-inbound-adapter-api

This will be the main interface that receives the asynchronous request from HMI. Key function of this component is to ensure that the request that is received relates to one of the hearing request that was previously sent by HMC

### Azure Authentication for pulling latest docker images

```bash
ERROR: Get <docker_image_url>: unauthorized: authentication required
```

If you see this above authentication issue while pulling images, please follow below commands,

Install Azure-CLI locally,

```bash
brew update && brew install azure-cli
```

and to update a Azure-CLI locally,

```bash
brew update azure-cli
```

then,
login to MS Azure,

```bash
az login
```
and finally, Login to the Azure Container registry:

```bash
./hmc login
```

On windows platform, we are installing the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) using executable .msi file.
If "az login" command throws an error like "Access Denied", please follow these steps.
We will need to install the az cli using Python PIP.
1. If Microsoft Azure CLI is already installed, uninstall it from control panel.
2. Setup the Python(version 2.x/3.x) on windows machine. PIP is bundled with Python.
3. Execute the command "pip install azure-cli" using command line. It takes about 20 minutes to install the azure cli.
4. Verify the installation using the command az --version.

## Troubleshooting

hmc-network could not be found error:

- if you get "HMC: ERROR: Network hmc-network declared as external, but could not be found. Please create the network manually using docker network create hmc-network"
    > ./hmc init

## Remarks

- A container can be configured to call a localhost host resource with the localhost shortcut added for docker containers recently. However the shortcut must be set according the docker host operating system.

```bash
# for Mac
docker.for.mac.localhost
# for Windows
docker.for.win.localhost
```

Remember that once you changed the above for a particular app you have to make sure the container configuration for that app does not try to automatically start the dependency that you have started locally. To do that either comment out the entry for the locally running app from the **depends_on** section of the config or start the app with **--no-deps** flag.

- If you happen to run `docker-compose up` before setting up the environment variables, you will probably get error while starting the DB. In that
case, clear the containers but also watch out for volumes created to be cleared to get a fresh start since some initialisation scripts don't run if
you have already existing volume for the container.

```bash
$ docker volume list
DRIVER              VOLUME NAME

# better be empty
```

## LICENSE

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
