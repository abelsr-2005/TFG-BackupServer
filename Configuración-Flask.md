## Visualización web del estado de los backups

Como complemento al sistema de copias de seguridad, se ha desarrollado una pequeña aplicación web con Flask que permite visualizar en tiempo real el estado de los backups almacenados en el servidor Debian. Esta aplicación es servida a través del servidor NGINX.

### Objetivo

El objetivo de esta interfaz es proporcionar una manera rápida y visual de verificar qué equipos tienen copias de seguridad actualizadas, cuántos archivos hay por cada uno, y cuándo fue el último backup.

### Tecnologías utilizadas

- Python 3 + Flask
- Servidor web NGINX
- Sistema operativo: Debian 12

---

### Proceso de instalación y configuración

#### 1. Instalar Flask

```bash
sudo apt update
sudo apt install python3-pip
pip3 install flask --break-system-packages
```

#### 2. Crear el script Flask

Guardar este contenido como `app.py`:

```python
from flask import Flask, render_template
import os
from datetime import datetime

app = Flask(__name__)

BACKUP_DIR = "/backup-imagenes"

@app.route("/")
def index():
    equipos = []
    for nombre_equipo in os.listdir(BACKUP_DIR):
        ruta_equipo = os.path.join(BACKUP_DIR, nombre_equipo)
        archivos = os.listdir(ruta_equipo)
        fechas = [os.path.getmtime(os.path.join(ruta_equipo, f)) for f in archivos] if archivos else []
        ultimo = datetime.fromtimestamp(max(fechas)).strftime("%d-%b-%Y %H:%M") if fechas else "--"
        equipos.append({
            "nombre": nombre_equipo,
            "ultimo": ultimo,
            "total": len(archivos)
        })
    return render_template("index.html", equipos=equipos)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
```

#### 3. Crear la plantilla HTML

Crea la carpeta `templates` dentro de `flask`, y crea un archivo `index.html` con este contenido.

``` python 
from flask import Flask, render_template, abort
import os
from datetime import datetime

app = Flask(__name__)

BACKUP_DIR = "/backup-imagenes"

@app.route("/")
def index():
    equipos = []
    for nombre_equipo in sorted(os.listdir(BACKUP_DIR)):
        ruta_equipo = os.path.join(BACKUP_DIR, nombre_equipo)
        archivos = os.listdir(ruta_equipo)
        fechas = [os.path.getmtime(os.path.join(ruta_equipo, f)) for f in archivos] if archivos else []
        ultimo = datetime.fromtimestamp(max(fechas)).strftime("%d-%b-%Y %H:%M") if fechas else "--"
        equipos.append({
            "nombre": nombre_equipo,
            "ultimo": ultimo,
            "total": len(archivos)
        })
    return render_template("index.html", equipos=equipos)

@app.route("/ver/<nombre_equipo>")
def ver_archivos(nombre_equipo):
    ruta_equipo = os.path.join(BACKUP_DIR, nombre_equipo)
    if not os.path.exists(ruta_equipo):
        abort(404)
    archivos = os.listdir(ruta_equipo)
    contenido = f"<h2>Archivos de backup de {nombre_equipo}</h2><ul>"
    for archivo in archivos:
        contenido += f"<li>{archivo}</li>"
    contenido += "</ul><a href='/'>⬅ Volver</a>"
    return contenido

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

---

## 🌐 Configuración de Nginx como Proxy Inverso para Flask
### 📁 1. Crear el archivo de configuración para Nginx

Primero, crea un nuevo archivo de configuración para tu aplicación Flask en Nginx:

```bash
sudo nano /etc/nginx/sites-available/flaskapp
```

Pega el siguiente contenido, ajustando `server_name` si tienes un dominio personalizado:

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
Este bloque configura Nginx para escuchar en el puerto 80 y reenviar todas las solicitudes al servidor Gunicorn que se ejecuta en `127.0.0.1:8000`.

### 🔗 2. Habilitar la configuración del sitio
```bash
sudo ln -s /etc/nginx/sites-available/flaskapp /etc/nginx/sites-enabled/
```
### ✅ 3. Verificar la configuración de Nginx

```bash
sudo nginx -t
```

Deberías ver:

```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### 🔄 4. Reiniciar Nginx

```bash
sudo systemctl restart nginx
```
### 🧪 Verificación Final

Abre tu navegador y accede a:

```
http://localhost
```

La aplicación Flask ya debe estar disponible públicamente mediante Nginx.








---

### Captura de pantalla

![Captura de pantalla de Flask en navegador](https://github.com/user-attachments/assets/37a941da-35ad-45e5-ba47-5eff0a787db7)

---

### Mejoras futuras

- Añadir autenticación básica
- Sistema de notificaciones por email o Telegram si no hay backups recientes

```
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

```
