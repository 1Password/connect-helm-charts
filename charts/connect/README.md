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

### Values

| Key                                 | Type       | Default                            | Description                                                                                                                                                                                        |
|-------------------------------------|------------|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| connect.create                      | boolean    | `true`                             | Denotes whether the 1Password Connect server will be deployed                                                                                                                                      |
| connect.replicas                    | integer    | `1`                                | The number of replicas to run the 1Password Connect deployment                                                                                                                                     |
| connect.applicationName             | string     | `"onepassword-connect"`            | The name of 1Password Connect Application                                                                                                                                                          |
| connect.host                        | string     | `"onepassword-connect"`            | The name of 1Password Connect Host                                                                                                                                                                 |
| connect.api.imageRepository         | string     | `"1password/connect-api`           | The 1Password Connect API repository                                                                                                                                                               |
| connect.api.name                    | string     | `"connect-api"`                    | The name of the 1Password Connect API container                                                                                                                                                    |
| connect.api.resources               | object     | `{}`                               | The resources requests/limits for the 1Password Connect API pod                                                                                                                                    |
| connect.api.httpPort                | integer    | `8080`                             | The port the Connect API is served on when TLS is disabled                                                                                                                                         |
| connect.api.httpsPort               | integer    | `8443`                             | The port the Connect API is served on when TLS is enabled                                                                                                                                          |
| connect.api.logLevel                | string     | `info`                             | Log level of the Connect API container. Valid options are: trace, debug, info, warn, error.                                                                                                        |
| connect.credentials                 | jsonString |                                    | Contents of the 1password-credentials.json file for Connect. Can be set be adding `--set-file connect.credentials=<path/to/1password-credentials.json>` to your helm install command               |
| connect.credentials_base64          | string     |                                    | Base64-encoded contents of the 1password-credentials.json file for Connect. This can be used instead of `connect.credentials` in case supplying raw JSON to `connect.credentials` leads to issues. |
| connect.credentialsKey              | string     | `"1password-credentials.json"`     | The key for the 1Password Connect Credentials stored in the credentials secret, the credentials must be encoded as a base64 string                                                                 |
| connect.credentialsName             | string     | `"op-credentials"`                 | The name of Kubernetes Secret containing the 1Password Connect credentials                                                                                                                         |
| connect.dataVolume.name             | string     | `"shared-data"`                    | The name of the shared volume used between 1Password Connect Containers                                                                                                                            |
| connect.dataVolume.type             | string     | `"emptyDir"`                       | The type of the shared volume used between 1Password Connect Containers                                                                                                                            |
| connect.dataVolume.values           | object     | `{}`                               | Desribes the fields and values for configuration of shared volume for 1Password Connect                                                                                                            |
| connect.imagePullPolicy             | string     | `"IfNotPresent"`                   | The 1Password Connect API image pull policy                                                                                                                                                        |
| connect.ingress.annotations         | object     | `{}`                               | The 1Password Connect Ingress Annotations                                                                                                                                                          |
| connect.ingress.enabled             | bool       | `false`                            | The boolean value to enable/disable the 1Password Connect                                                                                                                                          |
| connect.ingress.extraPaths          | list       | `[]`                               | Additional Ingress Paths                                                                                                                                                                           |
| connect.ingress.hosts[0].host       | string     | `"chart-example.local"`            | The 1Password Connect Ingress Hostname                                                                                                                                                             |
| connect.ingress.hosts[0].paths      | list       | `[]`                               | The 1Password Connect Ingress Path                                                                                                                                                                 |
| connect.ingress.ingressClassName    | string     | `""`                               | Optionally use ingressClassName instead of deprecated annotation.                                                                                                                                  |
| connect.ingress.labels              | object     | `{}`                               | Ingress labels for 1Password Connect                                                                                                                                                               |
| connect.ingress.pathType            | string     | `"Prefix"`                         | Ingress PathType see [docs](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)                                                                                           |
| connect.ingress.tls                 | list       | `[]`                               | Ingress TLS see [docs](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls)                                                                                                       |
| connect.nodeSelector                | object     | `{}`                               | [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) stanza for the Connect pod                                                                  |
| connect.probes.readiness            | boolean    | `true`                             | Denotes whether the 1Password Connect API readiness probe will operate and ensure the pod is ready before serving traffic                                                                          |
| connect.probes.liveness             | boolean    | `true`                             | Denotes whether the 1Password Connect API will be continually checked by Kubernetes for liveness and restarted if the pod becomes unresponsive                                                     |
| connect.annotations                 | object     | `{}`                               | Additional annotations to be added to the Connect API deployment resource.                                                                                                                         |
| connect.labels                      | object     | `{}`                               | Additional labels to be added to the Connect API deployment resource.                                                                                                                              |
| connect.podAnnotations              | object     | `{}`                               | Additional annotations to be added to the Connect API pods.                                                                                                                                        |
| connect.podLabels                   | object     | `{}`                               | Additional labels to be added to the Connect API pods.                                                                                                                                             |
| connect.serviceType                 | string     | `NodePort`                         | The type of Service resource to create for the Connect API and sync services.                                                                                                                      |
| connect.serviceAnnotations          | object     | `{}`                               | Additional annotations to be added to the service.                                                                                                                                                 |
| connect.sync.imageRepository        | string     | `"1password/connect-sync"`         | The 1Password Connect Sync repository                                                                                                                                                              |
| connect.sync.name                   | string     | `"connect-sync"`                   | The name of the 1Password Connect Sync container                                                                                                                                                   |
| connect.sync.resources              | object     | `{}`                               | The resources requests/limits for the 1Password Connect Sync pod                                                                                                                                   |
| connect.sync.httpPort               | integer    | `8081`                             | The port serving the health of the Sync container                                                                                                                                                  |
| connect.sync.logLevel               | string     | `info`                             | Log level of the Connect Sync container. Valid options are: trace, debug, info, warn, error.                                                                                                       |
| connect.tls.enabled                 | boolean    | `false`                            | Denotes whether the Connect API is secured with TLS                                                                                                                                                |
| connect.tls.secret                  | string     | `"op-connect-tls"`                 | The name of the secret containing the TLS key (`tls.key`) and certificate (`tls.crt`)                                                                                                              |
| connect.tolerations                 | list       | `[]`                               | List of tolerations to be added to the Connect API pods.                                                                                                                                           |
| connect.customEnvVars               | array      | `[]`                               | Custom Environment Variables for the 1Password Connect container.                                                                                                                                  |
| connect.version                     | string     | `{{.Chart.AppVersion}}`            | The 1Password Connect version to pull                                                                                                                                                              |
| operator.autoRestart                | boolean    | `false`                            | Denotes whether the 1Password Operator will automatically restart deployments based on associated updated secrets.                                                                                 |
| operator.create                     | boolean    | `false`                            | Denotes whether the 1Password Operator will be deployed                                                                                                                                            |
| operator.imagePullPolicy            | string     | `"IfNotPresent"`                   | The 1Password Operator image pull policy                                                                                                                                                           |
| operator.imageRepository            | string     | `"1password/onepassword-operator"` | The 1Password Operator repository                                                                                                                                                                  |
| operator.nodeSelector               | object     | `{}`                               | [Node selector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) stanza for the operator pod                                                                 |
| operator.annotations                | object     | `{}`                               | Additional annotations to be added to the Operator deployment resource.                                                                                                                            |
| operator.labels                     | object     | `{}`                               | Additional labels to be added to the Operator deployment resource.                                                                                                                                 |
| operator.logLevel                   | string     | `info`                             | Log level of the Operator container. Valid options are: debug, info and error.                                                                                                                     |
| operator.podAnnotations             | object     | `{}`                               | Additional annotations to be added to the Operator pods.                                                                                                                                           |
| operator.podLabels                  | object     | `{}`                               | Additional labels to be added to the Operator pods.                                                                                                                                                |
| operator.pollingInterval            | integer    | `600`                              | How often the 1Password Operator will poll for secrets updates.                                                                                                                                    |
| operator.clusterRole.create         | boolean    | `{{.Values.operator.create}}`      | Denotes whether or not a cluster role will be created for each for the 1Password Operator                                                                                                          |
| operator.clusterRole.name           | string     | `"onepassword-connect-operator"`   | The name of the 1Password Operator Cluster Role                                                                                                                                                    |
| operator.clusterRoleBinding.create  | boolean    | `{{.Values.operator.create}}`      | Denotes whether or not a Cluster role binding will be created for the 1Password Operator Service Account                                                                                           |
| operator.roleBinding.create         | boolean    | `{{.Values.operator.create}}`      | Denotes whether or not a role binding will be created for each Namespace for the 1Password Operator Service Account                                                                                |
| operator.roleBinding.name           | string     | `"onepassword-connect-operator"`   | The name of the 1Password Operator Role Binding                                                                                                                                                    |
| operator.serviceAccount.annotations | object     | `{}`                               | Annotations for the 1Password Connect Service Account                                                                                                                                              |
| operator.serviceAccount.create      | boolean    | `{{.Values.operator.create}}`      | Denotes whether or not a service account will be created for the 1Password Operator                                                                                                                |
| operator.serviceAccount.name        | string     | `"onepassword-connect-operator"`   | The name of the 1Password Connect Operator                                                                                                                                                         |
| operator.tolerations                | list       | `[]`                               | List of tolerations to be added to the Operator pods.                                                                                                                                              |
| operator.version                    | string     | `"1.8.1"`                          | T 1Password Operator version to pull                                                                                                                                                               |
| operator.token.key                  | string     | `"token"`                          | The key for the 1Password Connect token stored in the 1Password token secret                                                                                                                       |
| operator.token.name                 | string     | `"onepassword-token"`              | The name of Kubernetes Secret containing the 1Password Connect API token                                                                                                                           |
| operator.token.value                | string     | `"onepassword-token"`              | An API token generated for 1Password Connect to be used by the Connect Operator                                                                                                                    |
| operator.watchNamespace             | list       | `[]`                               | A list of namespaces for the 1Password Operator to watch and manage. Use the empty list to watch all namespaces.                                                                                   |
| operator.resources                  | object     | `{}`                               | The resources requests/limits for the 1Password Operator pod                                                                                                                                       |
| operator.customEnvVars              | array      | `[]`                               | Custom environment variables for the 1Password Operator container that are not specified in this helm chart.                                                                                       |

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
