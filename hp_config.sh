#!/bin/bash

read -p "Enter VLAN Name (Eg: MOIC_DMZ): " VLAN < /dev/tty

SEARCH="GDC_Honeypot_Staging"
REPLACE="GDC_Honeypot_"$VLAN
FILE=/var/ossec/etc/ossec.conf

sed -i "s/$SEARCH/$REPLACE/g" "$FILE"

:>/opt/opencanary/logs/opencanary.log
systemctl restart wazuh-agent

echo ""
echo '########################################################################################'
echo "Configuration completed successfully"
echo '########################################################################################'
echo ""