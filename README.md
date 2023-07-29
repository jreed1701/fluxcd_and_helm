# FluxCD & Helm Learning 

I used this to teach myself how FluxCD can work with helm in an isolated environment without using GitHub, Gitlab, etc...

Typically, FluxCD will monitor a git repository on one of the big hosted sites.  You can use GitHub, for example. Really it doesn't
care what you use so long as its accessible via web request.  FluxCD watches a repository for changes in Declarative YAML files making
up the state of a Kubernetes Cluster; pods, deployments, etc..  Whenever there is a change it'll pull the change and make the state
of the cluster match the state of what's declared in the git repository.  In addition to declarative YAML files, it can also do the 
same thing for helm releases.  

Without Using GitHub, one can directly create and modify the HelmRelease Custom Resource Definition (CRD) to get flux to update a 
Helm release.  That's what this exercise seeks to accomplish. 

# Pre-requisites:
1. Docker Desktop for Windows installed & Kubernetes turned on.
2. WSL2 + Ubuntu installed
3. Helm installed in WSL (v3.12.0)
4. Helm Push plugin installed
5. Nginx Ingress controller installed to Kubernetes cluster
6. Windows ETC hosts file must have "mypc.local" as an alias with "host.docker.internal" (NOT 127.0.0.1 or localhost)

## Set up resources.

1. mkdir charts
2. chmod 777 charts
3. docker compose up -d


## Make 3x Docker images of a simple flask app.

1. cd simple_app
2. ./build_image_versions.sh

NOTE: This also pushes to the local docker registry.

## Setup helm chart/repo

1. cd helm-app
2. helm repo index .
3. helm package .
4. helm repo add chartmusuem http://localhost:8080
6. helm cm-push ./helm-app-0.1.0.tgz chartmusuem
7. helm repo update
8. helm search repo chartmuseum
9. helm install helm-app chartmuseum/helm-app
10. Open up a browser and go to "mypc.local"

NOTE. Uninstall before proceeding with "helm uninstall helm-app"

## Setup fluxcd

1. cd fluxcd
2. ./install.sh
3. open up setup_fluxcd.sh. Update the CHARTMUSEUM IP address to be the same IP as an alias with "host.docker.internal" in 
   windows host file. Massively important!
4. ./ setup_fluxcd.sh
5. Open up a browser and go to "mypc.local" again.

## Simulate updating the helm chart and fluxcd updating it automatically.

1. cd helm-app
2. Open Chart.yaml and change "version: 0.1.0" to "version: 0.2.0"
2. Open templates/deployment.yaml and change "image: localhost:9001/simple_app:v1" to "image: localhost:9001/simple_app:v2"
3. helm cm-push ./helm-app-0.2.0.tgz chartmuseum
4. Update the HelmRelease Object: kubectl edit HelmRelease -n flux-system helm-app-hr
5. In the editor, find "verison: 0.1.0" and change it to "version: 0.2.0"
6. save and exit.
7. Now, in the web browser, observe that fluxcd automatically updated the helm chart and the "Version #" in the text has changed
   from 1 to 2. 

# References

1. https://helm.sh/docs/howto/chart_repository_sync_example/
2. https://github.com/helm/chartmuseum