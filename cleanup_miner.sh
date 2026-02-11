# list the content of /tmp directory

ls -all /tmp/


sha256sum /tmp/c3pool_miner.sh
stat /tmp/c3pool_miner.sh
rm tmp/c3pool_miner.sh
rm /tmp/setup_c3pool_miner2.sh


# remove miner related services

systemctl stop c3pool_miner.service
systemctl stop javasw.service
systemctl stop zdump.service
systemctl stop zdumpd.service
systemctl stop kthread.service
systemctl stop ksoftirq.service
systemctl stop kworker.service
systemctl stop khungtask.service
systemctl stop khungtaskd.service
systemctl stop ksoftirqd.service
systemctl stop migration.service
systemctl stop rcu_preempt.service
systemctl stop rcu_tasks.service
systemctl stop system-mount.service
systemctl stop system.service
systemctl stop systemd.service
systemctl stop xsubp.service
systemctl stop zenity.service



systemctl disable c3pool_miner.service
systemctl disable zdump.service
systemctl disable zdumpd.service
systemctl disable javasw.service
systemctl disable kthread.service
systemctl disable ksoftirq.service
systemctl disable kworker.service
systemctl disable khungtask.service
systemctl disable khungtaskd.service
systemctl disable ksoftirqd.service
systemctl disable migration.service
systemctl disable rcu_preempt.service
systemctl disable rcu_tasks.service
systemctl disable system-mount.service
systemctl disable system.service
systemctl disable systemd.service
systemctl disable xsubp.service
systemctl disable zenity.service

pkill -9 wget

rm /etc/systemd/system/c3pool_miner.service

cat /etc/systemd/system/multi-user.target.wants/c3pool_miner.service
cat /etc/systemd/system/multi-user.target.wants/javasw.service
cat /etc/systemd/system/multi-user.target.wants/zdump.service
cat /etc/systemd/system/multi-user.target.wants/zdumpd.service
cat /etc/systemd/system/multi-user.target.wants/kthread.service
cat /etc/systemd/system/multi-user.target.wants/ksoftirq.service
cat /etc/systemd/system/multi-user.target.wants/kworker.service
cat /etc/systemd/system/multi-user.target.wants/khungtask.service
cat /etc/systemd/system/multi-user.target.wants/khungtaskd.service
cat /etc/systemd/system/multi-user.target.wants/ksoftirqd.service
cat /etc/systemd/system/multi-user.target.wants/migration.service
cat /etc/systemd/system/multi-user.target.wants/rcu_preempt.service
cat /etc/systemd/system/multi-user.target.wants/rcu_tasks.service
cat /etc/systemd/system/multi-user.target.wants/system-mount.service
cat /etc/systemd/system/multi-user.target.wants/system.service
cat /etc/systemd/system/multi-user.target.wants/systemd.service
cat /etc/systemd/system/multi-user.target.wants/xsubp.service
cat /etc/systemd/system/multi-user.target.wants/zenity.service

rm /etc/systemd/system/multi-user.target.wants/c3pool_miner.service
rm /etc/systemd/system/multi-user.target.wants/javasw.service
rm /etc/systemd/system/multi-user.target.wants/zdump.service
rm /etc/systemd/system/multi-user.target.wants/zdumpd.service
rm /etc/systemd/system/multi-user.target.wants/kthread.service
rm /etc/systemd/system/multi-user.target.wants/ksoftirq.service
rm /etc/systemd/system/multi-user.target.wants/kworker.service
rm /etc/systemd/system/multi-user.target.wants/khungtask.service
rm /etc/systemd/system/multi-user.target.wants/khungtaskd.service
rm /etc/systemd/system/multi-user.target.wants/ksoftirqd.service
rm /etc/systemd/system/multi-user.target.wants/migration.service
rm /etc/systemd/system/multi-user.target.wants/rcu_preempt.service
rm /etc/systemd/system/multi-user.target.wants/rcu_tasks.service
rm /etc/systemd/system/multi-user.target.wants/system-mount.service
rm /etc/systemd/system/multi-user.target.wants/system.service
rm /etc/systemd/system/multi-user.target.wants/systemd.service
rm /etc/systemd/system/multi-user.target.wants/xsubp.service
rm /etc/systemd/system/multi-user.target.wants/zenity.service

sudo systemctl daemon-reload

# cleanup files

rm ./cleanup_miner.sh
cat /etc/config.json
rm /etc/config.json


echo -e "\n######################################"
echo "ACTIVE NETWORK CONNECTIONS"
ss -tupnae | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | sort -u | grep -Ev '0.0.0.0|127.0.0*'
echo -e "\n######################################"


# cleanup history - last 200

history -a
head -n -200 /root/.bash_history > /root/bash_history.tmp && mv /root/bash_history.tmp /root/.bash_history

history -c
