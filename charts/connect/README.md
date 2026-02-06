# 1Password Connect

## Deploying 1Password Connect

Installing the Helm Chart with default configurations will deploy 1Password Connect in your default Namespace. However, Using 1Password Connect in Kubernetes requires that a 1password-credentials.json file be stored as a Kubernetes Secret. This credentials file can be saved as a Kubernetes secret by setting the file in your helm install command:

```bash
helm install connect 1password/connect --set-file connect.credentials=<path/to/1password-credentials.json>
```

More information about 1Password Connect and how to generate a 1password-credentials.json file can be found at <https://support.1password.com/secrets-automation/>.

# 1Password Connect Kubernetes Operator

## Deploying 1Password Connect Kubernetes Operator

In order to deploy the 1Password Connect Kubernetes Operator along side 1Password Connect `--set operator.create=true` in your install command.

Please note the following:

This operator expects that a secret containing an API token for 1Password Connect is saved to the configured namespace.
Creation of a secret for the token can be automated by the Helm Chart by using `--set operator.token.value=<token>`.

If you would prefer to create the token secret manually, the token can be saved as a Kubernetes secret using the following command:

```sh
kubectl create secret generic <token-name> --from-literal=token=<OP_CONNECT_TOKEN> --namespace=<namespace>
```

More information about 1Password Connect and how to generate a 1Password Connect API token can be found at <https://support.1password.com/secrets-automation/>.

To deploy the Kubernetes operator without also deploying 1Password Connect (for example, to deploy multiple operators on a single cluster), use `--set connect.create=false` in your install command.

## Configuration Values

The 1Password Connect Helm chart offers many configuration options for deployment. Please refer to the list below for information on what configuration options are available as well as what the default configuration options are.

