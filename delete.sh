#!/bin/bash

kubectl delete -f rules
kubectl delete -f prometheus-adapter
kubectl delete -f node-exporter
kubectl delete -f kube-state-metrics
kubectl delete -f alertmanager
kubectl delete -f grafana
kubectl delete -f blackbox-exporter
kubectl delete -f prometheus-service
kubectl delete -f setup
kubectl delete -f ingress