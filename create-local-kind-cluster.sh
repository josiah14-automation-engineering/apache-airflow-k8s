docker run -d --restart=always \
    -p 5000:5000 \
    --name 'local-registry' \
    --network bridge \
    --hostname 'local-registry' \
    registry:2

ipaddr=$( \
    docker inspect local-registry \
        -f '{{ json .NetworkSettings.Networks.bridge.IPAddress }}' \
        | sed -e 's/^"//' -e 's/"$//' \
)

sed "s/registry-container-ipaddr/${ipaddr}/g" \
    kind-cluster-template.yaml \
    > kind-cluster.yaml

kind create cluster --name bluekc8s --config kind-cluster.yaml

kind get nodes --name bluekc8s \
    | grep -E 'control|worker' \
    | xargs -n 1 -P 8 -I {} \
            kubectl annotate node {} "kind.x-k8s.io/registry=localhost:5000"
