# Proyecto TFG – Sistema de copias de seguridad con Clonezilla y servidor Debian

# 📌 Resumen

Este proyecto consiste en la implantación de un sistema de copias de seguridad para los equipos del laboratorio de la empresa Geotexan, utilizando Clonezilla Live y un servidor Debian 12 con SSH. Las copias generadas se almacenan en dicho servidor de forma centralizada y segura, permitiendo su restauración en caso de error crítico, mantenimiento o avería.

Como complemento, se ha desarrollado una pequeña interfaz web usando Flask y servida a través de NGINX, que permite visualizar de forma rápida el estado de los respaldos desde cualquier dispositivo dentro de la red local.

---

# 📚 Índice

1. [Introducción](#1-introducción)  
2. [Objetivos](#2-objetivos)  
3. [Análisis del entorno](#3-análisis-del-entorno)  
4. [Tecnologías utilizadas](#4-tecnologías-utilizadas)  
5. [Diseño del sistema](#5-diseño-del-sistema)  
6. [Implementación](#6-implementación)  
7. [Pruebas realizadas](#7-pruebas-realizadas)  
8. [Visualización web con Flask](#8-visualización-web-con-flask)  
9. [Resultados y mejoras](#9-resultados-y-mejoras)  
10. [Conclusiones](#10-conclusiones)  
11. [Anexos](#11-anexos)

---

# 1. 📘 Introducción

Durante el módulo de FCT en la empresa Geotexan se detectó que los equipos del laboratorio no contaban con un sistema de copias de seguridad. Esto suponía un riesgo elevado de pérdida de datos y tiempos largos de recuperación ante fallos.

Este proyecto desarrolla una solución completa de respaldo automatizado basada en Clonezilla y un servidor Debian, monitorizable desde una interfaz web y con alertas por correo. Todo con tecnologías libres.

---

# 2. 🎯 Objetivos

**Objetivo general**  
Implantar un sistema automatizado de copias de seguridad en red con herramientas libres y monitorización vía web.

**Objetivos específicos**  
- Configurar un servidor Debian 12 como almacenamiento central.
- Realizar backups con Clonezilla desde equipos cliente.
- Automatizar el proceso mediante scripting.
- Crear una interfaz web con Flask.
- Servir la web localmente con NGINX.
- Enviar alertas por correo con msmtp.
- Documentar todo el proceso.

---

# 3. 🧩 Análisis del entorno

- Equipos con Windows sin backup.
- Red local básica sin VLAN ni DHCP avanzado.
- Necesidad de respaldo confiable, automatizado y restaurable.

Se utilizó una máquina virtual en Proxmox para montar el servidor Debian central.

---

# 4. 🛠️ Tecnologías utilizadas

| Tecnología        | Función                                               |
|-------------------|--------------------------------------------------------|
| Debian 12         | Sistema base del servidor                             |
| Clonezilla Live   | Creación de imágenes de disco                         |
| SSH / SFTP        | Transferencia segura al servidor                      |
| Flask + Python    | Interfaz web para ver el estado de los backups        |
| NGINX             | Servidor web para producción                          |
| Bash              | Automatización de procesos                            |
| msmtp + mailutils | Notificaciones por correo electrónico                 |

---

# 5. 🧱 Diseño del sistema

```plaintext
[Equipo cliente] <-- Clonezilla Live --> [Servidor Debian]
                                         ├── SSH (backup)
                                         ├── /backup-imagenes/
                                         ├── Flask (web)
                                         └── NGINX (puerto 80)
```

```plaintext
/backup-imagenes/
├── EQUIPO01/
│   └── EQUIPO01_2024-05-01_14-30/
└── EQUIPO02/
    └── EQUIPO02_2024-05-03_10-00/
```

---

# 6. ⚙️ Implementación

- 🔧 Debian: SSH, usuario `backupuser`, permisos, carpetas.
- 💻 Clonezilla: USB, conexión por SSH y backup manual.
- ⚙️ Script automático: genera nombre, crea carpeta y ejecuta backup.
- 🌍 Flask: muestra backups por equipo, fecha y archivos.
- 🌐 NGINX: proxy inverso para exponer Flask desde el puerto 80.
- 📬 Alertas: correo enviado tras cada backup.

---

# 7. ✅ Pruebas realizadas

- Backup manual desde Clonezilla.
- Script automático testado con múltiples equipos.
- Restauración de imagen.
- Flask accesible desde LAN.
- Correos recibidos tras backup OK/fallo.

---

# 8. 🌐 Visualización web con Flask

Aplicación en Python + Flask que analiza `/backup-imagenes` y muestra:

- ✅ Nombre del equipo.
- 📅 Fecha del último backup.
- 🗂️ Número de archivos respaldados.

Diseñada para usarse desde navegador, accesible para técnicos sin necesidad de usar terminal.

---

# 9. 📊 Resultados y mejoras

**Resultados**  
- Sistema probado y funcional.
- Copias automatizadas por equipo.
- Visualización web efectiva.
- Sistema de alertas incorporado.

**Mejoras futuras**  
- Añadir login básico a la interfaz web.
- Arranque PXE automático sin USB.
- Cifrado de imágenes.
- Historial de respaldos y estadísticas.

---

# 10. 🧠 Conclusiones

Este proyecto ha resuelto una necesidad real con herramientas libres, aplicando conocimientos de ASIR en un entorno real. Se ha creado una solución escalable, reutilizable y segura que mejora la infraestructura TI de la empresa.

---

# 11. 📎 Anexos

| Archivo                       | Descripción                                        |
|------------------------------|----------------------------------------------------|
| `Configuracion-Debian.md`    | Instalación del servidor Debian y configuración SSH |
| `Configuracion-Clonezilla.md`| Backup manual desde Clonezilla                     |
| `Script-Clonezilla.md`       | Script automatizado de copia                       |
| `Configuracion-Flask.md`     | Interfaz web con Flask y NGINX                     |
| `Servicio-Correo-Alertas.md` | Sistema de notificación por correo                 |

---

<p align="center">
  <strong>Abel Sánchez Ramos</strong>  
  · <em>CFGS Administración de Sistemas Informáticos en Red</em>  
  <br>
  <strong>IES La Marisma – Proyecto Integrado 2024/2025</strong>
  <br><br>
  🛠️ Tecnología libre · 📦 Respaldos automatizados · 🌐 Infraestructura real  
</p>

<p align="center">
  <sub>Repositorio documentado y estructurado como parte del módulo FCT. Proyecto técnico orientado a la resolución de un problema real en entorno empresarial.</sub>
</p>
