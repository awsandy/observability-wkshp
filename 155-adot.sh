kubectl apply -f amp-eks-adot-prometheus-daemonset.yaml
kubectl get pods -n prometheus
kubectl get pods amp-prometheus-chart-server-0  -n prometheus -o jsonpath='{.spec.containers[*].name}*'|  tr -s '[[:space:]]' '\n'
#kubectl port-forward -n prometheus pods/amp-prometheus-chart-server-0 8080:9090
