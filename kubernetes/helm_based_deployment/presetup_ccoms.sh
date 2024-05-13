#!/bin/bash

#"**********  Below are the pre-requisites ****************"
# 1. All nodes mentioned in inventory should be reachable"
# 2. Vault key id should be rotable"
# 3. After Git Checkout soft links should work properly"
#*********************************************************"

DIR_NAME=$(dirname $(realpath $0))

envs=(prod uat dev uat-2 qa)
VAULT_SCRIPT="${DIR_NAME}/scripts/pre_ccoms/vault_pwdrotation.sh"

export ANSIBLE_CONFIG="${DIR_NAME}/ansible.cfg"

echo -e "Verifying ------ All nodes mentioned in inventory should be reachable \n"
### We update host information here ---  environments/uat/hosts 

for env in ${envs[@]}
do
   ansible -m ping -i ${DIR_NAME}/environments/$env all | grep -q "SUCCESS"
   exit_val=$?
   [[ $exit_val -ne 0 ]] && ( echo "some of the nodes are not reachable" )
done

if [[ $exit_val -eq 0 ]]; 
then
   echo "all nodes are reachable";
   exit 0
fi


for env in ${envs[@]}
do
   [[ -L ${DIR_NAME}/environments/$env/group_vars/all/000_cross_env_vars ]] || ( echo "Link mismatch found" ; exit 1; )
   echo "Succesfully verified $env soft link";
done


echo -e "\n\nVerifying ---- Vault key should be rotable\n"
result=`sh $VAULT_SCRIPT`;
if [[ $? -eq 0 ]] ;
then
   echo "Successfully verified rotation"
else
   echo "Exited due to vault rotation failure";
   exit 1;
fi


echo -e "Add variables based on input file"

set -a
source $DIR_NAME/input_file.sh
set +a

ansible-playbook presetup.yaml 

echo -e "Verifying ------ All nodes mentioned in inventory should be reachable \n"
