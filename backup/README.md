# Backup verification plugin

This plugin is intended for verification that backup procedures run regularly

## Installation

Copy the script in /usr/lib/check_mk_agent/local/3600/ and grant execution permissions

```
sudo mkdir -p /usr/lib/check_mk_agent/local/3600

sudo curl https://raw.githubusercontent.com/mdantonio/checkmk/main/backup/check_backup --output /usr/lib/check_mk_agent/local/3600/check_backup

sudo chmod 755 /usr/lib/check_mk_agent/local/3600/check_backup
```

## Configuration

This script automatically detect the rapydo and rsnapshot executables.

If rapydo is installed on the host, than a specific configuration is expected to be found in

```
/etc/check_mk/backup.cfg
```

listing the backup folders and the backup schedule, for example:

```
1 /home/myuser/myproject/data/backup/neo4j
7 /home/myuser/myproject/data/backup/redis
```

This way neo4j are expected to be executed on a daily basis, while redis backups are expected weekly

Rsnapshot configuration is automatically extracted from the standard `/etc/rsnapshot.conf`, no further configuration is needed

### Backup folders on nfs with root squashing enabled

CheckMK plugins are executed as root, but due to root squashing this can fail due to permissions denied if the backup folder is on nfs.
This problem can be overcome by make the check_backup script non-executable (to be ignored by CheckMK) and then create a wrapper like this in the plugin folders:

```
#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    python3 ./check_backup
else
    su ubuntu -c "python3 ./check_backup"
fi
```

This way the check backup plugin will be always executed as non-root user
