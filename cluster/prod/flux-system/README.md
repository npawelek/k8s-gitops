# Flux GitOps Toolkit (GOTK)

## Bootstrap Upgrade

https://toolkit.fluxcd.io/guides/installation/#bootstrap-upgrade

```
[k8s-gitops]$  export GITHUB_TOKEN=xxxx

[k8s-gitops]$ flux bootstrap github \
  --owner npawelek \
  --repository k8s-gitops \
  --path "./cluster/prod/" \
  --branch master \
  --personal \
  --arch amd64 \
  --network-policy \
  --namespace flux-system

[k8s-gitops]$ flux check
► checking prerequisites
✔ kubectl 1.20.1 >=1.18.0
✔ Kubernetes 1.20.1 >=1.16.0
► checking controllers
✔ source-controller is healthy
► ghcr.io/fluxcd/source-controller:v0.5.6
✔ kustomize-controller is healthy
► ghcr.io/fluxcd/kustomize-controller:v0.5.3
✔ helm-controller is healthy
► ghcr.io/fluxcd/helm-controller:v0.4.4
✔ notification-controller is healthy
► ghcr.io/fluxcd/notification-controller:v0.5.0
✔ all checks passed

[k8s-gitops]$ git fetch
[k8s-gitops]$ git rebase origin/master
Successfully rebased and updated refs/heads/master.
```
