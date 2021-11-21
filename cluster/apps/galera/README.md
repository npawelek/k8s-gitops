# Galera Notes

## Safely bootstrap a specific node

1. Scale to galera nodes to 0

```
k scale -n galera sts mariadb-galera --replicas 0
```

2. Determine nodes grastate.dat

```
k apply -f galera_recovery.yaml
k exec -it -n galera recovery- -- bash
cat /data[012]/data/grastate.dat
```

3. Update galera-helm-secrets with with bootstrap section

```
galera:
  name: galera
  # Use node numbering based on the sts node: 0, 1, or 2
  # Must also set helmrelease podManagementPolicy to Parallel
  bootstrap:
    bootstrapFromNode: 0
    forceSafeToBootstrap: true
```

4. Set HelmRelease podManagementPolicy to Parallel

```
podManagementPolicy: Parallel
```

5. Commit
6. Push
7. Delete sts, hr, and helm secret

```
k delete -n galera secret galera-helm-values
k delete -n galera sealedsecrets.bitnami.com galera-helm-values
k delete -n galera sts mariadb-galera
k delete -n galera hr mariadb-galera
```

8. Reconcile

```
fr
flux reconcile kustomization cluster-apps
```

9. Scale galera nodes to 0 (this will ensure proper state for reverting configs)

```
k scale -n galera sts mariadb-galera --replicas 2
# wait
k scale -n galera sts mariadb-galera --replicas 1
# wait
k scale -n galera sts mariadb-galera --replicas 0
```

10. Suspend Flux

```
flux suspend kustomization --all
```

11. Delete sts, hr, and helm secret

```
k delete -n galera secret galera-helm-values
k delete -n galera sealedsecrets.bitnami.com galera-helm-values
k delete -n galera sts mariadb-galera
k delete -n galera hr mariadb-galera
```

12. Revert configs
13. Commit
14. Push
15. Recon
16. Resume Flux

```
flux resume kustomization --all
```
