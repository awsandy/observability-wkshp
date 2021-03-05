cd ~/environment/observ/workshopfiles/one-observability-demo/PetAdoptions/cdk/pet_stack
npm install
echo "npm install complete"
cd ~/environment/observ/workshopfiles/one-observability-demo/PetAdoptions/cdk/pet_stack
cdk bootstrap
echo "bootstrap complete"
EKS_ADMIN_ARN=$(../../getrole.sh)
CONSOLE_ROLE_ARN=$(../../getrole.sh)
echo -e "\nRole \"${EKS_ADMIN_ARN}\" will be part of system:masters group\n" 
if [ -z $CONSOLE_ROLE_ARN ]; then echo -e "\nEKS Console access will be restricted\n"; else echo -e "\nRole \"${CONSOLE_ROLE_ARN}\" will have access to EKS Console\n"; fi
echo "cdk deploy ...."
cdk deploy --context admin_role=$EKS_ADMIN_ARN Services --context dashboard_role_arn=$CONSOLE_ROLE_ARN --require-approval never
echo "cdk Apps deploy ...."
cdk deploy Applications --require-approval never



