# Longhorn

## Node Labeling

Ansible playbooks to deploy nodes will setup all the necessary aspects of
Longhorn particular to the nodes, except for the Longhorn label:

```
k label node <name> node.longhorn.io/create-default-disk=true
```
