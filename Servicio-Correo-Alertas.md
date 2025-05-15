# 📧 Sistema de Alertas por Correo para Copias de Seguridad

Este documento describe cómo implementar un sistema automatizado de envío de correos electrónicos que notifica si una copia de seguridad mediante Clonezilla ha sido completada correctamente o ha fallado, usando `mail` y `Postfix`.

---

## 🧩 Contexto del Proyecto

Se realiza una copia de seguridad de un equipo (con Clonezilla Live o desde Kali/Debian) y esta se transfiere al servidor de backups mediante SSH. Queremos que al completarse la copia, el sistema:

1. Verifique si se ha creado correctamente la imagen.
2. Envíe la copia al servidor remoto.
3. Envíe un correo electrónico indicando el resultado del proceso.

---

## ✅ Requisitos Previos

- Servidor Debian o Kali con conexión a Internet.
- Cuenta de Gmail configurada con contraseña de aplicación.
- Paquetes instalados:
  ```bash
  sudo apt install postfix mailutils
  ```
- Postfix configurado para usar Gmail como relay SMTP.

---

## 🛠️ Configuración del Correo

1. Edita `/etc/postfix/main.cf`:
    ```ini
    relayhost = [smtp.gmail.com]:587
    smtp_use_tls = yes
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options = noanonymous
    smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
    inet_protocols = ipv4
    ```

2. Crea el archivo `/etc/postfix/sasl_passwd`:
    ```
    [smtp.gmail.com]:587 tuusuario@gmail.com:contraseña_de_aplicación
    ```

3. Aplica permisos y genera el hash:
    ```bash
    sudo postmap /etc/postfix/sasl_passwd
    sudo chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
    ```

4. Reinicia Postfix:
    ```bash
    sudo systemctl restart postfix
    ```

---

## 📦 Script de Backup con Alerta

El siguiente script realiza:

- Backup con Clonezilla
- Envío por SSH al servidor
- Correo si el proceso tuvo éxito o fallo

```bash
#!/bin/bash

FECHA=$(date +%F)
EQUIPO="EQUIPO01"
DESTINO_SSH="backupuser@192.168.197.168"
RUTA_REMOTA="/backup-imagenes/$EQUIPO"
IMAGEN="backup-$FECHA"
DEST_LOCAL="/home/partimag"

mkdir -p "$DEST_LOCAL"

# Ejecutar backup con Clonezilla
ocs-sr -q2 -j2 -z1p -i 2000 -scr -p true savedisk "$IMAGEN" sda

# Verificar si se creó
if [ ! -d "$DEST_LOCAL/$IMAGEN" ]; then
  echo "❌ Error: La imagen no se creó en $DEST_LOCAL/$IMAGEN" | mail -s "❌ Backup FALLIDO - $EQUIPO" -r pctweaksoptimization@gmail.com pctweaksoptimization@gmail.com
  exit 1
fi

# Enviar por SSH
scp -r "$DEST_LOCAL/$IMAGEN" "$DESTINO_SSH:$RUTA_REMOTA/"

if [ $? -eq 0 ]; then
  echo "✅ Backup enviado correctamente a $RUTA_REMOTA" | mail -s "✔️ Backup OK - $EQUIPO" -r pctweaksoptimization@gmail.com pctweaksoptimization@gmail.com
else
  echo "❌ Error al enviar la copia al servidor" | mail -s "❌ FALLO al subir backup - $EQUIPO" -r pctweaksoptimization@gmail.com pctweaksoptimization@gmail.com
  exit 2
fi
```

---

## ✨ Resultado Esperado

- Si el backup se guarda y envía correctamente, recibes un correo con asunto: `✔️ Backup OK - EQUIPO01`.
- Si falla la creación o el envío, se recibe un correo con `❌` en el asunto y mensaje descriptivo.

---

## ✅ Ventajas de este sistema

- Notificación en tiempo real del estado de las copias.
- Independencia del método de copia (Clonezilla, rsync, etc).
- Personalizable: puedes adaptarlo a varios equipos o discos.

---

## 📬 Sugerencia de mejoras futuras

- Añadir registros a `/var/log/backup.log`
- Integrar con Telegram o Slack
- Control de versiones de imágenes
- Verificación automática de integridad (checksum)

---

🎉 Con esto, tendrás un sistema robusto y autónomo de alertas por correo para tus copias de seguridad.
