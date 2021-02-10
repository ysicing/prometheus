#!/bin/bash 

kubectl apply -f setup
# 创建默认存储类
# kubectl apply -f misc/nfs-sc.yaml 
kubectl apply -f misc/additional-scrape-configs.yaml
kubectl -n monitoring create secret generic etcd-certs --from-file=/etc/kubernetes/pki/etcd/healthcheck-client.crt --from-file=/etc/kubernetes/pki/etcd/healthcheck-client.key --from-file=/etc/kubernetes/pki/etcd/ca.crt

kubectl apply -f alertmanager
kubectl apply -f blackbox-exporter 
kubectl apply -f grafana
kubectl apply -f kube-state-metrics
kubectl apply -f node-exporter
kubectl apply -f prometheus-adapter
kubectl apply -f prometheus
kubectl apply -f PrometheusRule
kubectl apply -f ServiceMonitor