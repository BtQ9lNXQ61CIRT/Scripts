#!/bin/bash
# -----------------------------------------------------------------------------
# Script Name:     install_zeek_ubuntu_24_04.sh
# Description:     Install zeek on Ubuntu 24.04
# Author:          NT
# Date Created:    2025-10-09
# Last Modified:   2025-10-09
# Version:         1.0
# -----------------------------------------------------------------------------

set -e

if [[ $EUID -ne 0 ]]; then
  echo "Error: This script must be run as root." >&2
  exit 1
fi
echo "Running as root..."

if ping -c 1 -W 3 bt.bt &>/dev/null; then
  echo "Ping successful: bt.bt is reachable."
else
  echo "Error: Cannot reach bt.bt."
  echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  echo "nameserver 8.8.4.4" >> /etc/resolv.conf
  echo "nameserver 1.1.1.1" >> /etc/resolv.conf
  netplan apply
fi

echo 'export HISTTIMEFORMAT="%F %T "' >> /etc/bash.bashrc
echo 'export PROMPT_COMMAND="history -a"' >> /etc/bash.bashrc
echo '########################################################################################'
echo 'Timestamped command history configuration completed ... [Step 1/5]'
echo '########################################################################################'


echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
#curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_24.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
curl -fsSL https://github.com/BtQ9lNXQ61CIRT/Scripts/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null



chmod 644 /etc/apt/trusted.gpg.d/security_zeek.gpg
sudo apt update
sudo apt install zeek -y


echo ''
echo '########################################################################################'
echo 'Zeek download and installation completed ... [Step 2/5]'
echo '########################################################################################'


echo "export PATH=$PATH/:/opt/zeek/bin" >> ~/.bashrc
source ~/.bashrc

echo "" >> /opt/zeek/etc/networks.cfg
echo "10.0.0.0/16" >> /opt/zeek/etc/networks.cfg
echo "172.16.0.0/12" >> /opt/zeek/etc/networks.cfg
echo "192.168.0.0/16" >> /opt/zeek/etc/networks.cfg

interface_name=$(ip a | awk '/<BROADCAST,MULTICAST,UP,LOWER_UP>/ {sub(":", "", $2); print $2}' | head -1)
sed -i 's/interface=eth0/interface='$interface_name'/' /opt/zeek/etc/node.cfg

echo ''
echo '########################################################################################'
echo 'Zeek network configuration completed ... [Step 3/5]'
echo '########################################################################################'


hash=$(openssl rand -hex 16)
sed -i 's/digest_salt = "Please change this value."/digest_salt = "'$hash'"/' /opt/zeek/share/zeek/site/local.zeek

echo "" >> /opt/zeek/share/zeek/site/local.zeek
echo "@load policy/tuning/json-logs.zeek" >> /opt/zeek/share/zeek/site/local.zeek
echo "redef LogAscii::use_json = T;" >> /opt/zeek/share/zeek/site/local.zeek
echo "@load owlh.zeek" >> /opt/zeek/share/zeek/site/local.zeek


touch /opt/zeek/share/zeek/site/owlh.zeek
echo 'redef record DNS::Info += {
	bro_engine: string &default="DNS" &log;
};
redef record Conn::Info += {
	bro_engine: string &default="CONN" &log;
};
redef record Weird::Info += {
	bro_engine: string &default="WEIRD" &log;
};
redef record SSL::Info += {
	bro_engine: string &default="SSL" &log;
};
redef record SSH::Info += {
	bro_engine: string &default="SSH" &log;
};
redef record HTTP::Info += {
	bro_engine: string &default="HTTP" &log;
};' > /opt/zeek/share/zeek/site/owlh.zeek


/opt/zeek/bin/zeekctl deploy
/opt/zeek/bin/zeekctl install
/opt/zeek/bin/zeekctl restart

awk 'found==0 { if (sub("LogExpireInterval = 0","LogExpireInterval = 30 day")) found=1 } { print }' /opt/zeek/etc/zeekctl.cfg > /tmp/zeekctl.cfg
mv /tmp/zeekctl.cfg /opt/zeek/etc/zeekctl.cfg

echo ''
echo '########################################################################################'
echo 'Zeek logs configuration completed ... [Step 4/5]'
echo '########################################################################################'


(crontab -l; echo "") | crontab -
(crontab -l; echo "### Installed by Cybersecurity for Zeek log rotation [Do not remove]") | crontab -
(crontab -l; echo "*/5 * * * * /opt/zeek/bin/zeekctl cron") | crontab -

/opt/zeek/bin/zeekctl cron enable


echo ''
echo '########################################################################################'
echo 'Cron installed ... [Step 5/5]'
echo '########################################################################################'

rm ./install_zeek_ubuntu_24_04.sh

echo ''
echo '########################################################################################'
echo 'Cleanup completed.'
echo 'Zeek installation and configuration completed successfully.'
echo '########################################################################################'

