# Proyecto TFG – Sistema de copias de seguridad con Clonezilla y servidor Debian

## 📌 Resumen

Este proyecto consiste en la implantación de un sistema de copias de seguridad para los equipos del laboratorio de la empresa Geotexan, utilizando Clonezilla Live y un servidor Debian 12 con SSH. Las copias generadas se almacenan en dicho servidor de forma centralizada y segura, permitiendo su restauración en caso de error crítico, mantenimiento o avería.

Como complemento, se ha desarrollado una pequeña interfaz web usando Flask y servida a través de NGINX, que permite visualizar de forma rápida el estado de los respaldos desde cualquier dispositivo dentro de la red local.

---

## 📚 Índice

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

## 1. 📘 Introducción

En el entorno empresarial actual, garantizar la continuidad del servicio ante posibles fallos de los sistemas es una necesidad crítica. Durante mi periodo de FCT en la empresa **Geotexan**, detecté que los equipos del laboratorio no contaban con un sistema de copias de seguridad. Esta carencia suponía un riesgo elevado de pérdida de datos y de tiempos prolongados de recuperación.

Este proyecto tiene como finalidad diseñar e implantar una solución de respaldo automatizada y centralizada, utilizando herramientas de software libre, que permita realizar y supervisar copias de seguridad de forma eficiente, segura y reutilizable.

## 2. 🎯 Objetivos

### Objetivo general

Desarrollar un sistema automatizado de copias de seguridad basado en Clonezilla, que almacene las imágenes en un servidor Debian accesible por SSH, permitiendo su monitorización mediante una interfaz web y generando alertas por correo.

### Objetivos específicos

- Instalar y configurar un servidor Debian como repositorio central de imágenes.
- Realizar copias de seguridad manuales con Clonezilla desde equipos cliente.
- Automatizar el proceso de respaldo con un script que detecte el equipo y nombre la imagen.
- Desarrollar una aplicación web con Flask que muestre el estado de los respaldos.
- Servir la interfaz mediante NGINX y garantizar el acceso desde la red local.
- Integrar un sistema de notificaciones por correo ante éxito o fallo del backup.
- Documentar todo el sistema de forma clara y modular.

## 3. 🧩 Análisis del entorno

La infraestructura analizada en Geotexan se compone de varios equipos de laboratorio con sistema operativo Windows, conectados a una red local sin soluciones de respaldo. No existía una política de copias ni un servidor destinado a almacenarlas. La pérdida de cualquier equipo requería reinstalación manual desde cero, lo cual generaba pérdidas de tiempo y riesgo de interrupción en la producción.

Para este proyecto se aprovechó una máquina virtual en un servidor con Proxmox, instalando Debian 12 como sistema operativo base para centralizar los respaldos.

## 4. 🛠️ Tecnologías utilizadas

| Tecnología         | Función                                                  |
|--------------------|----------------------------------------------------------|
| **Debian 12**       | Sistema operativo del servidor central                  |
| **Clonezilla Live** | Clonado de discos desde el equipo cliente               |
| **SSH / SFTP**      | Transferencia segura de imágenes al servidor            |
| **Flask (Python)**  | Generación de interfaz web para monitorización          |
| **NGINX**           | Servidor web para producción                            |
| **Bash**            | Automatización del proceso de copia                     |
| **msmtp + mailutils** | Envío de notificaciones por correo                    |

## 5. 🧱 Diseño del sistema

### Arquitectura general

```plaintext
[Equipo cliente] <-- Clonezilla Live --> [Servidor Debian]
                                         ├── SSH (recepción de imágenes)
                                         ├── /backup-imagenes/<nombre_equipo>/
                                         ├── Flask (visualización web)
                                         └── NGINX (servidor accesible en red)
```

### Organización de directorios en el servidor

```plaintext
/backup-imagenes/
├── EQUIPO01/
│   └── EQUIPO01_2024-05-01_14-30/
├── EQUIPO02/
│   └── EQUIPO02_2024-05-03_10-00/
└── ...
```

## 6. ⚙️ Implementación

- **Servidor Debian**: instalación limpia, activación de SSH, creación de usuario `backupuser` y directorio `/backup-imagenes`.
- **Clonezilla Live**: arranque desde USB en cada equipo, selección de disco `sda`, conexión por SSH al servidor.
- **Automatización**: script `mybackup.sh` que detecta el nombre del host, crea un directorio en el servidor y realiza el backup sin intervención.
- **Flask**: aplicación web que analiza el contenido de `/backup-imagenes` y muestra tabla con nombre del equipo, fecha del último backup y número de archivos.
- **NGINX**: configurado como proxy inverso para servir Flask desde el puerto 80.
- **Notificaciones por correo**: uso de `msmtp` y `mailutils` para avisar por email si la copia ha sido correcta o ha fallado.

## 7. ✅ Pruebas realizadas

- **Backup manual desde Clonezilla**: pruebas en varios equipos, comprobación de transferencia y estructura de carpetas.
- **Script automático**: prueba con diferentes hosts, verificación de que el nombre y fecha se generan correctamente.
- **Restauración**: recuperación de un equipo a partir de una imagen almacenada.
- **Flask**: pruebas con diferentes navegadores desde red local.
- **Correo**: recepción de alertas en Gmail tras completar copia y en caso de error simulado.

## 8. 🌐 Visualización web con Flask

Se ha desarrollado una interfaz web ligera con Flask que muestra el estado de los backups. Permite consultar desde cualquier dispositivo de la red:

- El nombre del equipo.
- La fecha del último respaldo.
- La cantidad de archivos generados.

Esta interfaz se sirve con NGINX para facilitar el acceso desde navegador, y resulta ideal para el personal técnico que quiera monitorizar el sistema sin necesidad de entrar por terminal al servidor.

## 9. 📊 Resultados y mejoras

### Resultados alcanzados

- Sistema de backup funcional, probado y replicable.
- Monitorización accesible y clara.
- Automatización total del proceso de copias.
- Sistema de alertas por correo implementado con éxito.
- Documentación detallada por módulos.

### Mejoras futuras

- Añadir login básico o autenticación a la interfaz web.
- Incorporar PXE para arranque automático de Clonezilla.
- Cifrado de las imágenes almacenadas.
- Histórico y estadísticas de backups.

## 10. 🧠 Conclusiones

El proyecto ha permitido implantar una solución real a un problema cotidiano en muchas empresas: la falta de copias de seguridad. Gracias al uso de software libre y conocimientos adquiridos en el ciclo ASIR, se ha creado un sistema robusto, documentado y escalable. Ha supuesto una mejora real en la infraestructura de la empresa y ha servido como caso práctico de administración de sistemas.

## 11. 📎 Anexos

| Archivo                       | Descripción                                        |
|------------------------------|----------------------------------------------------|
| `Configuracion-Debian.md`    | Instalación y preparación del servidor             |
| `Configuracion-Clonezilla.md`| Procedimiento de backup manual con Clonezilla      |
| `Script-Clonezilla.md`       | Script automático de copia                         |
| `Configuracion-Flask.md`     | Interfaz web para ver el estado de los equipos     |
| `Servicio-Correo-Alertas.md` | Configuración de sistema de alertas por correo     |
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
