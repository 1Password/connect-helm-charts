# 1Password Kubernetes Secrets Injector Helm chart
Installing the Helm Chart with default configurations will deploy 1Password Kubernetes Secrets Injector in your default Namespace.

Kubernetes Secrets Injector can fetch 1Password items using either Connect or Service Accounts. If both are configured Connect takes preference.

__Note__: As you can use Kubernetes Secrets Injector either with Connect or Service Accounts, you may not need to configure them both.


## Installation
```
helm install --generate-name kubernetes-Secrets-injector
```

## Usage
Please follow [Kubernetes Secrets Injector documentation](https://github.com/1Password/kubernetes-secrets-injector#1password-secrets-injector-for-kubernetes)


## Configuration Values
The 1Password Kubernetes Secrets Injector Helm chart offers many configuration options for deployment. Please refer to the list below for information on what configuration options are available as well as what the default configuration options are.

[From the Official Helm Install Guide](https://helm.sh/docs/helm/helm_install/#helm-install):

>To override values in a chart, use either the '--values' flag and pass in a file or use the '--set' flag and pass configuration from the command line, to force a string value use '--set-string'. In case a value is large and therefore you want not to use neither '--values' nor '--set', use '--set-file' to read the single large value from file.

For example: 
```bash
$ helm install -f myvalues.yaml injector ./kubernetes-secrets-injector
```

or 

```bash
$ helm install --set injector.applicationName=injector injector ./kubernetes-secrets-injector
```

### Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| injector.applicationName | string | `"secrets-injector"` | The name of 1Password Kubernetes Secrets Injector Application |
| injector.port | string | `443` | The port the Secrets Injector exposes |
| injector.targetPort | integer | `8443` | The port the Secrets Injector API sends requests to the pod |
| injector.targetPort | integer | `8443` | The port the Secrets Injector API sends requests to the pod |
| injector.imageRepository | string | `"1password/kubernetes-secrets-injector"` | The 1Password Secrets Injector docker image repository |
| injector.imagePullPolicy | string | `"IfNotPresent"` | The 1Password Secrets Injector docker image policy. `"IfNotPresent"` means the image is pulled only if it is not already present locally. |
