copy-stack:
  file.recurse: 
    - name: /etc/salt/stack
    - source: salt://{{tpldir}}/stack
    - clean: True
    - include_empty: True

sdb-config:
  file.managed:
    - name: /etc/salt/minion.d/sdb.conf
    - source: salt://{{ tpldir }}/templates/sdb.conf
    - template: jinja

restart-salt-minion:
  cmd.run:
    - name: echo salt-call --local service.restart salt-minion | at now + 1 minute
    - order: last
    - watch:
      - file: copy-stack
      - file: sdb-config

