# Automatización de copia de seguridad con Clonezilla

Este documento describe cómo crear un script personalizado para que Clonezilla realice una copia de seguridad automática, sin intervención del usuario, utilizando un servidor remoto Debian accesible por SSH.

## 🎯 Objetivo

Que al arrancar Clonezilla, el sistema:

1. Detecte automáticamente el nombre del equipo.
2. Cree un directorio de respaldo en el servidor.
3. Genere una imagen del disco principal (`sda`) con nombre y fecha.
4. Transfiera la imagen por SSH al servidor Debian.
5. Apague el equipo una vez finalizada la copia.

## 🧩 Requisitos previos

- El servidor debe tener:
  - SSH habilitado y funcional.
  - Usuario `backupuser` creado y configurado.
  - Carpeta `/backup-imagenes` con permisos de escritura.

- En el equipo cliente:
  - Se debe arrancar con Clonezilla Live.
  - Tener acceso de red al servidor Debian.
  - Las claves SSH deben estar configuradas para no pedir contraseña.

## 📜 Script: `mybackup.sh`

Guarda este contenido como `mybackup.sh` dentro de un USB o entorno PXE compatible con Clonezilla:

```bash
#!/bin/bash

# Obtener nombre del equipo
HOSTNAME=$(hostname)

# Configurar conexión SSH
USER=backupuser
SERVER=192.168.18.73
REMOTE_DIR="/backup-imagenes/${HOSTNAME}"

# Generar nombre de la imagen
FECHA=$(date +"%Y-%m-%d_%H-%M")
IMG_NAME="${HOSTNAME}_${FECHA}"

# Crear el directorio remoto si no existe
ssh ${USER}@${SERVER} "mkdir -p ${REMOTE_DIR}"

# Ejecutar copia automática del disco sda
sudo /usr/sbin/ocs-sr -q2 -c -j2 -z1 -i 2000 -sc -p poweroff \
    saveparts ${IMG_NAME} sda \
    --ssh-server ${SERVER} --ssh-user ${USER} --ssh-dir ${REMOTE_DIR}
```

## 🚀 Ejecución manual desde Clonezilla

Al arrancar Clonezilla Live:

1. Accede a la terminal (Ctrl + Alt + F2).
2. Ejecuta el script con:

```bash
sudo bash /home/partimag/mybackup.sh
```

(ajusta la ruta si es distinta)

## 🛠 Integración avanzada (opcional)

- Puedes personalizar una imagen de Clonezilla para que ejecute este script automáticamente al arrancar.
- También puedes añadir esta automatización en un servidor PXE, configurando la línea de arranque con parámetros automáticos.

## 🧪 Resultado esperado

- Se genera un directorio `/backup-imagenes/NOMBRE_EQUIPO`.
- Dentro se guarda una imagen con nombre `NOMBRE_EQUIPO_FECHA`.
- El equipo se apaga automáticamente al finalizar.

---

📁 Este script forma parte del proyecto de TFG y se puede personalizar para adaptarse a cualquier infraestructura con soporte SSH.
