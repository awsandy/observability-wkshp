kubectl create namespace grafana-agent; 
export WORKSPACE=$(aws amp list-workspaces --query workspaces[0].workspaceId | jq -r .) 
export ROLE_ARN="arn:aws:iam::433146468867:role/EKS-GrafanaAgent-AMP-ServiceAccount-Role" 
export REGION="eu-west-1" 
export NAMESPACE="grafana-agent" 
export REMOTE_WRITE_URL="https://aps-workspaces.$REGION.amazonaws.com/workspaces/$WORKSPACE/api/v1/remote_write" 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/grafana/agent/v0.11.0/production/kubernetes/install-sigv4.sh)" | kubectl apply -f -