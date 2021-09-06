# Longhorn

## Node Labeling

Ansible playbooks to deploy nodes will setup all the necessary aspects of
Longhorn particular to the nodes, except for the Longhorn label:

```
k label node <name> node.longhorn.io/create-default-disk=true
```

## Reclaiming a `Released` volume

Released volumes by default won't allow attaching to the existing PV. In order to resolve this, you can delete the PVC and patch the PV to ensure it's `Available`.

```
k delete pvc -n <ns> <pvc-name>
k patch pv <pvc-id> -p '{"spec":{"claimRef": null}}'
```
