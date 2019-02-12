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


Example
===========
Clone to formulas, add to file_roots and restart master
```
root@salt:/srv/formulas# git clone https://github.com/claudekenni/pillarstack_sdb.git
Cloning into 'pillarstack_sdb'...
remote: Enumerating objects: 27, done.
remote: Counting objects: 100% (27/27), done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 211 (delta 3), reused 26 (delta 3), pack-reused 184
Receiving objects: 100% (211/211), 43.04 KiB | 0 bytes/s, done.
Resolving deltas: 100% (95/95), done.
Checking connectivity... done.
root@salt:/srv/formulas# service salt-master restart
```

Apply the stack state
```
root@salt:/srv/formulas# salt-call state.apply stack
local:
----------
          ID: copy-stack
    Function: file.recurse
        Name: /etc/salt/stack
      Result: True
     Comment: Recursively updated /etc/salt/stack
     Started: 21:57:46.452436
    Duration: 289.484 ms
     Changes:
              ----------
              /etc/salt/stack/common:
                  ----------
                  /etc/salt/stack/common:
                      New Dir
              /etc/salt/stack/common/common.yml:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
              /etc/salt/stack/common/salt-minion.yml:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
              /etc/salt/stack/core.yml:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
              /etc/salt/stack/minions:
                  ----------
                  /etc/salt/stack/minions:
                      New Dir
              /etc/salt/stack/minions/.gitkeep:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
              /etc/salt/stack/minions/minion.yml:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
              /etc/salt/stack/osarchs:
                  ----------
                  /etc/salt/stack/osarchs:
                      New Dir
              /etc/salt/stack/osarchs/amd64.yml:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
              /etc/salt/stack/oscodenames:
                  ----------
                  /etc/salt/stack/oscodenames:
                      New Dir
              /etc/salt/stack/oscodenames/xenial.yml:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
              /etc/salt/stack/stack.cfg:
                  ----------
                  diff:
                      New file
                  mode:
                      0644
----------
          ID: sdb-config
    Function: file.managed
        Name: /etc/salt/minion.d/sdb.conf
      Result: True
     Comment: File /etc/salt/minion.d/sdb.conf updated
     Started: 21:57:46.745508
    Duration: 35.744 ms
     Changes:
              ----------
              diff:
                  New file
              mode:
                  0644
----------
          ID: restart-salt-minion
    Function: cmd.run
        Name: echo salt-call --local service.restart salt-minion | at now + 1 minute
      Result: True
     Comment: Command "echo salt-call --local service.restart salt-minion | at now + 1 minute" run
     Started: 21:57:46.783831
    Duration: 9.454 ms
     Changes:
              ----------
              pid:
                  25656
              retcode:
                  0
              stderr:
                  warning: commands will be executed using /bin/sh
                  job 41 at Tue Feb 12 21:58:00 2019
              stdout:

Summary for local
------------
Succeeded: 3 (changed=3)
Failed:    0
------------
Total states run:     3
Total run time: 334.682 ms
```

Configuration
```
cat /etc/salt/minion.d/sdb.conf:
stack:
  driver: stack

data: sdb://stack/data
```

Stack Tree
```
tree /etc/salt/stack
/etc/salt/stack
├── common
│   ├── common.yml
│   └── salt-minion.yml
├── core.yml
├── minions
│   └── minion.yml
├── osarchs
│   └── amd64.yml
├── oscodenames
│   └── xenial.yml
└── stack.cfg

4 directories, 7 files
```

Check the Configuration
```
root@salt:~# salt-call config.get data
local:
    ----------
    common:
        True
    core:
        Testvalue
    salt:
        ----------
        minion:
            ----------
            master:
                127.0.0.1
```