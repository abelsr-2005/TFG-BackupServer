# 📧 Servicio de Alertas por Correo para Copias de Seguridad

Este documento describe cómo implementar un sistema automatizado de envío de correos electrónicos que notifica si una copia de seguridad mediante Clonezilla ha sido completada correctamente o ha fallado, usando `mail` y `Postfix`.

---

## 🧩 Contexto del Proyecto

Se realiza una copia de seguridad de un equipo (con Clonezilla Live o desde Kali/Debian) y esta se transfiere al servidor de backups mediante SSH. Queremos que al completarse la copia, el sistema:

1. Verifique si se ha creado correctamente la imagen.
2. Envíe la copia al servidor remoto.

Una vez montado y funcional el servidor de copias de seguridad, surge la necesidad de automatizar el proceso de supervisión y control. Aunque el sistema de backup ya cumple con su cometido técnico, contar con un servicio de alertas por correo electrónico representa una mejora significativa en términos de eficiencia y fiabilidad operativa.

Este sistema de notificación permite recibir un correo automáticamente cada vez que se completa (o falla) una copia de seguridad. Así se evita tener que comprobar manualmente el estado de cada operación, algo que puede ser tedioso, propenso a olvidos y poco escalable en el tiempo.

Implementar esta solución no solo ahorra tiempo, sino que también mejora la capacidad de reacción ante posibles errores. Si por cualquier motivo una copia no se realiza correctamente, el administrador es informado de inmediato y puede actuar sin necesidad de revisar logs o estar físicamente delante del sistema.

Por tanto, este servicio de alertas se convierte en una herramienta clave para garantizar la continuidad del sistema de respaldo, aumentando su fiabilidad y automatizando el control sin depender exclusivamente de la supervisión humana.

---

## ✅ Requisitos Previos

- Acceso a una cuenta de Gmail con autenticación de dos factores habilitada.

```bash
sudo apt update
sudo apt install postfix mailutils libsasl2-modules
```

- Conexión a Internet para enviar correos.

---

## 🔐 Generar la contraseña de aplicación de Gmail

Para usar Gmail como servidor SMTP con Postfix, necesitas una **contraseña de aplicación** (no tu contraseña habitual). Sigue estos pasos:

1. Accede a tu cuenta de Google: https://myaccount.google.com
2. Ve a la sección **Seguridad**.
3. Activa la **verificación en dos pasos**, si no lo has hecho aún.
4. Después de activarla, entra a: https://myaccount.google.com/apppasswords
5. En “Seleccionar aplicación”, elige `Correo`.
6. En “Seleccionar dispositivo”, escribe un nombre (ej. `Alerta_Backup`).
<br> <br>
![token-correo](https://github.com/user-attachments/assets/563f1296-3251-4818-8429-7542dca39d15)

8. Pulsa en **Crear**. Se mostrará una contraseña de 16 caracteres.
9. Copia esa contraseña. La usarás en `/etc/postfix/sasl_passwd`.

## 🛠️ Configuración de Postfix con Gmail

### 1. Editar el archivo de configuración:

```bash
sudo nano /etc/postfix/main.cf
```

Agrega:

```ini
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
inet_protocols = ipv4
```

### 2. Crear archivo de autenticación:

```bash
sudo nano /etc/postfix/sasl_passwd
```

Contenido:

```
[smtp.gmail.com]:587 tu_correo@gmail.com:contraseña_de_aplicación
```

### 3. Aplicar cambios y asegurar permisos:

```bash
sudo postmap /etc/postfix/sasl_passwd
sudo chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
```

### 4. Reiniciar Postfix:

```bash
sudo systemctl restart postfix
```

### 5. Probar envío de correo:

```bash
echo "Correo de prueba" | mail -s "Asunto de prueba" tu_correo@gmail.com
```
![Comprobación Correo de prueha](https://github.com/user-attachments/assets/c56bf701-de8f-4fdc-8473-47d843de21a9)

---

## 🔁 Integración con Script de Copia de Seguridad

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
  echo "❌ Error: La imagen no se creó en $DEST_LOCAL/$IMAGEN" | mail -s "❌ Backup FALLIDO - $EQUIPO" -r tu_correo@gmail.com tu_correo@gmail.com
  exit 1
fi

# Enviar por SSH
scp -r "$DEST_LOCAL/$IMAGEN" "$DESTINO_SSH:$RUTA_REMOTA/"

if [ $? -eq 0 ]; then
  echo "✅ Backup enviado correctamente a $RUTA_REMOTA" | mail -s "✔️ Backup OK - $EQUIPO" -r tu_correo@gmail.com tu_correo@gmail.com
else
  echo "❌ Error al enviar la copia al servidor" | mail -s "❌ FALLO al subir backup - $EQUIPO" -r tu_correo@gmail.com tu_correo@gmail.com
  exit 2
fi
```

---

## 🔎 Revisión de Logs

```bash
sudo journalctl -u postfix -e
```

Errores comunes:
- `Relay access denied`: Error en la configuración de relayhost.
- `Authentication failed`: Credenciales incorrectas en `sasl_passwd`.

---

## 🔐 Seguridad y Buenas Prácticas

- Asegurar permisos restrictivos:
```bash
sudo chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
```

- No publicar credenciales en repositorios públicos.

---

## ✅ Resultado Esperado

- Si todo funciona, recibirás un correo con el asunto `✔️ Backup OK - EQUIPO01`.
- Si falla el backup o el envío, recibirás un correo con `❌` indicando el problema.

---

## 📬 Sugerencias de Mejora

- Registrar eventos en `/var/log/backup.log`.
- Integración futura con Telegram, Slack o Discord.
- Automatización mediante cron o systemd.
- Verificación de integridad con checksum.

---

## 🧾 Conclusión

Hemos implementado un sistema robusto y funcional de alertas por correo para supervisar copias de seguridad. Esto permite un control proactivo del estado de los backups y facilita la gestión de errores o incidencias.
