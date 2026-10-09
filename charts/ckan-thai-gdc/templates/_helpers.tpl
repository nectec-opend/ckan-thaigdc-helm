{{- define "ckan.agent" -}}
{{- $a := .Values.agent | default .Release.Name -}}
{{- if not (regexMatch "^[a-z0-9]([a-z0-9_-]{0,48}[a-z0-9])?$" $a) -}}
{{- fail (printf "agent %q ใช้ได้เฉพาะ a-z 0-9 - _ (ตัวเล็ก, ขึ้นต้นและลงท้ายด้วยตัวอักษรหรือตัวเลข, ยาวไม่เกิน 50) — ตั้งค่า agent ใน values หรือเปลี่ยนชื่อ release" $a) -}}
{{- end -}}
{{- $a -}}
{{- end -}}

{{- define "ckan.name" -}}{{ .Release.Name }}-ckan{{- end -}}
{{- define "ckan.solrName" -}}{{ .Release.Name }}-solr{{- end -}}
{{- define "ckan.redisName" -}}{{ .Release.Name }}-redis{{- end -}}

{{- define "ckan.labels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: ckan-thai-gdc
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "ckan.selector" -}}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{- define "ckan.image" -}}
{{ .Values.ckan.image.repository }}:{{ .Values.ckan.image.tag | default .Chart.AppVersion }}
{{- end -}}

{{- define "ckan.siteUrl" -}}
{{- if .Values.ckan.siteUrl -}}
{{ .Values.ckan.siteUrl }}
{{- else -}}
{{- $host := required "ต้องกรอก ingress.host (หรือ ckan.siteUrl)" .Values.ingress.host -}}
{{ ternary "https" "http" .Values.ingress.tls.enabled }}://{{ $host }}
{{- end -}}
{{- end -}}

{{- define "ckan.solrUrl" -}}
{{- if .Values.solr.enabled -}}
http://{{ include "ckan.solrName" . }}:8983/solr/ckan
{{- else -}}
{{ required "solr.enabled=false ต้องกรอก solr.externalUrl" .Values.solr.externalUrl }}
{{- end -}}
{{- end -}}
