
# Proyecto TFG – Sistema de copias de seguridad con Clonezilla y servidor Debian

## 📌 Resumen

Este proyecto consiste en la implementación de un sistema de copias de seguridad para los equipos del laboratorio de la empresa, utilizando Clonezilla Live y un servidor Debian con SSH. Las imágenes de respaldo se almacenan en el servidor de forma segura, permitiendo su restauración rápida en caso de fallo o mantenimiento.

---

## 📚 Índice

1. [Introducción](#1-introducción)  
2. [Objetivos](#2-objetivos)  
3. [Análisis del entorno](#3-análisis-del-entorno)  
4. [Tecnologías utilizadas](#4-tecnologías-utilizadas)  
5. [Diseño del sistema](#5-diseño-del-sistema)  
6. [Implementación](#6-implementación)  
7. [Pruebas realizadas](#7-pruebas-realizadas)  
8. [Resultados y mejoras](#8-resultados-y-mejoras)  
9. [Conclusiones](#9-conclusiones)  
10. [Recursos](#10-recursos)  
11. [Cronograma y presupuesto](#11-cronograma-y-presupuesto)  
12. [Bibliografía](#12-bibliografía)  
13. [Anexos](#13-anexos)

---

## 1. Introducción

En el laboratorio de la empresa Geotexan se utilizan varios equipos informáticos que forman parte esencial del flujo de trabajo diario. Sin embargo, actualmente no existe un sistema de copias de seguridad implementado para estos equipos. Esto supone un riesgo significativo, ya que en caso de fallo del sistema, pérdida de datos o daños en el disco duro, no hay forma de restaurar el equipo a un estado funcional anterior.

Ante esta problemática, se plantea como proyecto de TFG el diseño e implementación de un sistema de copias de seguridad que permita realizar imágenes completas de los equipos del laboratorio. Para ello, se utilizará Clonezilla Live como herramienta de clonado y un servidor Debian configurado con SSH como destino centralizado para almacenar dichas copias.

---

## 2. Objetivos

### Objetivo general

Diseñar e implementar un sistema de copias de seguridad basado en Clonezilla y un servidor Debian 12 accesible mediante SSH, que permita preservar imágenes de los equipos del laboratorio de forma centralizada, segura y eficiente.

### Objetivos específicos

- Instalar y configurar un servidor Debian 12 como nodo de almacenamiento de copias.
- Configurar el acceso remoto seguro mediante SSH.
- Crear un entorno de almacenamiento estructurado para las imágenes.
- Utilizar Clonezilla Live para realizar copias completas de discos.
- Automatizar y documentar el proceso para futuras réplicas o restauraciones.

---

## 3. Análisis del entorno

- Equipos del laboratorio: sistemas Windows, uso diario intensivo.
- Red LAN de 1 Gbps.
- Servidor virtual en Proxmox con Debian 12.
- Sin soluciones previas automatizadas de backup.

---

## 4. Tecnologías utilizadas

- Clonezilla Live
- Debian 12
- SSH
- Scripts Bash

---

## 5. Diseño del sistema

### Esquema general

```
[Equipo laboratorio] <-- Clonezilla (USB o PXE) --> [Servidor Debian (SSH)]
```

### Estructura de carpetas

```
/backup-imagenes/
├── equipo01/
├── equipo02/
└── ...
```

---

## 6. Implementación

Los pasos de instalación y configuración están documentados en:

- `Configuración-Debian.md`
- `Configuración-Clonezilla.md`

Resumen:
- Instalación de Debian
- Creación de usuario `backupuser`
- Configuración de SSH
- Arranque con Clonezilla
- Conexión SSH y almacenamiento remoto

---

## 7. Pruebas realizadas

### Prueba 1: Copia completa de equipo Windows

- Clonezilla Live por USB
- Conexión SSH al servidor Debian
- Almacenamiento en `/backup-imagenes/equipo01/`

✅ Resultado: Éxito

### Prueba 2: Restauración en otro equipo

- Restauración en equipo limpio
- Imagen funcional recuperada sin errores

✅ Resultado: Éxito

---

## 8. Resultados y mejoras

### Resultados

- Sistema funcional y probado
- Interfaz simple con Clonezilla
- Rápida restauración en caso de error

### Mejoras a futuro

- Automatización total con scripts PXE
- Interfaz web para verificación y control
- Cifrado de backups

---

## 9. Conclusiones

Este proyecto ha permitido implementar un sistema de respaldo para los equipos de la empresa Geotexan, utilizando únicamente herramientas libres y recursos ya disponibles. Gracias a la automatización con Clonezilla y la centralización mediante SSH en un servidor Debian, se consigue reducir considerablemente el tiempo necesario para recuperar un equipo en caso de fallo.

---

## 10. Recursos

### Recursos humanos

- **Alumno**: Abel Sánchez  
- **Rol**: Responsable de toda la implementación

### Recursos materiales

- Servidor físico virtualizado
- VM con Debian 12
- USB con Clonezilla
- Red local

---

## 11. Cronograma y presupuesto

### Cronograma

| Semana | Actividad                                |
|--------|------------------------------------------|
| 1      | Instalación Debian y configuración SSH   |
| 2      | Carpeta backup y pruebas de red          |
| 3      | Clonezilla, clonado y restauración       |
| 4      | Documentación y anexos                   |

### Presupuesto

| Recurso                 | Descripción                      | Coste |
|-------------------------|----------------------------------|-------|
| VM Debian 12            | Reutilización                    | 0 €   |
| Clonezilla Live         | Software libre                   | 0 €   |
| USB booteable           | Existente                        | 0 €   |
| Tiempo del alumno       | Trabajo personal                 | 0 €   |
| **Total**               |                                  | **0 €** |

---

## 12. Bibliografía

- https://clonezilla.org/
- https://www.debian.org/
- https://man.openbsd.org/ssh
- https://clonezilla.org/clonezilla-live-doc.php

---

## 13. Anexos

- Configuración-Debian.md
- Configuración-Clonezilla.md
- Capturas de pantalla (si aplica)
