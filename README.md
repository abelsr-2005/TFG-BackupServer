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
10. [Anexos](#10-anexos)

---

## 1. Introducción

En el laboratorio de la empresa Geotexan se utilizan varios equipos informáticos que forman parte esencial del flujo de trabajo diario. Sin embargo, actualmente no existe un sistema de copias de seguridad implementado para estos equipos. Esto supone un riesgo significativo, ya que en caso de fallo del sistema, pérdida de datos o daños en el disco duro, no hay forma de restaurar el equipo a un estado funcional anterior. Esta situación puede provocar interrupciones graves en la actividad del laboratorio, pérdida de información valiosa y un aumento considerable del tiempo de recuperación.

Ante esta problemática, se plantea como proyecto de TFG el diseño e implementación de un sistema de copias de seguridad que permita realizar imágenes completas de los equipos del laboratorio. Para ello, se utilizará Clonezilla Live como herramienta de clonado y un servidor Debian configurado con SSH como destino centralizado para almacenar dichas copias. Este sistema permitirá restaurar rápidamente cualquier equipo en caso de incidente, minimizando el impacto en la productividad y asegurando la continuidad del trabajo.

El proyecto se desarrollará documentando cada fase del proceso, desde la planificación inicial y la configuración del entorno hasta las pruebas de funcionamiento, con el objetivo de dejar una solución funcional, reutilizable y fácilmente mantenible.


---

## 2. Objetivos

- Implementar un sistema de copias de seguridad fiable y seguro.
- Automatizar el proceso de respaldo/restauración usando Clonezilla.
- Centralizar las copias en un servidor Debian mediante SSH.
- Documentar todo el proceso de forma detallada.

---

## 3. Análisis del entorno

- Equipos del laboratorio: características, sistema operativo, necesidades.
- Red disponible: LAN, 1Gbps.
- Almacenamiento necesario.
- Limitaciones actuales (manualidad, falta de control, etc.).

---

## 4. Tecnologías utilizadas

- **Clonezilla Live**
- **Servidor Debian 11/12**
- **SSH/SFTP**
- (Opcional) **PXE** para arranque por red
- Scripts bash para automatización
- (Opcional) Visualización web con Flask o PHP

---

## 5. Diseño del sistema

### 🔧 Esquema general

```text
[Equipo laboratorio] <-- Clonezilla (USB o PXE) --> [Servidor Debian (SSH)]
```

### Estructura de carpetas

```text
/backup-imagenes/
├── equipo01/
├── equipo02/
└── ...
```

---

## 6. Implementación

- Instalación y configuración de servidor Debian
- Preparación de carpetas y permisos
- Configuración de SSH (opcional: con claves)
- Proceso paso a paso de clonado con Clonezilla (con capturas)
- (Opcional) Montaje de servidor PXE para arranque automático
- Automatización y scripts usados

---

## 7. Pruebas realizadas

- Prueba de copia completa de un equipo
- Restauración de la imagen en el mismo equipo o uno diferente
- Comparación de tiempo según tipo de red
- Verificación de integridad de las imágenes

---

## 8. Resultados y mejoras

- Qué ha funcionado bien
- Dificultades encontradas
- Propuestas de mejora a futuro:
  - Automatización total
  - Integración web
  - Cifrado y backups remotos

---

## 9. Conclusiones

Reflexión sobre el aprendizaje, utilidad del sistema, aplicación real en la empresa y posibilidades de mantenimiento a largo plazo.

---

## 10. Anexos

- Script de copia
- Capturas de pantalla
- Archivos de configuración
- Diagramas

---

<p align="center">
  Desarrollado con 💻 y ☕ por <strong>Abel Sánchez</strong><br>
  Proyecto de Fin de Grado – CFGS Administración de Sistemas Informáticos en Red<br>
  Empresa colaboradora: <strong>Geotexan S.A.</strong><br>
  © 2025
</p>
