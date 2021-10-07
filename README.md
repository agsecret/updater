## System & Nextcloud Updater
**Update**
- Nextcloud Version and Apps, 
- OS packages 
- Backup DB and Nextcloud config ( for 15 days)
- Renew Let's Encrypt certificate
- Reboot if necessary

### crontab
20 20 * * * /home/scripts/updater.sh 2>&1 | /usr/bin/mail -s "Updater Result" "email@example.com"

