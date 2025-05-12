# Configuración del servidor Debian y preparación del entorno

## 1. Instalación de Debian en el servidor

Asegúrate de tener una instalación limpia de Debian en el servidor. Si ya tienes Debian instalado, puedes omitir este paso.

## 2. Creación de un usuario para las copias de seguridad

Es recomendable crear un usuario específico para gestionar las copias de seguridad, lo que mejorará la seguridad y organización del sistema.

```bash
sudo adduser backupuser
sudo usermod -aG sudo backupuser
```

## 3. Configuración de SSH para acceso remoto

### Instalación y configuración de SSH

Si el servidor Debian no tiene instalado el servicio SSH, instala y configura SSH:

```bash
sudo apt update
sudo apt install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh
```

### Configuración de acceso SSH sin contraseña (usando claves públicas)

1. En tu máquina local, genera un par de claves SSH si no lo tienes ya:

```bash
ssh-keygen -t rsa -b 4096
```

2. Copia la clave pública al servidor Debian:

```bash
ssh-copy-id backupuser@ip_del_servidor
```

3. Verifica que puedas acceder al servidor sin necesidad de contraseña:

```bash
ssh backupuser@ip_del_servidor
```

## 4. Crear la estructura de directorios para almacenar las copias de seguridad

Define la carpeta donde se almacenarán las imágenes de las copias de seguridad y establece los permisos adecuados.

```bash
sudo mkdir -p /backup-imagenes
sudo chown backupuser:backupuser /backup-imagenes
sudo chmod 700 /backup-imagenes
```

## 5. Verificación del espacio disponible

Antes de proceder, asegúrate de que el servidor tiene suficiente espacio para almacenar las copias de seguridad.

```bash
df -h
```

## 6. Comprobación de la conectividad y permisos

Verifica que puedas conectarte al servidor Debian desde los equipos del laboratorio y que los permisos de escritura estén correctos.

```bash
ssh backupuser@ip_del_servidor
touch /backup-imagenes/test_file
ls -l /backup-imagenes
```

---

Con estos pasos, tendrás configurado un servidor Debian listo para recibir las copias de seguridad de los equipos del laboratorio mediante Clonezilla.
