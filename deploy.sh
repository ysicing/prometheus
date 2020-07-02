#!/bin/bash 

kubectl apply -f setup
kubectl -n monitoring create secret generic etcd-certs --from-file=/etc/kubernetes/pki/etcd/healthcheck-client.crt --from-file=/etc/kubernetes/pki/etcd/healthcheck-client.key --from-file=/etc/kubernetes/pki/etcd/ca.crt

cat > /tmp/prometheus-additional.yaml <<EOF
- job_name: 'kubernetes-service-endpoints'
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]
    action: replace
    target_label: __scheme__
    regex: (https?)
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
  - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
    action: replace
    target_label: __address__
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: \$1:\$2
  - action: labelmap
    regex: __meta_kubernetes_service_label_(.+)
  - source_labels: [__meta_kubernetes_namespace]
    action: replace
    target_label: kubernetes_namespace
  - source_labels: [__meta_kubernetes_service_name]
    action: replace
    target_label: kubernetes_name
- job_name: 'kubernetes-ingresses'
  metrics_path: /probe
  params:
    module: [http_2xx]
  kubernetes_sd_configs:
  - role: ingress
  relabel_configs:
  - source_labels: [__meta_kubernetes_ingress_annotation_prometheus_io_probe]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_ingress_scheme,__address__,__meta_kubernetes_ingress_path]
    regex: (.+);(.+);(.+)
    replacement: \${1}://\${2}\${3}
    target_label: __param_target
  - target_label: __address__
    replacement: blackbox-exporter.monitoring.svc:9115
  - source_labels: [__param_target]
    target_label: instance
  - action: labelmap
    regex: __meta_kubernetes_ingress_label_(.+)
  - source_labels: [__meta_kubernetes_namespace]
    target_label: kubernetes_namespace
  - source_labels: [__meta_kubernetes_ingress_name]
    target_label: kubernetes_name
EOF

kubectl create secret generic additional-configs --from-file=/tmp/prometheus-additional.yaml -n monitoring

kubectl apply -f rules
kubectl apply -f prometheus-adapter
kubectl apply -f node-exporter
kubectl apply -f kube-state-metrics
kubectl apply -f alertmanager
kubectl apply -f grafana
kubectl apply -f blackbox-exporter
kubectl apply -f prometheus-service
kubectl apply -f setup/prometheus-operator-serviceMonitor.yaml
kubectl apply -f ingress