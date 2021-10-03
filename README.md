# System & Nextcloud Updater
Update Nextcloud version, apps, os packages, backup DB, renew TLS 

# crontab
20 20 * * * /home/scripts/updater.sh 2>&1 | /usr/bin/mail -s "Updater Result" "email@example.com"

