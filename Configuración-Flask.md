# 🚀 Despliegue de Aplicación Flask con Gunicorn, Nginx y systemd

## 📁 Estructura del Proyecto

Tu proyecto se encuentra en:

```
/home/backupuser/flask/
```

Con la siguiente estructura:

```
flask/
├── app.py
├── venv/
└── templates/
    └── index.html
```

- `app.py`: Archivo principal de tu aplicación Flask.
- `venv/`: Entorno virtual de Python.
- `templates/`: Carpeta que contiene las plantillas HTML de tu aplicación.

---

## 🛠️ 1. Crear y Activar el Entorno Virtual

Desde el directorio de tu proyecto:

```bash
cd /home/backupuser/flask
python3 -m venv venv
source venv/bin/activate
```

Instala Flask y Gunicorn:

```bash
pip install flask gunicorn
```

---

## 📝 2. Crear la Aplicación Flask

Crea el archivo `app.py` con el siguiente contenido:

```python
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")
```

Crea la carpeta de plantillas y un archivo HTML básico:

```bash
mkdir templates
nano templates/index.html
```

Contenido de `index.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Aplicación Flask</title>
</head>
<body>
    <h1>¡Hola, mundo!</h1>
</body>
</html>
```

---

## 🔧 3. Crear el Servicio systemd para Gunicorn

Crea el archivo de servicio:

```bash
sudo nano /etc/systemd/system/flaskapp.service
```

Contenido:

```ini
[Unit]
Description=Gunicorn instance to serve Flask application
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

Recarga systemd y habilita el servicio:

```bash
sudo systemctl daemon-reload
sudo systemctl start flaskapp
sudo systemctl enable flaskapp
```

Verifica el estado del servicio:

```bash
sudo systemctl status flaskapp
```

---

## 🌐 4. Configurar Nginx como Proxy Inverso

Crea un archivo de configuración para Nginx:

```bash
sudo nano /etc/nginx/sites-available/flaskapp
```

Contenido:

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

Habilita la configuración y reinicia Nginx:

```bash
sudo ln -s /etc/nginx/sites-available/flaskapp /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx
```

---

## ✅ 5. Verificar el Despliegue

Abre tu navegador y accede a:

```
http://localhost
```

Deberías ver la página con el mensaje "¡Hola, mundo!".

---

## 🛡️ 6. Recomendaciones de Seguridad

- **Firewall**: Asegúrate de que solo los puertos necesarios estén abiertos (por ejemplo, 80 para HTTP).
- **HTTPS**: Considera configurar HTTPS utilizando Let's Encrypt para cifrar las comunicaciones.
- **Permisos**: Verifica que los archivos y directorios tengan los permisos adecuados para evitar accesos no autorizados.

---

## 📄 7. Archivos de Configuración

### `app.py`

```python
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")
```

### `/etc/systemd/system/flaskapp.service`

```ini
[Unit]
Description=Gunicorn instance to serve Flask application
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

### `/etc/nginx/sites-available/flaskapp`

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

---

# ✅ ¡Listo!

Tu aplicación Flask ahora está desplegada con Gunicorn y Nginx, funcionando como servicio y accesible desde el navegador.
