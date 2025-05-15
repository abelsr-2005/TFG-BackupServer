# 🌐 Visualización web del estado de los backups

Como complemento al sistema de copias de seguridad, se ha desarrollado una sencilla aplicación web con **Flask** que permite visualizar en tiempo real el estado de los backups almacenados en el servidor Debian. Esta aplicación se publica utilizando el servidor **NGINX**.

---

## 🎯 Objetivo

El propósito de esta interfaz es ofrecer una manera **rápida y visual** de comprobar qué equipos tienen copias de seguridad actualizadas, cuántos archivos contiene cada backup, y cuándo fue la última copia realizada.

---

## 🛠️ Tecnologías utilizadas

- 🐍 Python 3 + Flask  
- 🌐 Servidor web: NGINX  
- 🧱 Sistema operativo: Debian 12

---

## ⚙️ Proceso de instalación y configuración

### 1️⃣ Instalar Flask

```bash
sudo apt update
sudo apt install python3-pip
pip3 install flask --break-system-packages
```

---

### 2️⃣ Crear el script principal con Flask

Guarda el siguiente contenido como `app.py`:

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

---

### 3️⃣ Crear la plantilla HTML

Crea la carpeta `templates` dentro del directorio del proyecto y dentro de ella, crea un archivo `index.html`.

También puedes usar el siguiente ejemplo mejorado con una ruta para ver archivos por equipo:

```python
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

## 🚀 Configuración de NGINX como proxy inverso para Flask

### 🐍 1. Crear entorno virtual e instalar dependencias

```bash
cd /home/backupuser/flask
python3 -m venv venv
./venv/bin/pip install flask gunicorn
```

Guardar dependencias en un archivo (opcional):

```bash
./venv/bin/pip freeze > requirements.txt
```

---

### 🔥 2. Probar Gunicorn manualmente

```bash
cd /home/backupuser/flask
./venv/bin/gunicorn --bind 127.0.0.1:8000 app:app
```

Abre el navegador en:  
[http://localhost:8000](http://localhost:8000)

Presiona `Ctrl+C` para detener.

---

### ⚙️ 3. Crear un servicio systemd para Gunicorn

Archivo: `/etc/systemd/system/flaskapp.service`

```ini
[Unit]
Description=Flask App with Gunicorn
After=network.target

[Service]
User=backupuser
Group=www-data
WorkingDirectory=/home/backupuser/flask
Environment="PATH=/home/backupuser/flask/venv/bin"
ExecStart=/home/backupuser/flask/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:8000 app:app

[Install]
WantedBy=multi-user.target
```

Habilitar y arrancar el servicio:

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl start flaskapp
sudo systemctl status flaskapp
```

---

### 🌐 4. Configurar NGINX como proxy inverso

Archivo: `/etc/nginx/sites-available/flaskapp`

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

Activar el sitio y reiniciar NGINX:

```bash
sudo ln -s /etc/nginx/sites-available/flaskapp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🖼️ Capturas de pantalla

### 💻 Interfaz de Flask antes de NGINX + Gunicorn

_Se muestra utilizando el puerto 5000 (servidor nativo de Python/Flask)._

![Captura de pantalla de Flask en navegador](https://github.com/user-attachments/assets/37a941da-35ad-45e5-ba47-5eff0a787db7)

---

### 🚀 Flask desplegado con NGINX + Gunicorn

_Interfaz accediendo por el puerto 80 gracias a la configuración proxy._

![NGINX y gunicorn](https://github.com/user-attachments/assets/d85922ed-5706-4b11-a3cc-7874b2b000d9)

---

## 🔮 Mejoras futuras

- 🔐 Añadir autenticación básica
- 📬 Integración con notificaciones por email o Telegram si no hay backups recientes
