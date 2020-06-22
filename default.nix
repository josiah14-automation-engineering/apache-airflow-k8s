with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "airflow-k8s-dev-env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    kubernetes
    kubernetes-helm
    kind
    terraform-providers.kubernetes
    go
  ];
}
