aws eks update-kubeconfig --name PetSite --region $AWS_REGION            
kubectl get nodes                                
aws ssm get-parameter --name '/petstore/petsiteurl'  | jq -r .Parameter.Value
# handy link
ln -s ~/environment/observ/workshopfiles/one-observability-demo/PetAdoptions/cdk/pet_stack/resources resources
