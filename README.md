## System & Nextcloud Updater
**Update**
- Nextcloud 
- Version
- Apps, 
- OS packages, 
- Backup DB (15 days)
- Backup Nextcloud config (15 days)
- Renew TLS 
- Reboot if necessary

### crontab
20 20 * * * /home/scripts/updater.sh 2>&1 | /usr/bin/mail -s "Updater Result" "email@example.com"