[From the Official Helm Install Guide](https://helm.sh/docs/helm/helm_install/#helm-install):

> To override values in a chart, use either the '--values' flag and pass in a file or use the '--set' flag and pass configuration from the command line, to force a string value use '--set-string'. In case a value is large and therefore you want not to use neither '--values' nor '--set', use '--set-file' to read the single large value from file.

For example:

```sh
helm install -f myvalues.yaml connect ./connect
```

or

```sh
helm install --set connect.applicationName=connect connect ./connect
```
| operator.tls.trust.secret           | string     | `""`                   | The name of the secret containing the TLS certificate (tls.crt) used by the 1Password Connect API. This is used if that cert is a self-signed cert that needs to be trusted by the Operator.       |

#### Custom Environment Variables

Some containers support additional environment variables beyond those explicitly defined in the Helm chart. These can be defined using a key map for each custom variable. An example of adding custom variables to the connect container is shown below:

```yaml
connect:
  customEnvVars:
    - name: "CUSTOM_ENV_VAR1"
      value: "customvar2"
    - name: "CUSTOM_ENV_VAR2"
      value: "customvar2"
```

### CRD

By default, the chart will also install the `OnePasswordItem` CRD.
To disable this, you can run `helm install` with the [`--skip-crds` flag](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#method-1-let-helm-do-it-for-you).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| acceptanceTests.enabled | bool | `false` | Enable acceptance tests for the chart |
| acceptanceTests.fixtures | object | `{}` | Test fixtures configuration for acceptance tests |
| acceptanceTests.healthCheck.enabled | bool | `true` | Enable the health check test |
| acceptanceTests.healthCheck.image.repository | string | `"curlimages/curl"` | The image repository for the health check test container |
| acceptanceTests.healthCheck.image.tag | string | `"latest"` | The image tag for the health check test container |
| acceptanceTests.podSecurityContext | object | `{"fsGroup":65532,"runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod securityContext to be added to the acceptance test pods. |
| acceptanceTests.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container securityContext to be added to the acceptance test containers. |
| commonLabels | object | `{}` | Global common labels, applied to all resources |
| connect.affinity | object | `{}` | [Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) rules for the Connect pod |
| connect.annotations | object | `{}` | Additional annotations to be added to the Connect API deployment resource. |
| connect.api.httpPort | int | `8080` | The port the Connect API is served on when TLS is disabled |
| connect.api.httpsPort | int | `8443` | The port the Connect API is served on when TLS is enabled |
| connect.api.imageRepository | string | `"1password/connect-api"` | The 1Password Connect API repository |
| connect.api.logLevel | string | `"info"` | Log level of the Connect API container. Valid options are: trace, debug, info, warn, error. |
| connect.api.name | string | `"connect-api"` | The name of the 1Password Connect API container |
| connect.api.resources | object | `{"limits":{"memory":"128Mi"},"requests":{"cpu":0.2}}` | The resources requests/limits for the 1Password Connect API pod |
| connect.api.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container securityContext to be added to the Connect API containers. |
| connect.api.serviceMonitor.annotations | object | `{}` | Extra annotations for the ServiceMonitor |
| connect.api.serviceMonitor.enabled | bool | `false` | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator |
| connect.api.serviceMonitor.interval | string | `"30s"` | Specify the interval at which metrics should be scraped |
| connect.api.serviceMonitor.params | object | `{}` | Define the HTTP URL parameters used by ServiceMonitor |
| connect.api.serviceMonitor.path | string | `"/metrics"` | Define the path used by ServiceMonitor to scrape metrics |
| connect.applicationName | string | `"onepassword-connect"` | The name of 1Password Connect Application |
| connect.create | bool | `true` | Denotes whether the 1Password Connect server will be deployed |
| connect.credentials | string | `nil` | Contents of the 1password-credentials.json file for Connect. Can be set be adding `--set-file connect.credentials=<path/to/1password-credentials.json>` to your helm install command |
| connect.credentialsKey | string | `"1password-credentials.json"` | The key for the 1Password Connect Credentials stored in the credentials secret |
| connect.credentialsName | string | `"op-credentials"` | The name of Kubernetes Secret containing the 1Password Connect credentials |
| connect.credentials_base64 | string | `nil` | Base64-encoded contents of the 1password-credentials.json file for Connect. This can be used instead of `connect.credentials` in case supplying raw JSON to `connect.credentials` leads to issues. |
| connect.customEnvVars | list | `[]` | Custom Environment Variables for the 1Password Connect container. |
| connect.dataVolume.name | string | `"shared-data"` | The name of the shared volume used between 1Password Connect Containers |
| connect.dataVolume.type | string | `"emptyDir"` | The type of the shared volume used between 1Password Connect Containers |
| connect.dataVolume.values | object | `{}` | Describes the fields and values for configuration of shared volume for 1Password Connect |
| connect.host | string | `"onepassword-connect"` | The name of 1Password Connect Host |
| connect.hpa.annotations | object | `{}` | Additional annotations to be added to the HPA Connect |
| connect.hpa.avgCpuUtilization | int | `50` | Average CPU utilization percentage for the Connect pod |
| connect.hpa.avgMemoryUtilization | int | `50` | Average Memory utilization percentage for the Connect pod |
| connect.hpa.behavior | object | `{}` | Defines the Autoscaling Behavior in up/down directions |
| connect.hpa.enabled | bool | `false` | Enable Horizontal Pod Autoscaling for the Connect pod |
| connect.hpa.maxReplicas | int | `3` | Maximum number of replicas for the Connect pod |
| connect.hpa.minReplicas | int | `1` | Minimum number of replicas for the Connect pod |
| connect.imagePullPolicy | string | `"IfNotPresent"` | The 1Password Connect API image pull policy |
| connect.imagePullSecrets | list | `[]` | List of secret names to use as image pull secrets. Secrets must exist in the same namespace. |
| connect.ingress.annotations | object | `{}` | The 1Password Connect Ingress Annotations |
| connect.ingress.enabled | bool | `false` | The boolean value to enable/disable the 1Password Connect Ingress |
| connect.ingress.extraPaths | list | `[]` | Additional Ingress Paths |
| connect.ingress.ingressClassName | string | `""` | Optionally use ingressClassName instead of deprecated annotation. |
| connect.ingress.labels | object | `{}` | Ingress labels for 1Password Connect |
| connect.ingress.pathType | string | `"Prefix"` | Ingress PathType see [docs](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types) |
| connect.ingress.tls | list | `[]` | Ingress TLS see [docs](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) |
| connect.labels | object | `{}` | Additional labels to be added to the Connect API deployment resource. |
| connect.nodeSelector | object | `{}` | [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) stanza for the Connect pod |
| connect.pdb.annotations | object | `{}` | Additional annotations to be added to the PDB Connect |
| connect.pdb.enabled | bool | `false` | Enable Pod Disruption Budget for the Connect pod |
| connect.pdb.maxUnavailable | int | `1` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%) |
| connect.pdb.minAvailable | int | `0` | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| connect.podAnnotations | object | `{}` | Additional annotations to be added to the Connect API pods. |
| connect.podLabels | object | `{}` | Additional labels to be added to the Connect API pods. |
| connect.podSecurityContext | object | `{"fsGroup":999,"runAsGroup":999,"runAsNonRoot":true,"runAsUser":999,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod securityContext to be added to the Connect pods. |
| connect.priorityClassName | string | `""` | [priorityClassName](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/) to apply to the Connect API deployment resource. |
| connect.probes.liveness | bool | `true` | Denotes whether the 1Password Connect API will be continually checked by Kubernetes for liveness and restarted if the pod becomes unresponsive |
| connect.probes.readiness | bool | `true` | Denotes whether the 1Password Connect API readiness probe will operate and ensure the pod is ready before serving traffic |
| connect.profiler.enabled | bool | `false` | Enable the internal profiler to debug memory or performance issues. For normal operation this does not have to be enabled. |
| connect.profiler.interval | string | `"6h"` | The interval at which profiler snapshots are taken. |
| connect.profiler.keepLast | int | `12` | Number of profiler snapshots to keep. |
| connect.replicas | int | `1` | The number of replicas to run the 1Password Connect deployment |
| connect.serviceAccount.annotations | object | `{}` | Annotations for the 1Password Connect Service Account |
| connect.serviceAccount.create | bool | `false` | Create service account for the 1Password Connect deployment |
| connect.serviceAccount.name | string | `"onepassword-connect"` | The name of the 1Password Connect Service Account |
| connect.serviceAnnotations | object | `{}` | Additional annotations to be added to the service. |
| connect.serviceType | string | `"ClusterIP"` | The type of Service resource to create for the Connect API and sync services. |
| connect.sync.httpPort | int | `8081` | The port serving the health of the Sync container |
| connect.sync.imageRepository | string | `"1password/connect-sync"` | The 1Password Connect Sync repository |
| connect.sync.logLevel | string | `"info"` | Log level of the Connect Sync container. Valid options are: trace, debug, info, warn, error. |
| connect.sync.name | string | `"connect-sync"` | The name of the 1Password Connect Sync container |
| connect.sync.resources | object | `{}` | The resources requests/limits for the 1Password Connect Sync pod |
| connect.sync.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container securityContext to be added to the Connect Sync containers. |
| connect.tls.enabled | bool | `false` | Denotes whether the Connect API is secured with TLS |
| connect.tls.secret | string | `"op-connect-tls"` | The name of the secret containing the TLS key (`tls.key`) and certificate (`tls.crt`) |
| connect.tolerations | list | `[]` | List of tolerations to be added to the Connect API pods. |
| connect.version | string | `"{{ .Chart.AppVersion }}"` | The 1Password Connect version to pull |
| operator.affinity | object | `{}` | [Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) rules for the Operator pod |
| operator.allowEmptyValues | bool | `false` | Passes the `--allow-empty-values` flag to the Operator container that allows adding fields with empty values to Kubernetes secrets when true |
| operator.annotations | object | `{}` | Additional annotations to be added to the Operator deployment resource. |
| operator.applicationName | string | `"onepassword-connect-operator"` | The name of 1Password Operator Application |
| operator.authMethod | string | `"connect"` | Authentication method for the Operator. Valid values: `connect` (uses Connect token) or `service-account` (uses 1Password Service Account token) |
| operator.autoRestart | bool | `false` | Denotes whether the 1Password Operator will automatically restart deployments based on associated updated secrets. |
| operator.clusterRole.create | string | `"{{ .Values.operator.create }}"` | Denotes whether or not a cluster role will be created for each for the 1Password Operator |
| operator.clusterRole.name | string | `"onepassword-connect-operator"` | The name of the 1Password Operator Cluster Role |
| operator.clusterRoleBinding.create | string | `"{{ .Values.operator.create }}"` | Denotes whether or not a Cluster role binding will be created for the 1Password Operator Service Account |
| operator.clusterRoleBinding.name | string | `"onepassword-connect-operator"` | The name of the 1Password Operator Cluster Role Binding |
| operator.create | bool | `false` | Denotes whether the 1Password Operator will be deployed |
| operator.customEnvVars | list | `[]` | Custom environment variables for the 1Password Operator container. |
| operator.enableAnnotations | bool | `false` | Passes the `--enable-annotations` flag to the Operator container when true. |
| operator.hpa.annotations | object | `{}` | Additional annotations to be added to the HPA Operator |
| operator.hpa.avgCpuUtilization | int | `50` | Average CPU utilization percentage for the Operator pod |
| operator.hpa.avgMemoryUtilization | int | `50` | Average Memory utilization percentage for the Operator pod |
| operator.hpa.behavior | object | `{}` | Defines the Autoscaling Behavior in up/down directions |
| operator.hpa.enabled | bool | `false` | Enable Horizontal Pod Autoscaling for the Operator pod |
| operator.hpa.maxReplicas | int | `3` | Maximum number of replicas for the Operator pod |
| operator.hpa.minReplicas | int | `1` | Minimum number of replicas for the Operator pod |
| operator.imagePullPolicy | string | `"IfNotPresent"` | The 1Password Operator image pull policy |
| operator.imagePullSecrets | list | `[]` | List of secret names to use as image pull secrets. Secrets must exist in the same namespace. |
| operator.imageRepository | string | `"1password/onepassword-operator"` | The 1Password Operator repository |
| operator.labels | object | `{}` | Additional labels to be added to the Operator deployment resource. |
| operator.logLevel | string | `"info"` | Log level of the Operator container. Valid options are: debug, info and error. |
| operator.nodeSelector | object | `{}` | [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) stanza for the operator pod |
| operator.pdb.annotations | object | `{}` | Additional annotations to be added to the PDB Operator |
| operator.pdb.enabled | bool | `false` | Enable Pod Disruption Budget for the Operator pod |
| operator.pdb.maxUnavailable | int | `1` | Number of pods that are unavailable after eviction as number or percentage (eg.: 50%) |
| operator.pdb.minAvailable | int | `0` | Number of pods that are available after eviction as number or percentage (eg.: 50%) |
| operator.podAnnotations | object | `{}` | Additional annotations to be added to the Operator pods. |
| operator.podLabels | object | `{}` | Additional labels to be added to the Operator pods. |
| operator.podSecurityContext | object | `{"fsGroup":65532,"runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod securityContext to be added to the Operator pods. |
| operator.pollingInterval | int | `600` | How often the 1Password Operator will poll for secrets updates. |
| operator.priorityClassName | string | `""` | [priorityClassName](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/) to apply to the Operator pods. |
| operator.replicas | int | `1` | The number of replicas to run the 1Password Operator deployment |
| operator.resources | object | `{}` | The resources requests/limits for the 1Password Operator pod |
| operator.roleBinding.create | string | `"{{ .Values.operator.create }}"` | Denotes whether or not a role binding will be created for each Namespace for the 1Password Operator Service Account |
| operator.roleBinding.name | string | `"onepassword-connect-operator"` | The name of the 1Password Operator Role Binding |
| operator.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container securityContext to be added to the 1Password Operator containers. |
| operator.serviceAccount.annotations | object | `{}` | Annotations for the 1Password Connect Service Account |
| operator.serviceAccount.create | string | `"{{ .Values.operator.create }}"` | Denotes whether or not a service account will be created for the 1Password Operator |
| operator.serviceAccount.name | string | `"onepassword-connect-operator"` | The name of the 1Password Connect Operator Service Account |
| operator.serviceAccountToken.key | string | `"token"` | The key for the 1Password Service Account token stored in the 1Password token secret |
| operator.serviceAccountToken.name | string | `"onepassword-service-account-token"` | The name of Kubernetes Secret containing the 1Password Service Account token |
| operator.serviceAccountToken.value | string | `nil` | Generated 1Password Service Account token to be used by the 1Password Operator |
| operator.token.key | string | `"token"` | The key for the 1Password Connect token stored in the 1Password token secret |
| operator.token.name | string | `"onepassword-token"` | The name of Kubernetes Secret containing the 1Password Connect API token |
| operator.token.value | string | `nil` | An API token generated for 1Password Connect to be used by the 1Password Operator |
| operator.tolerations | list | `[]` | List of tolerations to be added to the Operator pods. |
| operator.version | string | `"1.10.1"` | The 1Password Operator version to pull |
| operator.watchNamespace | list | `[]` | A list of namespaces for the 1Password Operator to watch and manage. Use the empty list to watch all namespaces. |
