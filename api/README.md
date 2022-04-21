# Experimental CheckMK API integration

### Create host

```
python3 check_mk.py host create --host https://your.dashboard.url --username $USER --password $PASS --folder <folder> --name <name> --ip <ip>
```

### Create docker-based host

```
python3 check_mk.py host create --host https://your.dashboard.url --username $USER --password $PASS --folder <folder> --name bla_bla_1 --parent <parent-name>
```
