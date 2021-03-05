helm repo add grafana https://grafana.github.io/helm-charts
kubectl create ns grafana
helm install grafana-for-amp grafana/grafana -n grafana
IAM_PROXY_PROMETHEUS_ROLE_ARN=$(aws amp list-workspaces --query workspaces[0].arn | jq -r .)
echo "edit amp_query_override_values.yaml"
helm upgrade --install grafana-for-amp grafana/grafana -n grafana -f ./amp_query_override_values.yaml
export POD_NAME=$(kubectl get pods --namespace grafana -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana-for-amp" -o jsonpath="{.items[0].metadata.name}")
kubectl get secrets grafana-for-amp -n grafana -o jsonpath='{.data.admin-password}'|base64 --decode
kubectl --namespace grafana port-forward $POD_NAME 8080:3000