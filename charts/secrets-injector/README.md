# 1Password Kubernetes Secrets Injector Helm chart

## Installation

Installing the Helm Chart with default configurations will deploy 1Password Kubernetes Secrets Injector in your default Namespace.

```
helm install --generate-name 1password/secrets-injector
```

## Configuration Values

The 1Password Kubernetes Secrets Injector Helm chart offers many configuration options for deployment. Please refer to the list below for information on what configuration options are available as well as what the default configuration options are.

[From the Official Helm Install Guide](https://helm.sh/docs/helm/helm_install/#helm-install):

> To override values in a chart, use either the '--values' flag and pass in a file or use the '--set' flag and pass configuration from the command line, to force a string value use '--set-string'. In case a value is large and therefore you want not to use neither '--values' nor '--set', use '--set-file' to read the single large value from file.

For example:

```bash
$ helm install -f myvalues.yaml injector ./secrets-injector
```

or

```bash
$ helm install --set injector.applicationName=injector injector ./secrets-injector
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| injector.annotations | object | `{}` | Additional annotations to be added to the Secrets Injector deployment resource. |
| injector.applicationName | string | `"secrets-injector"` | The name of 1Password Kubernetes Secrets Injector Application |
| injector.customEnvVars | list | `[]` | Custom Environment Variables for the 1Password Secrets Injector container that are not specified in this helm chart. |
| injector.imagePullPolicy | string | `"IfNotPresent"` | The 1Password Secrets Injector docker image policy. |
| injector.imagePullSecrets | list | `[]` | Global list of secret names to use as image pull secrets for all pod specs in the chart. Secrets must exist in the same namespace |
| injector.imageRepository | string | `"1password/kubernetes-secrets-injector"` | The 1Password Secrets Injector docker image repository |
| injector.labels | object | `{}` | Additional labels to be added to the Secrets Injector deployment resource. |
| injector.nodeSelector | object | `{}` | [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) stanza for the Secrets Injector pod |
| injector.podAnnotations | object | `{}` | Additional annotations to be added to the Secrets Injector pod. |
| injector.podLabels | object | `{}` | Additional labels to be added to the Secrets Injector pod. |
| injector.podSecurityContext | object | `{"fsGroup":65532,"runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod `securityContext` for the 1Password Secrets Injector pod. |
| injector.port | int | `443` | The port the Secrets Injector exposes |
| injector.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container `securityContext` for the 1Password Secrets Injector container. |
| injector.targetPort | int | `8443` | The port the Secrets Injector API sends requests to the pod |
| injector.tolerations | list | `[]` | List of tolerations to be added to the Secrets Injector pod. |
| injector.version | string | `"{{ .Chart.AppVersion }}"` | The 1Password Secrets Injector version to pull. |

#### Custom Environment Variables

The injector container supports additional environment variables beyond those explicitly defined in the Helm chart. These can be defined using a key map for each custom variable. An example is shown below:

```yaml
injector:
  customEnvVars:
    - name: "CUSTOM_ENV_VAR1"
      value: "customvar2"
    - name: "CUSTOM_ENV_VAR2"
      value: "customvar2"
```
