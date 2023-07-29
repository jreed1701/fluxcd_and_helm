#!/usr/bin/env bash

LOCAL_REGISTRY=localhost:9001
GIT_URL=localhost:3000/jreed/fluxcd
NAMESPACE=flux-system

handle_image() {
    docker pull $1/$2
    docker tag $1/$2 $LOCAL_REGISTRY/$2
    docker push $LOCAL_REGISTRY/$2
}

handle_image "ghcr.io" "fluxcd/source-controller:v1.0.1"
handle_image "ghcr.io" "fluxcd/kustomize-controller:v1.0.1"
handle_image "ghcr.io" "fluxcd/helm-controller:v0.35.0"
handle_image "ghcr.io" "fluxcd/notification-controller:v1.0.0"

kubectl create ns flux-system $NAMESPACE

kubectl -n flux-system create secret generic regcred \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml
