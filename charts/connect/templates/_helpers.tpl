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
{{- if .Values.commonLabels }}
{{ toYaml .Values.commonLabels }}
{{- end }}
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

{{- define "onepassword-connect.apiPort" -}}
{{- if .Values.connect.tls.enabled -}}
{{ .Values.connect.api.httpsPort  }}
{{- else -}}
{{ .Values.connect.api.httpPort  }}
{{- end }}
{{- end }}

{{- define "onepassword-connect.url" -}}
{{- if .Values.connect.tls.enabled -}}
https://{{ .Values.connect.host }}:{{ .Values.connect.api.httpsPort  }}
{{- else -}}
http://{{ .Values.connect.host }}:{{ .Values.connect.api.httpPort  }}
{{- end }}
{{- end }}

{{/*
loadBalancer configuration for the the 1Password API and Sync service.
Supported inputs are Values.connect
*/}}
{{- define "service.loadBalancer" -}}
{{- if  eq (.serviceType | toString) "LoadBalancer" }}
{{- if .loadBalancerIP }}
  loadBalancerIP: {{ .loadBalancerIP }}
{{- end }}
{{- with .loadBalancerSourceRanges }}
  loadBalancerSourceRanges:
{{- range . }}
  - {{ . }}
{{- end }}
{{- end -}}
{{- end }}
{{- end -}}

{{/*
Sets extra ingress annotations
*/}}
{{- define "onepassword-connect.ingress.annotations" -}}
  {{- if .Values.connect.ingress.annotations }}
  annotations:
    {{- $tp := typeOf .Values.connect.ingress.annotations }}
    {{- if eq $tp "string" }}
      {{- tpl .Values.connect.ingress.annotations . | nindent 4 }}
    {{- else }}
      {{- toYaml .Values.connect.ingress.annotations | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Sets extra service annotations
*/}}
{{- define "onepassword-connect.serviceAnnotations" -}}
  {{- if .Values.connect.serviceAnnotations }}
  annotations:
    {{- $tp := typeOf .Values.connect.serviceAnnotations }}
    {{- if eq $tp "string" }}
      {{- tpl .Values.connect.serviceAnnotations . | nindent 4 }}
    {{- else }}
      {{- toYaml .Values.connect.serviceAnnotations | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Sets environment variables when profiler is enabled
*/}}
{{- define "onepassword-connect.profilerConfig" -}}
  {{- if .Values.connect.profiler.enabled}}
- name: OP_PROFILER_OUTPUT_DIR
  value: "/home/opuser/.op/data/profiler"
- name: OP_PROFILER_INTERVAL
  value: "{{ .Values.connect.profiler.interval }}"
- name: OP_PROFILER_KEEP_LAST
  value: "{{ .Values.connect.profiler.keepLast }}"
  {{- end -}}
{{- end -}}
