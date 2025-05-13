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

Durante el desarrollo del módulo de Formación en Centros de Trabajo (FCT) en la empresa **Geotexan**, se identificó una carencia crítica en la infraestructura informática del laboratorio: **la ausencia de un sistema de copias de seguridad**. Esta situación implicaba un alto riesgo de pérdida de datos ante posibles fallos, así como tiempos prolongados de recuperación en caso de avería o restauración de sistemas.

Ante este escenario, se planteó como objetivo implementar una solución integral de respaldo automatizado que permitiera **garantizar la disponibilidad, integridad y recuperación de los equipos del laboratorio**. La solución diseñada se basa en herramientas de software libre y combina el uso de **Clonezilla Live para la creación de imágenes de disco**, un **servidor Debian 12 para el almacenamiento centralizado de copias**, y una **interfaz web desarrollada con Flask** que permite supervisar de forma visual el estado de los respaldos. Además, se integró un sistema de notificaciones por correo que informa sobre el resultado de cada proceso de copia.

Este proyecto busca no solo resolver una necesidad real de la empresa, sino también servir como ejemplo práctico y aplicable de automatización y administración de sistemas en entornos productivos.


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

## 3. 🧩 Análisis del entorno

En el entorno de trabajo del laboratorio de la empresa **Geotexan**, los equipos informáticos operaban bajo sistemas Windows sin contar con ningún sistema de copias de seguridad implantado. Esta situación suponía un riesgo significativo de pérdida de datos, así como una alta dependencia de procedimientos manuales en caso de fallo, avería o reinstalación del sistema operativo.

La red local existente era funcional pero básica, sin segmentación mediante VLANs ni un sistema de asignación dinámica de direcciones avanzado (DHCP). Esto limitaba las posibilidades de gestión y automatización del entorno.

Como parte del proyecto, se aprovechó una **máquina virtualizada en Hyper-V alojada en un servidor Windows Server** ya disponible en la infraestructura de la empresa, sobre la que se desplegó un sistema **Debian 12**. Este servidor actuaría como **repositorio centralizado de las copias de seguridad**, accesible desde cualquier equipo del laboratorio mediante protocolo SSH. Esta decisión permitió reducir costes y aprovechar los recursos ya existentes en la organización.


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

El diseño del sistema se ha planteado con una arquitectura sencilla, modular y eficiente, basada completamente en software libre. El objetivo ha sido permitir que cualquier equipo del laboratorio pueda realizar una copia de seguridad a través de Clonezilla, almacenando la imagen generada en un servidor central Debian.

### 📐 Esquema general del sistema

```plaintext
[Equipo cliente] <-- Clonezilla Live --> [Servidor Debian]
                                         ├── SSH (backup)
                                         ├── /backup-imagenes/
                                         ├── Flask (web)
                                         └── NGINX (puerto 80)
```

El flujo del sistema es el siguiente:

1. El equipo cliente se arranca con Clonezilla Live desde USB.
2. Se conecta por SSH al servidor Debian configurado como destino.
3. Se genera una imagen del disco y se transfiere automáticamente.
4. La imagen se guarda en una carpeta identificada por el nombre del equipo.
5. La interfaz Flask consulta el estado de estas carpetas para mostrar la información.

### 🗂️ Estructura de almacenamiento en el servidor
Las imágenes se organizan en subdirectorios dentro de /backup-imagenes, uno por cada equipo, utilizando el nombre del host y la fecha como identificador de la copia:
```plaintext
/backup-imagenes/
├── EQUIPO01/
│   └── EQUIPO01_2024-05-01_14-30/
└── EQUIPO02/
    └── EQUIPO02_2024-05-03_10-00/
```

Esta estructura permite localizar rápidamente las copias por equipo y fecha, facilitando la restauración en caso necesario, así como la visualización desde la interfaz web.

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
