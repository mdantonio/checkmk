# Logwatch configuration

This configuration is based on the standard configuration, but expanded with custom rules on /var/log/syslog (also used by rapydo containers), fail2ban.log (when installed on the host) and Suricata IDS logs

## Installation

This configuration file can be replaced to the standard logwatch configuration file in `/etc/check_mk/logwatch.cfg`

```
sudo curl https://raw.githubusercontent.com/mdantonio/checkmk/main/logwatch/logwatch.cfg --output /etc/check_mk/logwatch.cfg

```

## Upgrade

This configuration file is often upgraded, in particular the section related to the suricata logs. To ease the upgrade process a couple of ansible playbooks are provided.

Both are configured to run on hosts configured in a `logwatch` section in /etc/ansible/hosts

```
ansible-playbook logwatch-playbook.yml
ansible-playbook logwatch-suricata-playbook.yml

ansible-playbook logwatch-playbook.yml --limit=myhost
ansible-playbook logwatch-playbook.yml --limit=myhost1,myhost2
```
