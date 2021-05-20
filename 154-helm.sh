WORKSPACE_ID=$(aws amp list-workspaces --query workspaces[0].workspaceId | jq -r .)
IAM_PROXY_PROMETHEUS_ROLE_ARN=$(aws iam get-role --role-name amp-iamproxy-ingest-role | jq .Role.Arn)
AWS_REGION=$(aws configure get region)
#helm search repo "prometheus-community/prometheus" --versions | more

echo $WORKSPACE_ID $IAM_PROXY_PROMETHEUS_ROLE_ARN $AWS_REGION
# latest version 14.0.0 throws an erro - so try 13.8.0

helm install --version 13.6.0 amp-prometheus-chart prometheus-community/prometheus -n prometheus -f ./getme-from-AMP-console.yaml \
--set serviceAccounts.server.annotations."eks\.amazonaws\.com/role-arn"="${IAM_PROXY_PROMETHEUS_ROLE_ARN}" \
--set server.sidecarContainers.aws-sigv4-proxy-sidecar.args="{--name,aps,--region,${AWS_REGION},--host,aps-workspaces.${AWS_REGION}.amazonaws.com,--port,:8005}" \
--set server.remoteWrite[0].url="http://localhost:8005/workspaces/${WORKSPACE_ID}/api/v1/remote_write" 
echo "sleeping 10"
sleep 10
kubectl get pods --namespace prometheus

#export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
#kubectl --namespace prometheus port-forward $POD_NAME 8080:9090

