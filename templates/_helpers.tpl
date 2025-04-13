{{/*
Expand the name of the chart.
*/}}
{{- define "customers.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "customers.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "customers.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "customers.labels" -}}
helm.sh/chart: {{ include "customers.chart" . }}
app.openshift.io/runtime: quarkus
{{ include "customers.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "customers.selectorLabels" -}}
app.kubernetes.io/name: {{ include "customers.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "customers.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "customers.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "customers.image" -}}
{{- if eq .Values.image.registry "Quay" }}
{{- printf "%s/%s/%s:%s" .Values.image.host .Values.image.organization .Values.image.name .Values.image.tag -}}
{{- else }}
{{- printf "%s/%s/%s:latest" .Values.image.host .Values.namespace.name .Values.image.name -}}
{{- end }}
{{- end }}






{{/*
Expand the name of the chart.
*/}}
{{- define "customers-db.name" -}}
{{- default .Chart.Name .Values.db.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "customers-db.fullname" -}}
{{- if .Values.db.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.db.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "customers-db.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "customers-db.labels" -}}
helm.sh/chart: {{ include "customers-db.chart" . }}
app.openshift.io/runtime: postgresql
{{ include "customers-db.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "customers-db.selectorLabels" -}}
app.kubernetes.io/name: {{ include "customers-db.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "customers-db.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "customers-db.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/* 
Admin password
*/}}
{{- define "customers-db.admin-password" -}}
{{- $secretName := (include "customers-db.name" .) }}
{{- $secretObj := (lookup "v1" "Secret" .Release.Namespace $secretName) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $adminSecret := (get $secretData "database-admin-password") | default (randAlpha 12 | b64enc) }}
{{- $adminSecret | quote }}
{{- end }}