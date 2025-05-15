#!/bin/bash

# Configuración
FECHA=$(date +%F)
EQUIPO="EQUIPO01"
DESTINO_SSH="backupuser@192.168.197.168"
RUTA_REMOTA="/backup-imagenes/$EQUIPO"
IMAGEN="backup-$FECHA"
DEST_LOCAL="/mnt/backups"

# 1. Asegurar directorio local
mkdir -p "$DEST_LOCAL"

# 2. Ejecutar Clonezilla guardando en /mnt/backups
ocs-sr -q2 -j2 -z1p -i 2000 -scr -p true -g auto -e1 auto -e2 -r -sfs "ocsroot=$DEST_LOCAL" savedisk "$IMAGEN" sda

# Verifica que se creó correctamente
if [ ! -d "$DEST_LOCAL/$IMAGEN" ]; then
  echo "❌ Error: La imagen no se creó en $DEST_LOCAL/$IMAGEN"
  exit 1
fi

# 3. Enviar por SSH
scp -r "$DEST_LOCAL/$IMAGEN" "$DESTINO_SSH:$RUTA_REMOTA/"

# 4. Verificar si scp fue exitoso
if [ $? -eq 0 ]; then
  echo "✅ Copia enviada correctamente a $RUTA_REMOTA"
  # Opcional: borrar la copia local
  # rm -rf "$DEST_LOCAL/$IMAGEN"
else
  echo "❌ Error al enviar la copia por SSH"
  exit 2
fi

# 5. (Opcional) Enviar correo de éxito
echo "Backup completado y enviado: $IMAGEN" | mail -s "✔️ Backup $EQUIPO" -r pctweaksoptimization@gmail.com pctweaksoptimization@gmail.com
