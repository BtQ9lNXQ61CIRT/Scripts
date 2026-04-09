#!/bin/bash

read -p "Enter VLAN Name (Eg: MOIC): " VLAN < /dev/tty

SEARCH="GovTech_BtCIRT_Honeypot"
REPLACE=$SEARCH"_"$VLAN
FILE=/var/ossec/etc/ossec.conf

sed -i "s/$SEARCH/$REPLACE/g" "$FILE"

:>/opt/opencanary/logs/opencanary.log
systemctl restart wazuh-agent

echo '########################################################################################'
echo "Configuration completed successfully"
echo '########################################################################################'
