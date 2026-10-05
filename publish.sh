#!/usr/bin/env bash
# ใช้ publish Helm chart ลงโฟลเดอร์ docs/ (GitHub Pages)
# ต้องมีคำสั่ง helm ในเครื่อง
set -euo pipefail

CHART=charts/ckan-thai-gdc
URL=https://nectec-opend.github.io/ckan-thaigdc-helm
TEST="--set ingress.host=data.example.go.th --set postgres.password=x --set postgres.datastoreReadonlyPassword=x --set sysadmin.password=x"

echo "== ตรวจ chart"
helm lint "$CHART" $TEST
helm template agency "$CHART" $TEST > /dev/null

VERSION=$(grep '^version:' "$CHART/Chart.yaml" | awk '{print $2}')
if [ -f "docs/ckan-thai-gdc-$VERSION.tgz" ]; then
  echo "เวอร์ชัน $VERSION มีอยู่แล้ว — เพิ่ม version ใน Chart.yaml ก่อน"; exit 1
fi

echo "== สร้างแพ็กเกจ $VERSION"
mkdir -p docs
helm package "$CHART" -d docs
helm repo index docs --url "$URL"

echo "== เสร็จแล้ว ต่อไปให้รัน:"
echo "   git add docs $CHART && git commit -m \"chart $VERSION\" && git push"
