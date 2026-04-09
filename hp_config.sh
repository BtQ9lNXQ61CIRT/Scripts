#!/bin/bash

read -p "Enter VLAN Name (Eg: MOIC): " VLAN

SEARCH="GovTech_BtCIRT_Honeypot"
REPLACE=$SEARCH"_"$VLAN
FILE=ossec.conf

sed -i "s/$SEARCH/$REPLACE/g" "$FILE"

:>/opt/opencanary/logs/opencanary.log
systemctl restart wazuh-agent

echo '########################################################################################'
echo "Configuration completed successfully"
echo '########################################################################################'
