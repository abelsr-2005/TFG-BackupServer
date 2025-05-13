# Proyecto TFG – Sistema de copias de seguridad con Clonezilla y servidor Debian

## 📌 Resumen

Este proyecto consiste en la implantación de un sistema de copias de seguridad para los equipos del laboratorio de la empresa Geotexan, utilizando Clonezilla Live y un servidor Debian 12 con SSH. Las copias generadas se almacenan en dicho servidor de forma centralizada y segura, permitiendo su restauración en caso de error crítico, mantenimiento o avería.

Además, se ha desarrollado una interfaz web con Flask servida a través de NGINX para mostrar el estado de los backups. También se ha creado un script de automatización para que Clonezilla realice las copias de seguridad sin intervención del usuario.

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
9. [Automatización con Clonezilla](#9-automatización-con-clonezilla)  
10. [Resultados y mejoras](#10-resultados-y-mejoras)  
11. [Conclusiones](#11-conclusiones)  
12. [Planificación de tareas](#12-planificación-de-tareas)  
13. [Anexos](#13-anexos)

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
- Desarrollar un script que automatice completamente el proceso de respaldo.
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
- **Bash** – para automatización de procesos con script.

---

## 5. Diseño del sistema

El diseño de este sistema de copias de seguridad está orientado a la simplicidad, robustez y escalabilidad, aprovechando herramientas libres y ampliamente utilizadas en entornos profesionales. El sistema se compone de tres elementos principales:

- Equipos cliente (laboratorio): Son los equipos que se desea proteger, cada uno arrancado temporalmente con Clonezilla Live desde un USB (o en un futuro, mediante PXE).
- Clonezilla Live: Actúa como entorno de clonado en vivo, sin necesidad de instalar software en los equipos cliente.
- Servidor Debian: Almacena todas las imágenes de respaldo. Está configurado con un servicio SSH para recibir las copias de seguridad y sirve una interfaz web con Flask y NGINX.

```plaintext
[Equipo Cliente] <-- Clonezilla Live (USB) --> [Servidor Debian 12]
                                          ↳ SSH (transferencia de imágenes)
                                          ↳ Flask (visualización de backups)
                                          ↳ NGINX (servidor web)

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
- Se ha verificado que la interfaz web muestra correctamente los backups y que el script automatizado ejecuta el proceso completo sin intervención.

---

## 8. Visualización web con Flask
Como parte del proyecto, se ha desarrollado una interfaz web ligera utilizando Flask, un microframework en Python, con el objetivo de facilitar el monitoreo del estado de las copias de seguridad. Esta aplicación permite que cualquier usuario de la red local pueda acceder desde un navegador web y consultar de forma clara y rápida la siguiente información:

- Nombre del equipo respaldado.
- Fecha y hora del último backup detectado.
- Número total de archivos almacenados en el directorio correspondiente.

### Arquitectura y funcionamiento

La aplicación está desarrollada en Python 3, usando Flask para la gestión de rutas y plantillas. El servidor analiza en tiempo real el contenido del directorio /backup-imagenes del servidor Debian, donde se almacenan todas las copias de seguridad. Cada subdirectorio representa un equipo distinto, y la aplicación escanea la fecha de modificación de los archivos dentro de cada carpeta para determinar la última actividad.

El diseño se apoya en una plantilla HTML (index.html) alojada en la carpeta templates, que genera dinámicamente una tabla con todos los equipos detectados. La aplicación es muy ligera, rápida y no requiere base de datos ni dependencias adicionales.

### Beneficios
- Accesibilidad: Cualquier usuario puede consultar el estado de los backups desde un navegador web.
- Transparencia: Proporciona una visión clara del estado actual del sistema.
- Eficiencia: Evita tener que acceder manualmente al servidor para verificar las copias.
- Escalabilidad: La interfaz puede mejorarse fácilmente añadiendo filtros, notificaciones o gráficos

---

## 9. Automatización con Clonezilla

Para evitar la intervención manual, se ha creado un script `mybackup.sh` que:

- Detecta automáticamente el nombre del equipo.
- Conecta por SSH al servidor y crea la carpeta correspondiente.
- Realiza la copia del disco `sda` con nombre `EQUIPO_FECHA`.
- Apaga el equipo al finalizar.

Más información y código completo en `Script-Clonezilla.md`.

---

## 10. Resultados y mejoras

### Resultados

- Sistema funcional desplegado y probado en entorno real.
- Documentación clara del proceso técnico.
- Visualización web y automatización del respaldo correctamente implementadas.

### Mejoras futuras

- Alertas automáticas por correo o Telegram si no hay backups recientes.
- Restauración desde la interfaz web.
- Arranque PXE sin necesidad de USB.

---

## 11. Conclusiones

Este proyecto ha permitido resolver una necesidad real del entorno de prácticas: dotar a los equipos de laboratorio de un sistema de respaldo automatizado, centralizado y de rápida restauración. A través del uso de herramientas libres, se ha conseguido implementar una solución robusta, documentada y con capacidad de ampliación futura.

---

## 12. Planificación de tareas

| Tarea                                    | Descripción técnica                                               |
|------------------------------------------|-------------------------------------------------------------------|
| Instalación de Debian                    | Instalación y configuración básica de red y acceso SSH            |
| Configuración de usuario y permisos      | Creación del usuario `backupuser` y estructura de carpetas        |
| Configuración de Clonezilla              | Preparación de USB, arranque y pruebas de copia de equipos        |
| Transferencia por SSH                    | Validación de acceso remoto seguro y pruebas de transferencia     |
| Verificación de copias                   | Comprobación de integridad de las imágenes                        |
| Desarrollo interfaz Flask                | Script Python que analiza directorios y genera la tabla HTML      |
| Configuración NGINX                      | Proxy inverso hacia Flask, apertura de puertos, pruebas           |
| Script automatización Clonezilla         | Desarrollo del script `mybackup.sh` y pruebas funcionales         |
| Redacción documentación y memoria        | Escritura en Markdown, organización de contenidos y limpieza      |
| Capturas, anexos, pruebas finales        | Toma de imágenes, organización del proyecto, pruebas de entrega   |


---

## 13. Anexos

- Configuración-Debian.md
- Configuración-Clonezilla.md
- Visualizacion_Backups_Flask.md
- Script-Clonezilla.md
- Configuración-Flask
