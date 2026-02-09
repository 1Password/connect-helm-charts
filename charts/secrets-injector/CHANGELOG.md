[//]: # (START/LATEST)
# Latest

## Features
* A user-friendly description of a new feature. {issue-number}

## Fixes
* A user-friendly description of a fix. {issue-number}

## Security
* A user-friendly description of a security fix. {issue-number}

[//]: # (START/v1.2.0)
# v1.2.0

# Fixes
* Secrets Injector Helm chart adds nodeSelector, labels, annotations, podLabels, podAnnotations, and tolerations to the deployment. (#175)
* Removes hook annotations from Secrets Injector deployment and service. (#150, #184)

[//]: # (START/v1.1.0)
# v1.1.0

## Features
* Custom Environment Variable Support. {#152}
* Add a way to set imagePullSecrets to deployments. Credits to @luflow for the contribution. {#203}

---

[//]: # (START/v1.0.1)
# v1.0.1

This release updates the secrets-injector image to v1.0.2 with brings in several fixes.

## Fixes
* Injector no longer overwrites pod volumeMounts. {[#22](https://github.com/1Password/kubernetes-secrets-injector/issues/22)}
* Fixed bug causing the need for the mutatingwebhookconfig object to be deleted every time the application restarts. {[#32](https://github.com/1Password/kubernetes-secrets-injector/issues/32)}

---

[//]: # (START/v1.0.0)
# v1.0.0

## Features
* Ability to deploy 1Password Secrets Injector via Helm.
* Inject secrets as environment variables to the pod.

---

