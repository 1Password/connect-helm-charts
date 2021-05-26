{{/*
Expand the name of the chart.
*/}}
{{- define "onepassword-connect.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "onepassword-connect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "onepassword-connect.labels" -}}
helm.sh/chart: {{ include "onepassword-connect.chart" . }}
{{ include "onepassword-connect.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "onepassword-connect.selectorLabels" -}}
app.kubernetes.io/name: {{ include "onepassword-connect.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "helm-toolkit.utils.joinListWithComma" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{- define "onepassword-connect.url" -}}
{{- if .Values.connect.tls.enabled }}
https://{{ .Values.connect.applicationName }}:{{ .Values.connect.api.httpsPort  }}
{{- else }}
http://{{ .Values.connect.applicationName }}:{{ .Values.connect.api.httpPort  }}
{{- end }}
{{- end }}
