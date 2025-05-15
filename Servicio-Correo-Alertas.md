ocs-sr -q2 -j2 -z1p -i 2000 -scr -p true savedisk backup-$(date +%F) sda \
&& scp -r /home/partimag/backup-$(date +%F) backupuser@192.168.1.100:/home/backupuser/backup-imagenes/EQUIPO01/ \
&& ./post-backup.sh
