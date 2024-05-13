#!/bin/bash


DIR_NAME=$(dirname $(realpath $0))

export ANSIBLE_CONFIG="${DIR_NAME}/../../ansible.cfg"


## Uppdate home directory with new keys
rm -rf ~/.ansible_keys; cp -r ${DIR_NAME}/../../.ansible_keys/  ~/.ansible_keys/

## take backup of existing key files
rm -rf ~/.ansible_keys_back && cp -r ~/.ansible_keys ~/.ansible_keys_back

## Remove existing files
rm -rf ~/.ansible_keys && mkdir -p ~/.ansible_keys

envs=(dev qa uat uat-2 prod)

for env in "${envs[@]}"
do
    ## Generate random passwords
    date +%s | sha256sum | base64 | head -c 32  > ~/.ansible_keys/.vault_ccoms.${env}
done

for env in "${envs[@]}"
do

    ## Rekeying vault ids
    ansible-vault rekey --vault-id ${env}@~/.ansible_keys_back/.vault_ccoms.${env} --new-vault-id ${env}@~/.ansible_keys/.vault_ccoms.${env} ${DIR_NAME}/../../environments/${env}/group_vars/all/vault/ccoms_db
    
     
    if [ $? -ne 0 ]; then
       exit 1;
    fi

    rm -rf ${DIR_NAME}/../../.ansible_keys/.vault_ccoms.${env} && cp -r ~/.ansible_keys/.vault_ccoms.${env}  ${DIR_NAME}/../../.ansible_keys/

done

rm -rf ~/.ansible_keys_back

exit 0;
