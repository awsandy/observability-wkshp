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
WORKSPACE_ID=$(aws amp list-workspaces --query workspaces[0].workspaceId | jq -r .)
IAM_PROXY_PROMETHEUS_ROLE_ARN=$(aws iam get-role --role-name amp-iamproxy-ingest-role | jq .Role.Arn)
AWS_REGION=$(aws configure get region)
helm install amp-prometheus-chart prometheus-community/prometheus -n prometheus -f ~/environment/observ/workshopfiles/one-observability-demo/PetAdoptions/cdk/pet_stack/resources/amp_ingest_override_values.yaml \
--set serviceAccounts.server.annotations."eks\.amazonaws\.com/role-arn"="${IAM_PROXY_PROMETHEUS_ROLE_ARN}" \
--set server.sidecarContainers.aws-sigv4-proxy-sidecar.args="{--name,aps,--region,${AWS_REGION},--host,aps-workspaces.${AWS_REGION}.amazonaws.com,--port,:8005}" \
--set server.remoteWrite[0].url="http://localhost:8005/workspaces/${WORKSPACE_ID}/api/v1/remote_write"
export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
#kubectl --namespace prometheus port-forward $POD_NAME 8080:9090

