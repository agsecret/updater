## System & Nextcloud Updater
**Update**
- Nextcloud 
- backup Nextcloud config for 15 day
- version
- apps, 
- os packages, 
- backup DB for 15 days, 
- renew TLS 
- Reboot if necessary

### crontab
20 20 * * * /home/scripts/updater.sh 2>&1 | /usr/bin/mail -s "Updater Result" "email@example.com"

