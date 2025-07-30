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

## Restoring a volume from Longhorn backup

1. Validate backups exist for the associated volume
2. Scale down the workload
3. Ensure enough nodes are available for the number of replicas needed. The volume will fail restore otherwise
4. Delete the associated PVC and PV within the Kubernetes
5. Delete the volume in Longhorn
6. Navigate to backups and select the volume being restored
7. Choose a snapshot date and select restore from the drop-down, using original PV and PVC names
8. Wait for the new volume to populate and detach
9. Scale up the workload and validate restore was successful
10. Rinse and repeat if a different restore date is required
