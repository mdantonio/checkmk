# Agent Update

This script is used to update the agent and all the plugins

## Installation

Copy this script in `/usr/local/bin/check_mk_upgrade` and grant execution permissions

```
sudo curl https://github.com/mdantonio/checkmk/blob/main/update//agent_update.sh --output /usr/local/bin/check_mk_upgrade
sudo chmod 700 /usr/local/bin/check_mk_upgrade
```

## Usage

execute with

```
sudo check_mk_upgrade -h https://your-check-mk-host
```
