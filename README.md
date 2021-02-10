## 注意说明

- 默认已存在存储类: k8s-prod-monitor

示例:

```yaml
# nfs
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: 'true'
  name: k8s-prod-monitor
parameters:
  archiveOnDelete: 'false'
provisioner: nfs-provisioner
reclaimPolicy: Delete
volumeBindingMode: Immediate
# aliyun nas
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: k8s-prod-monitor
mountOptions:
- nolock,tcp,noresvport
- vers=3
parameters:
  server: <nasid>.cn-beijing.nas.aliyuncs.com:/k8s-prod-aliyun-beijing/monitordata
  volumeAs: subpath
provisioner: nasplugin.csi.alibabacloud.com
reclaimPolicy: Retain
volumeBindingMode: Immediate
```

## 使用

```
git clone https://github.com/ysicing/prometheus.git
cd prometheus
```