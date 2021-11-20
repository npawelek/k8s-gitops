# Galera Notes

## Safely bootstrap a specific node

1. Scale to galera nodes to 0

```
k scale -n galera sts mariadb-galera --replicas 0
```

2. Update galera-helm-secrets with with bootstrap section

```
galera:
  name: galera
  # Use node numbering based on the sts node: 0, 1, or 2
  # Must also set helmrelease podManagementPolicy to Parallel
  bootstrap:
    bootstrapFromNode: 2
    forceSafeToBootstrap: true
```

3. Set podManagementPolicy in HelmRelease to Parallel

```
podManagementPolicy: Parallel
```

4. Commit
5. Push
6. Reconcile
7. Scale to galera nodes to 0 (this will ensure proper state for reverting configs)

```
k scale -n galera sts mariadb-galera --replicas 2
# wait
k scale -n galera sts mariadb-galera --replicas 1
# wait
k scale -n galera sts mariadb-galera --replicas 0
```

9. Suspend Flux

```
flux suspend kustomization --all
```

10. Delete sts, hr, and helm secret

```
k delete -n galera secret galera-helm-values
k delete -n galera sts mariadb-galera
k delete -n galera hr mariadb-galera
```

11. Revert configs
12. Commit
13. Push
14. Resume Flux

```
flux resume kustomization --all
```
