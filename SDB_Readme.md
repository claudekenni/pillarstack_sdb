PillarStack_SDB Module
===========
This is an Idea on how this Pillar Module could be used as a SDB Module.
The basic premise is that the pillar data will distributed via the file state to the minions

This way we can then use that data the way sdb modules work:
```
cat /etc/salt/minion.d/sdb.conf
stack:
  driver: stack
```
```
salt-call sdb.get sdb://stack/data
```

or by changing the sdb config to:
```
cat /etc/salt/minion.d/sdb.conf
stack:
  driver: stack

data: sdb://stack/data
```

we can use:
```
salt-call config.get data
```

With this we can use config.get instead of pillar.get within our states or merge this data within the map.jinja file
