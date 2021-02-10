#!/bin/bash

kubectl delete -f ServiceMonitor
kubectl delete -f PrometheusRule
kubectl delete -f prometheus
kubectl delete -f prometheus-adapter
kubectl delete -f node-exporter
kubectl delete -f kube-state-metrics
kubectl delete -f grafana
kubectl delete -f blackbox-exporter
kubectl delete -f alertmanager

# kubectl delete -f setup
# 创建默认存储类
# kubectl delete -f misc/nfs-sc.yaml 
# kubectl delete -f misc/additional-scrape-configs.yaml
# kubectl -n monitoring create secret generic etcd-certs --from-file=/etc/kubernetes/pki/etcd/healthcheck-client.crt --from-file=/etc/kubernetes/pki/etcd/healthcheck-client.key --from-file=/etc/kubernetes/pki/etcd/ca.crt
