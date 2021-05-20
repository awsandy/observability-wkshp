WORKSPACE_ID=$(aws amp list-workspaces --alias observability-workshop | jq .workspaces[0].workspaceId -r)
AMP_ENDPOINT_URL=$(aws amp describe-workspace --workspace-id $WORKSPACE_ID | jq .workspace.prometheusEndpoint -r)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
echo $WORKSPACE_ID
echo $AMP_ENDPOINT_URL
echo $AWS_ACCOUNT_ID
echo $AWS_REGION
AMP_REMOTE_WRITE=${AMP_ENDPOINT_URL}api/v1/remote_write
echo $AMP_REMOTE_WRITE
cp -f resources/amp-eks-adot-prometheus-daemonset.yaml daemonset.yaml
sed -i -e "s/<AWS_ACCOUNT_ID>/$ACCOUNT_ID/g" daemonset.yaml
sed -i -e "s/<AWS_REGION>/$AWS_REGION/g" daemonset.yaml
sed -i -e "s|<AMP_REMOTE_WRITE_URL>|$AMP_REMOTE_WRITE|g" daemonset.yaml
kubectl apply -f daemonset.yaml
echo "sleep 10"
sleep 10
kubectl get pods -n prometheus

#kubectl port-forward -n prometheus pods/amp-prometheus-chart-server-0 8080:9090
