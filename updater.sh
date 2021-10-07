#!/bin/bash
set -e

ncpath='/var/www/nextcloud'
htuser='www-data'
htgroup='www-data'
rootuser='root'
pass='MYSQL_PASS'
bkpdir='/home/username/dump/'

printf "\n##-- uptime\n"
uptime

printf "\n##-- Backup Databases\n"
mysqldump -u root -p${pass} --default-character-set=utf8mb4 nextcloud > ${bkpdir}nextcloud_"$(date +"%Y-%m-%d")".sql

printf "\n##-- Delete DB dump older then 15 days\n"
find ${bkpdir} -mtime +15 -exec rm {} \;

printf "\n##-- Backup Nextcloud config files\n"
sudo tar -cpzvf ${bkpdir}nextcloud-config"$(date +"%Y-%m-%d")".tar.gz ${ncpath}/config
sudo chown "$USER:$USER" ${bkpdir}nextcloud-config_"$(date +"%Y-%m-%d")".tar.gz

printf "\n##-- Chown to allow update\n"
sudo chown -R ${htuser}:${htgroup} ${ncpath}

printf "\n##-- Update the Nextcloud version\n"
sudo -u www-data php ${ncpath}/updater/updater.phar --no-interaction

printf "\n##-- chmod to secure Files and Directories\n"
sudo find ${ncpath}/ -type f -print0 | sudo xargs -0 chmod 0640
sudo find ${ncpath}/ -type d -print0 | sudo xargs -0 chmod 0750

printf "\n##-- chown Directories\n"
sudo chown -R ${rootuser}:${htgroup} ${ncpath}
sudo chown -R ${htuser}:${htgroup} ${ncpath}/apps/
sudo chown -R ${htuser}:${htgroup} ${ncpath}/core/
sudo chown -R ${htuser}:${htgroup} ${ncpath}/config/
sudo chown -R ${htuser}:${htgroup} ${ncpath}/data/
sudo chown -R ${htuser}:${htgroup} ${ncpath}/themes/
sudo chown -R ${htuser}:${htgroup} ${ncpath}/updater/
sudo chmod +x ${ncpath}/occ

printf "\n##-- Secure .htaccess\n"
if [ -f ${ncpath}/.htaccess ]
 then
  sudo chmod 0644 ${ncpath}/.htaccess
  sudo chown ${rootuser}:${htgroup} ${ncpath}/.htaccess
fi
if [ -f ${ncpath}/data/.htaccess ]
 then
  sudo chmod 0644 ${ncpath}/data/.htaccess
  sudo chown ${rootuser}:${htgroup} ${ncpath}/data/.htaccess
fi

printf "\n##-- Update Nextcloud apps\n"
sudo -u ${htuser} php ${ncpath}/occ app:update --all

printf "\n##-- Remove old unnecessary packages with apt autoremove\n\n"
DEBIAN_FRONTEND=noninteractive sudo apt-get autoremove

printf "\n##-- Update all OS package with apt\n"
sudo apt-get update
sudo apt-get -y upgrade

printf "\n##-- Renew Let's enscrypt TLS if necessary\n"
sudo /usr/bin/certbot -q renew

if [ -f /var/run/reboot-required ]; then
        more /var/run/reboot-required
	echo "System full update and will reboot"
        sudo reboot
fi
printf "\n##-- Update complete\n"
