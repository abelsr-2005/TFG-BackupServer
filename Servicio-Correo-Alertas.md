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
