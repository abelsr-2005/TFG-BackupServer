#!/bin/bash

FECHA=$(date '+%Y-%m-%d %H:%M:%S')
EQUIPO=$(hostname)

echo "✅ Copia de seguridad del equipo $EQUIPO realizada correctamente en $FECHA" | \
mail -s "📦 Backup completado - $EQUIPO" -r pctweaksoptimization@gmail.com pctweaksoptimization@gmail.com
