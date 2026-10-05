# CKAN Thai GDC on Kubernetes (Portainer)

## ติดตั้งผ่าน Helm (แนะนำ)

Helm repository URL (ใส่ใน Portainer → Settings → Kubernetes settings → Helm repository):

```
https://nectec-opend.github.io/portainer-ckan-thaigdc-k8s
```

1. สร้าง namespace ของหน่วยงานใน Portainer (Namespaces → Add) และตั้ง resource quota
2. Helm → เลือก chart `ckan-thai-gdc` → ตั้ง Name = ชื่อหน่วยงาน (a-z0-9) → เลือก namespace
3. แก้ values อย่างน้อย:

```yaml
ingress:
  host: data.agency.go.th
postgres:
  password: "..."
  datastoreReadonlyPassword: "..."
sysadmin:
  password: "..."
```

ชื่อที่ได้อัตโนมัติจากชื่อ release (หรือค่า `agent`):
`ckan_<agent>` (DB/user), `datastore_<agent>` (datastore DB/readonly user)

## ติดตั้งแบบ manifest (Custom Template)

ใช้ไฟล์ `k8s/ckan-thaigdc-k8s.yaml` ดูคำอธิบายในไฟล์

## สำหรับผู้ดูแล chart

ต้องมีคำสั่ง `helm` ในเครื่อง

1. แก้ไฟล์ใน `charts/ckan-thai-gdc/` แล้ว **เพิ่ม `version` ใน Chart.yaml ทุกครั้ง**
2. รัน `./publish.sh` (ตรวจ chart, สร้าง .tgz และ index.yaml ใน `docs/`)
3. commit และ push

GitHub Pages ตั้งไว้ที่ branch `main` โฟลเดอร์ `/docs`
