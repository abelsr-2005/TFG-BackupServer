#!/bin/bash

RUTA_BACKUP="/home/backupuser/backup-imagenes"
CORREO="pctweaksoptimization@gmail.com"
REMITENTE="pctweaksoptimization@gmail.com"

# Última modificación en minutos
ULTIMO_CAMBIO=$(find "$RUTA_BACKUP" -type f -mmin -30 | wc -l)

FECHA=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$ULTIMO_CAMBIO" -gt 0 ]; then
    echo "✅ Copia de seguridad detectada con éxito en $FECHA" | \
    mail -s "Backup OK - $FECHA" -r "$REMITENTE" "$CORREO"
else
    echo "⚠️ No se ha recibido ninguna copia en los últimos 30 minutos ($FECHA)" | \
    mail -s "Backup NO recibido - $FECHA" -r "$REMITENTE" "$CORREO"
fi
