# Flux GitOps Toolkit (GOTK)

## Bootstrap Upgrade

https://toolkit.fluxcd.io/guides/installation/#bootstrap-upgrade

```
[k8s-gitops]$ ansible-vault decrypt cluster/core/sealed-secrets/sealed-secrets-key.yaml
[k8s-gitops]$ k apply -f cluster/core/sealed-secrets/sealed-secrets-key.yaml
[k8s-gitops]$ ansible-vault encrypt cluster/core/sealed-secrets/sealed-secrets-key.yaml

[k8s-gitops]$  export GITHUB_TOKEN=xxxx

[k8s-gitops]$ flux bootstrap github \
  --owner npawelek \
  --repository k8s-gitops \
  --path "./cluster/base/" \
  --branch master \
  --personal \
  --network-policy \
  --namespace flux-system
► connecting to github.com
► cloning branch "master" from Git repository "https://github.com/npawelek/k8s-gitops.git"
✔ cloned repository
► generating component manifests
✔ generated component manifests
✔ committed sync manifests to "master" ("443af1bc7792fa21bf486be229448b22b673d6d1")
► pushing component manifests to "https://github.com/npawelek/k8s-gitops.git"
► installing toolkit.fluxcd.io CRDs
◎ waiting for CRDs to be reconciled
✔ CRDs reconciled successfully
► installing components in "flux-system" namespace
✔ installed components
✔ reconciled components
► determining if source secret "flux-system/flux-system" exists
► generating source secret
✔ public key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhdXCYwLd3KPJzuxYpq4WkxUcEKP3BnEX0CDF9q+jQ5j5pD9guQ4hIAzNaIyWZLbtYCZkRibw144oudV92HWaFcdR1iAi67x/80Rl9xiHM6FHzl/PaXekTaMP9njdG4WgmYonpLUGj/6mAFELaBri1b5BO2E1o4fCqfZIWDIaBogRBfs4XFk4HPy8JRys7PEOenBFf3ANKq+/G+t6uJ/kf/n7ot4rcDhd8wYKIDMza1G+CYYA0RaPrkSgQbRS/x2AWledc6IvCXbs2KTLxOa5HQSG1kKrI1kbOQtYFLrdSAJ5aFyhMOB9GQPDfyLfqPPhebpRPBdoZ1XJD4RPZH5WX
✔ configured deploy key "flux-system-master-flux-system-./cluster/base" for "https://github.com/npawelek/k8s-gitops"
► applying source secret "flux-system/flux-system"
✔ reconciled source secret
► generating sync manifests
✔ generated sync manifests
✔ committed sync manifests to "master" ("4f2f42f5b3087d050299549db1b6cf5f5c1fb139")
► pushing sync manifests to "https://github.com/npawelek/k8s-gitops.git"
► applying sync manifests
✔ reconciled sync configuration
◎ waiting for Kustomization "flux-system/flux-system" to be reconciled
✔ Kustomization reconciled successfully
► confirming components are healthy
✔ kustomize-controller: deployment ready
✔ helm-controller: deployment ready
✔ notification-controller: deployment ready
✔ source-controller: deployment ready
✔ all components are healthy

[k8s-gitops]$ flux check
► checking prerequisites
✔ kubectl 1.22.1 >=1.18.0-0
✔ Kubernetes 1.22.1 >=1.16.0-0
► checking controllers
✔ helm-controller: deployment ready
► ghcr.io/fluxcd/helm-controller:v0.11.2
✔ kustomize-controller: deployment ready
► ghcr.io/fluxcd/kustomize-controller:v0.13.3
✔ notification-controller: deployment ready
► ghcr.io/fluxcd/notification-controller:v0.15.1
✔ source-controller: deployment ready
► ghcr.io/fluxcd/source-controller:v0.15.4
✔ all checks passed

[k8s-gitops]$ git fetch
[k8s-gitops]$ git rebase origin/master
Successfully rebased and updated refs/heads/master.
```
