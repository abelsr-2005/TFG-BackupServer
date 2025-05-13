# Configuración de alertas por correo para copias de seguridad en Debian

Este documento explica cómo configurar el envío automático de correos electrónicos desde un servidor Debian, con el objetivo de recibir notificaciones sobre el estado de las copias de seguridad realizadas con Clonezilla.

## ✅ Objetivo

- Notificar por correo si una copia de seguridad se realiza correctamente.
- Alertar si se detecta un fallo en el proceso.
- Integrar notificaciones en los scripts del sistema.

---

## 📬 Configuración con `msmtp` y `mailutils`

### 1. Instalar los paquetes necesarios

```bash
sudo apt update
sudo apt install msmtp msmtp-mta mailutils
```

---

### 2. Crear archivo de configuración `~/.msmtprc`

```bash
nano ~/.msmtprc
```

Ejemplo de configuración para Gmail:

```ini
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

account        gmail
host           smtp.gmail.com
port           587
from           TU_CORREO@gmail.com
user           TU_CORREO@gmail.com
password       CONTRASEÑA_APP

account default : gmail
```

> 🔐 Usa una contraseña de aplicación si usas Gmail (desde tu cuenta en Seguridad > Contraseñas de aplicación).

Asegura los permisos del archivo:

```bash
chmod 600 ~/.msmtprc
```

---

### 3. Prueba de envío

```bash
echo "Mensaje de prueba del sistema de copias" | mail -s "Backup OK" tu_correo@gmail.com
```

---

### 4. Integrar en el script de backup

En tu script `mybackup.sh`, añade al final:

```bash
if [ $? -eq 0 ]; then
    echo "La copia de seguridad del equipo $HOSTNAME ha finalizado correctamente." | mail -s "Backup OK: $HOSTNAME" tu_correo@tudominio.com
else
    echo "La copia de seguridad del equipo $HOSTNAME ha fallado. Revisa los registros." | mail -s "⚠️ Backup FALLIDO: $HOSTNAME" tu_correo@tudominio.com
fi
```

---

## 🔧 Consideraciones adicionales

- Puedes cambiar el proveedor SMTP (ej. Outlook, ProtonMail) adaptando los valores de `host`, `port`, etc.
- Revisa el archivo de log `~/.msmtp.log` si algo falla.
- Evita hardcodear contraseñas en entornos de producción (usa variables de entorno).

---

## 🧩 Futuras ampliaciones

- Envío de alertas con Telegram o Slack.
- Reportes programados diarios o semanales.
- Panel de administración con estado de los backups.

---

Este sistema permite a los administradores recibir información puntual del estado de sus respaldos, mejorando la supervisión y capacidad de respuesta ante fallos.
