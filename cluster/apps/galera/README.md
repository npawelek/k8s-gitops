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
7. Scale to galera nodes to 3

```
k scale -n galera sts mariadb-galera --replicas 3
```

9. Revert configs
10. Commit
11. Push
