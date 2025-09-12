[//]: # (START/LATEST)
# Latest

## Features
* A user-friendly description of a new feature. {issue-number}

## Fixes
* A user-friendly description of a fix. {issue-number}

## Security
* A user-friendly description of a security fix. {issue-number}

[//]: # (START/v2.0.5)
# v2.0.5

## Features
* Bump Connect version to v1.8.1

[//]: # (START/v2.0.4)
# v2.0.4

## Features
* Bump Connect version to v1.8.0

[//]: # (START/v2.0.3)
# v2.0.3

## Fixes
* Allow disabling healthCheck test and allow specifying image used in that test. (#241)

[//]: # (START/v2.0.2)
# v2.0.2

## Fixes
* Updated Operator version to include fix for panic when handling 1Password items with files ([onepassword-operator#209](https://github.com/1Password/onepassword-operator/issues/209)).


[//]: # (START/v2.0.1)
# v2.0.1

## Fixes
* Add `authMethod` value to set the authentication method used by the 1Password Operator to access 1Password secrets. (#231)

[//]: # (START/v2.0.0)
# v2.0.0

## Breaking changes
* Default Connect service type changed to ClusterIP. (#194)

Previously, the Connect service was exposed externally by default using `NodePort`. In this release, the default service type has been changed to `ClusterIP`, meaning Connect is now only accessible from within the cluster unless explicitly configured otherwise.
While exposing Connect via `NodePort` is not inherently insecure—since Connect requires a valid bearer token for all API access—this change aligns with the principle of least privilege and reduces unnecessary external surface area by default.
If you require external access to Connect, you can still set `connect.serviceType` to `NodePort` or `LoadBalancer` in your Helm values.

## Features
* Add support for configuring the operator to use a 1Password Service Account. {#226}

[//]: # (START/v1.17.1)
# v1.17.1

## Fixes
* Apply ServiceMonitor rules conditionally by providing value. Credits to @estenrye for the contribution. (#224)

[//]: # (START/v1.17.0)
# v1.17.0

## Features
* Add resources defaults to limit connect API's resource consumption. (#209, #211)

## Fixes
* Fix `podDisruptionBudget` labels. Credits to @mmorejon for the contribution. (#213)

[//]: # (START/v1.16.0)
# v1.16.0

## Features
* Add ability to set Priority Class Name. Credits to @jonas-zipprick for the contribution. {#201}
* Add a way to set imagePullSecrets to deployments. Credits to @luflow for the contribution. {#203}
* Add HPA, PDB and Pod Affinity for both Operator and Connect components. Credits to @dapama for the contribution. {#170}

---

[//]: # (START/v1.15.1)
# v1.15.1

## Features
* Bump Connect version to v1.7.3

---

[//]: # (START/v1.15.0)
# v1.15.0

## Features
* Proxy Support or custom env. {#152}
* Bump operator to v1.8.1

---

[//]: # (START/v1.14.0)
# v1.14.0

## Features
* The default Operator version is updated to v1.8.0. Credits to @mmorejon for the contribution. {#168}
* The default Connect version is updated to v1.7.2.

---

[//]: # (START/v1.13.0)
# v1.13.0

## Features
* Upgraded to default to version 1.7.1 of the Operator. {#164}
* The Connect helm char now supports the ability to set the logging level on the Operator. {#164}

---

[//]: # (START/v1.12.1)
# v1.12.1

## Fixes
* Distinct standalone operator Helm deployments use the same lock. {#148}

---

[//]: # (START/v1.12.0)
# v1.12.0

## Features
* Connect's log level can now be specified using connect.api.loglevel and connect.sync.logLevel. {#135}
* The default Connect version is updated to v1.7.1.
* Connect's profiler can now be enabled through the Helm chart to help 1Password debug memory and performance issues. {#157} 

## Fixes
* Ingress now correctly works if TLS is enabled. {#140}
* The operators's polling interval is now consistent with the readme's. {#147}
* The readme now correctly mentions the Connect's credential file must be base64-encoded. {#155}

Thanks @antham, @akohlmann, @Altiire, @JoshCooley-alto for your contributions.

---

[//]: # (START/v1.11.0)
# v1.11.0

## Features
* Extra service annotations can now be specified with `connect.serviceAnnotations`. {#106}
* `connect.create` can now be used to control whether a Connect instance should be created. {#125}
* The default Connect version is updated to v1.7.0.

## Fixes
* The default value of `connect.CredentialsKey` is now correctly documented. {#136}

Thanks @twink0r, @lapwat, @leehanel, @Matthiasvanderhallen for your contributions.

---

[//]: # (START/v1.10.0)
# v1.10.0

## Features
* Add replicas definition to the Connect Deployment {#121, #128}
* Use the latest 1password/operator version 1.6.0 {#128}

## Fixes
* Use '1Password Operator' term instead of '1Password Connect Operator' in the documentation {#128}

---

[//]: # (START/v1.9.0)
# v1.9.0

## Features
* Enable a better interaction with 1Password Connect and Sync applications deployed. Credits to @klaus385 for contributing to this enhancement. {#107}

## Fixes
* Updated Connect to v1.5.7, which addresses some bugs and security enahncements.

---

[//]: # (START/v1.8.1)
# v1.8.1

## Fixes
* Updated Connect to v1.5.6, which addresses some bugs.

---

[//]: # (START/v1.8.0)
# v.1.8.0

## Features
* Updated Kubernetes Operator to v1.5.0, which adds the `type` and `status` for the `OnePasswordItem` CRD. {#101}
* Updated OnePasswordItem CRD to enable the new functionality added in the latest version of the Kubernetes Operator. Credits to @tomjohnburton for contributing to this enhancement. {#92, #102}

## Fixes
* Updated Connect to v1.5.4, which resolves some bugs. {#101}

---

[//]: # (START/v1.7.1)
# v1.7.1

## Fixes
* Updated Connect to v1.5.1, which resolves several synchronization related issues.

---

[//]: # (START/v1.7.0)
# v1.7.0

## Features
* Connect can now run with fully unprivileged containers. {#21,#22}
* Tolerations can now be configured with `connect.tolerations` and `operator.tolerations`. {#63}
* Resource type for the Connect Service is now configurable. {#65}
* Updated Connect to v1.5.0. {#81}
* Base64-encoded credentials can be supplied through `connect.credentials_base64` if passing raw JSON through `connect.credentials` leads to issues. {#67}

## Fixes
* Resources are now correctly passed to the Connect API container. {#79}

---

[//]: # (START/v1.6.0)
# v1.6.0

## Features
* Add `app.kubernetes.io/component` labels for Connect and Operator. {#70}

---

[//]: # (START/v1.5.0)
# v1.5.0

## Features
* Add clusterrolebinding compatibility and watch all namespaces by default. {#62}

---

[//]: # (START/v1.4.0)
# v1.4.0

## Features
* API and Sync containers now have liveness and readiness probes. {#47}
* The Connect API can now be configured to use TLS with a custom certificate.

---

[//]: # (START/v1.3.0)
# v1.3.0

## Features
  * Connect server updated to `v1.2.0` {#49}
  * Resource limits can now be set on the operator {#52}
  * Additional labels & annotations are set for deployments {#51}

## Security
  * Follow principle of least privilege for operator permissions {#55}

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

