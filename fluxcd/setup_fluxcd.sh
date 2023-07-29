#!/usr/bin/env bash

CHARTMUSEUM=http://192.168.50.100:8080  # IP comes from windows etc/hosts file.
NAMESPACE=flux-system

flux create source helm chartmusuem --interval=30s --url=$CHARTMUSEUM --namespace $NAMESPACE

flux create helmrelease helm-app-hr --chart helm-app --source HelmRepository/chartmuseum --chart-version 0.1.0 --namespace flux-system