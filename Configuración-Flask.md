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

Dentro de una carpeta `templates`, crea un archivo `index.html` con contenido como el que aparece en la imagen capturada.

#### 4. Configurar NGINX

Instala NGINX

``` bash
sudo apt install nginx
```

Configura NGINX para redirigir a Flask:

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Reinicia NGINX:

```bash
sudo systemctl restart nginx
```

---

### Captura de pantalla

![Captura de pantalla de Flask en navegador](https://github.com/user-attachments/assets/37a941da-35ad-45e5-ba47-5eff0a787db7)

---

### Mejoras futuras

- Añadir autenticación básica
- Sistema de notificaciones por email o Telegram si no hay backups recientes
