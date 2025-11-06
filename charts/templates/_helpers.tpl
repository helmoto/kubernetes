{{/*
名称
*/}}
{{- define "deploy.name" -}}
	{{- default .Chart.Name .Values.application.name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
全称
*/}}
{{- define "deploy.fullName" -}}
	{{- if .Values.application.fullNameOverride }}
		{{- .Values.application.fullNameOverride | trunc 63 | trimSuffix "-" }}
	{{- else }}
		{{- $name := default .Chart.Name .Values.application.name }}
		{{- if contains $name .Release.Name }}
			{{- .Release.Name | trunc 63 | trimSuffix "-" }}
		{{- else }}
			{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
		{{- end }}
	{{- end }}
{{- end }}


{{/*
版本
*/}}
{{- define "deploy.chart" -}}
	{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
通用标签
*/}}
{{- define "deploy.labels" -}}
	helm.sh/chart: {{ include "deploy.chart" . }}
	{{ include "deploy.selectorLabels" . }}
	{{- if .Chart.AppVersion }}
		app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
	{{- end }}
	app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
选择器标签
*/}}
{{- define "deploy.selectorLabels" -}}
	app.kubernetes.io/name: {{ include "deploy.name" . }}
	app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
账号
*/}}
{{- define "deploy.serviceAccountName" -}}
	{{- if .Values.serviceAccount.create }}
		{{- default (include "deploy.fullName" .) .Values.serviceAccount.name }}
	{{- else }}
		{{- default "default" .Values.serviceAccount.name }}
	{{- end }}
{{- end }}