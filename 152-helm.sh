curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo update
kubectl create ns prometheus
chmod +x ~/environment/observ/workshopfiles/one-observability-demo/PetAdoptions/cdk/pet_stack/resources/amp-setup-irsa-eks.sh
~/environment/observ/workshopfiles/one-observability-demo/PetAdoptions/cdk/pet_stack/resources/amp-setup-irsa-eks.sh
aws iam get-role --role-name amp-iamproxy-ingest-role | jq .Role.Arn
aws amp list-workspaces

