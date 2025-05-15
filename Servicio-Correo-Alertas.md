#!/bin/bash

# Configuración
FECHA=$(date +%F)
EQUIPO="EQUIPO01"
DESTINO_SSH="backupuser@192.168.197.168"
RUTA_REMOTA="/backup-imagenes/$EQUIPO"
IMAGEN="backup-$FECHA"

# 1. Asegurar directorio local
mkdir -p /home/partimag

# 2. Ejecutar Clonezilla
ocs-sr -q2 -j2 -z1p -i 2000 -scr -p true savedisk "$IMAGEN" sda

# Verifica que se creó correctamente
if [ ! -d "/home/partimag/$IMAGEN" ]; then
  echo "❌ Error: La imagen no se creó en /home/partimag/$IMAGEN"
  exit 1
fi

# 3. Enviar por SSH
scp -r "/home/partimag/$IMAGEN" "$DESTINO_SSH:$RUTA_REMOTA/"

# 4. Verificar si scp fue exitoso
if [ $? -eq 0 ]; then
  echo "✅ Copia enviada correctamente a $RUTA_REMOTA"
  # Opcional: borrar la copia local
  # rm -rf "/home/partimag/$IMAGEN"
else
  echo "❌ Error al enviar la copia por SSH"
  exit 2
fi

# 5. (Opcional) Enviar correo de éxito
echo "Backup completado y enviado: $IMAGEN" | mail -s "✔️ Backup $EQUIPO" -r pctweaksoptimization@gmail.com pctweaksoptimization@gmail.com
