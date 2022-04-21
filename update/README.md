# Agent Update

This script is used to update the agent and all the plugins on the host

## Installation

Copy this script in `/usr/local/bin/check_mk_upgrade` and grant execution permissions

```
sudo curl https://raw.githubusercontent.com/mdantonio/checkmk/main/update/agent_update.sh --output /usr/local/bin/check_mk_upgrade
sudo chmod 700 /usr/local/bin/check_mk_upgrade
```

## Usage

Execute with

```
sudo check_mk_upgrade -h https://your-check-mk-host
```
