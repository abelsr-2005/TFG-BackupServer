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

## 1. Introducción

En el laboratorio de la empresa se utilizan varios equipos informáticos esenciales para el trabajo diario. Sin embargo, hasta ahora no se contaba con un sistema de copias de seguridad implementado, lo que suponía un riesgo importante en caso de fallo del sistema o pérdida de datos.

Con el objetivo de solventar este problema, se ha diseñado e implementado un sistema de respaldo basado en software libre que garantiza que todos los equipos tengan una copia de seguridad actualizada accesible en caso de necesidad.

---

## 2. Objetivos

- Implementar un sistema de copias de seguridad fiable, reutilizable y mantenible.
- Automatizar el proceso de backup usando Clonezilla Live.
- Centralizar las copias en un servidor Debian accesible por red mediante SSH.
- Crear una interfaz web con Flask para visualizar el estado de los backups.
- Documentar el proceso completo de manera clara y técnica.

---

## 3. Análisis del entorno

- **Equipos cliente**: sistemas Windows, uso frecuente y crítico.
- **Red local**: conectividad 1 Gbps, sin VLAN configuradas.
- **Servidor**: máquina virtual sobre Proxmox con Debian 12.
- **Requisitos**: realizar imágenes completas de los discos de los equipos del laboratorio y almacenarlas de forma centralizada.

---

## 4. Tecnologías utilizadas

- **Clonezilla Live** – para clonar discos completos.
- **Debian 12** – como servidor de almacenamiento de backups.
- **SSH/SFTP** – protocolo seguro para la transferencia de datos.
- **Python 3 + Flask** – para crear la interfaz web.
- **NGINX** – para servir la aplicación web en entorno de producción.
- **Bash** – para automatización de procesos básicos.

---

## 5. Diseño del sistema

```plaintext
[Equipo cliente] <-- Clonezilla (USB) --> [Servidor Debian con SSH + Flask + NGINX]
```

La estructura de almacenamiento de backups es sencilla pero eficaz:

```plaintext
/backup-imagenes/
├── equipo1/
├── equipo2/
└── ...
```

---

## 6. Implementación

### Parte 1: Configuración del servidor Debian

- Instalación limpia de Debian 12.
- Creación del usuario `backupuser` con permisos limitados.
- Instalación y configuración del servicio SSH.
- Creación de la carpeta `/backup-imagenes` con permisos adecuados.

### Parte 2: Uso de Clonezilla Live

- Arranque por USB de los equipos cliente.
- Conexión mediante SSH al servidor.
- Selección del disco origen y destino.
- Generación de imagen y verificación.

---

## 7. Pruebas realizadas

- Se ha probado la copia y restauración completa de un equipo.
- Verificada la integridad de las imágenes mediante acceso manual al directorio de backup.
- Restauración funcional del sistema operativo en el mismo y otro equipo compatible.

---

## 8. Visualización web con Flask

Como funcionalidad adicional, se ha desarrollado una pequeña aplicación web en Python utilizando el framework Flask. Esta aplicación recorre el directorio `/backup-imagenes` y muestra, de forma clara y accesible desde el navegador, el estado de cada equipo: nombre, fecha del último backup y número total de archivos almacenados.

El sistema corre sobre NGINX configurado como proxy inverso, lo que permite ofrecer la aplicación en producción desde el puerto 80. Se trata de una mejora clave para el seguimiento visual del sistema de backups, facilitando su supervisión por parte del personal técnico o de mantenimiento.

---

## 9. 📋 Planificación de tareas

A continuación se detallan las tareas realizadas durante el desarrollo del proyecto, junto con una estimación de tiempo invertido:

| Tarea                                    | Descripción técnica                                               |
|------------------------------------------|-------------------------------------------------------------------|
| Instalación de Debian                    | Instalación y configuración básica de red y acceso SSH            |
| Configuración de usuario y permisos      | Creación del usuario `backupuser` y estructura de carpetas        |
| Configuración de Clonezilla              | Preparación de USB, arranque y pruebas de copia de equipos        |
| Transferencia por SSH                    | Validación de acceso remoto seguro y pruebas de transferencia     |
| Verificación de copias                   | Comprobación de integridad de las imágenes                        |
| Desarrollo interfaz Flask                | Script Python que analiza directorios y genera la tabla HTML      |
| Configuración NGINX                      | Proxy inverso hacia Flask, apertura de puertos, pruebas           |
| Redacción documentación y memoria        | Escritura en Markdown, organización de contenidos y limpieza      |
| Capturas, anexos, pruebas finales        | Toma de imágenes, organización del proyecto, pruebas de entrega   |


## 9. Resultados y mejoras

### Resultados

- Sistema funcional desplegado y probado en entorno real.
- Documentación clara del proceso técnico.
- Visualización web que aporta valor añadido.

### Mejoras futuras

- Integración de sistema de alertas por correo o Telegram si no se detecta backup en X días.
- Interfaz de restauración desde la web (requiere control de privilegios).
- Automatización mediante PXE para arrancar Clonezilla por red.

---

## 10. Conclusiones

Este proyecto ha permitido resolver una necesidad real del entorno de prácticas: dotar a los equipos de laboratorio de un sistema de respaldo automatizado, centralizado y de rápida restauración. A través del uso de herramientas libres, se ha conseguido implementar una solución robusta, documentada y con capacidad de ampliación futura.

---

## 11. Anexos

| Documento                        | Descripción                                       |
|----------------------------------|---------------------------------------------------|
| `Configuración-Debian.md`        | Configuración inicial del servidor Debian         |
| `Configuración-Clonezilla.md`    | Procedimiento para hacer backups manuales         |
| `Configuración-Flask.md`         | Desarrollo de la interfaz de monitorización       |
| `Script-Clonezilla.md`           | Script de backup automático desde Clonezilla      |
| `Servicio-Correo-Alertas.md`     | Servicio de notificación de resultados por correo |

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
