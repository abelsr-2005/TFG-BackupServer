from flask import Flask, render_template, abort
import os
from datetime import datetime

app = Flask(__name__, static_folder='/home/userbackups/bak', static_url_path='/static')
BACKUP_DIR = '/home/userbackups/bak'

@app.route('/')
def index():
    equipos = []
    for nombre in sorted(os.listdir(BACKUP_DIR)):
        ruta = os.path.join(BACKUP_DIR, nombre)
        if os.path.isdir(ruta):
            archivos = os.listdir(ruta)
            total = len(archivos)
            ultima_fecha = '--'
            if archivos:
                paths = [os.path.join(ruta, f) for f in archivos if os.path.isfile(os.path.join(ruta, f))]
                if paths:
                    ultima_fecha = max(os.path.getmtime(p) for p in paths)
                    ultima_fecha = datetime.fromtimestamp(ultima_fecha).strftime('%d-%b-%Y %H:%M')
            equipos.append({
                'nombre': nombre,
                'total': total,
                'ultima_fecha': ultima_fecha
            })
    return render_template('index.html', equipos=equipos)

@app.route('/ver/<equipo>')
def ver_equipo(equipo):
    ruta_equipo = os.path.join(BACKUP_DIR, equipo)
    if not os.path.isdir(ruta_equipo):
        return abort(404)
    archivos = os.listdir(ruta_equipo)
    archivos_info = []
    for f in archivos:
        path = os.path.join(ruta_equipo, f)
        if os.path.isfile(path):
            fecha = datetime.fromtimestamp(os.path.getmtime(path)).strftime('%d-%b-%Y %H:%M')
            archivos_info.append({'nombre': f, 'fecha': fecha})
    return render_template('archivos.html', equipo=equipo, archivos=archivos_info)
