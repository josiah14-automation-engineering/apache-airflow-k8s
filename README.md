# Abstract

Right now, this just creates a local K8S cluster using KinD and networks a local
Docker Registry

# Creating the KinD Cluster

Be patient, this will take a minute or two.  The below script will create a
local Docker Registry and a local KinD cluster and network the two together so
that the KinD cluster is able to pull Docker images from the local Docker
Registry and deploy containers built from those images to the cluster.

```bash
# if you have the Nix package manager:
nix-shell .  # this will install all system dependencies: Docker, KinD, K8S,...

# if you DON'T have the Nix package manager, you need to install KinD, K8S, and
# Docker manually, yourself.

./create-local-kind-cluster.sh
```

# Test the KinD Cluster Deployment

```bash
docker pull gcr.io/google-samples/hello-app:1.0
docker tag gcr.io/google-samples/hello-app:1.0 localhost:5000/hello-app:1.0
docker push localhost:5000/hello-app:1.0
kubectl create deployment hello-server --image=localhost:5000/hello-app:1.0

kubectl get pods \
    | grep hello \
    | awk '{print $1}' \
    | xargs -I {} kubectl port-forward {} 8080:8080

# In another terminal window or TMUX/Screen split.
curl localhost 8080

# You should see the following print to the screen:
# Hello, world!
# Version: 1.0.0
# Hostname: hello-server-587b6bcfdf-9zmfg
```

# Destroy the KinD Cluster and Local Docker Registry

```bash
./destroy-kind-cluster.sh
```
