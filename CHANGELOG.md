[//]: # (START/LATEST)
# Latest

## Features
  * A user-friendly description of a new feature. {issue-number}

## Fixes
 * A user-friendly description of a fix. {issue-number}

## Security
 * A user-friendly description of a security fix. {issue-number}

---

[//]: # (START/v1.2.0)
# v1.2.0

## Features
  * New Helm repo URL: https://1password.github.io/connect-helm-charts {#41}
  * Connect server updated to `v1.1.0` {#40}
  * Operator version updated to `v1.0.1` {#42}
  * CRD now lives in `crds/` dir, so they can be skipped with the `--skip-crds` flag {#36}
  * RBAC resources will be created by default when operator is enabled {#37}
  * `.Release.Namespace` is now watched by the operator by default {#32}

---

[//]: # (START/v1.1.0)
# v1.1.0

## Features
  * Connect's chart readme should now show up on [ArtifactHub](https://artifacthub.io/packages/helm/onepassword-connect/connect).
  * Helm's native  `.Release.Namespace` is now used for setting the Chart's namespace. {#13}
  * A [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) stanza can be used for the Connect and Operator pods.
  * Setting a token for the operator has been clarified in the readme. {#16}
  * Resources now follow [Helm's best practice](https://helm.sh/docs/chart_best_practices/labels/) for standard labels. {#11}

## Fixes
 * The fixed port value for the NodePort service has been removed to resolve conflicts with previously initialized services. Kubernetes will now automatically choose a free port. {#22}

## Security
 * Security Context was added to all containers to limit their default permissions. {#25}

---

[//]: # (START/v1.0.1)
# v1.0.1

## Features
  * Typo fixes for README
  * Update app name to Connect

---

[//]: # (START/v1.0.0)
# v1.0.0

## Features
  * Ability to deploy Connect via helm
  * Ability to deploy Kuberenetes operator via helm
  * Automate creation of secrets for connect credentials and operator token
  * Readme update
  * Updating to use latest Connect and Connect Operator versions

---

