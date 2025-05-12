# Configuración de Clonezilla y realización de una copia de seguridad

## 1. Preparar Clonezilla en el equipo cliente

Para realizar las copias de seguridad de los equipos de laboratorio, utilizaremos Clonezilla Live, una herramienta de clonación de discos. Sigue los siguientes pasos:

- Descarga la ISO de Clonezilla Live desde su página oficial: [Clonezilla](https://clonezilla.org/downloads.php).
- Graba la imagen ISO en un USB o crea un disco de arranque con Clonezilla Live.

## 2. Arrancar Clonezilla Live en el equipo cliente

Con el dispositivo USB o el disco de arranque de Clonezilla, inicia el equipo que deseas clonar. Esto lo hará arrancar desde el medio de Clonezilla.

## 3. Configurar la red en Clonezilla

En el menú de Clonezilla, selecciona las opciones de red para conectar el equipo cliente con el servidor Debian a través de SSH.

1. En el menú de inicio de Clonezilla, elige la opción "device-image" (dispositivo a imagen).
2. Luego selecciona la opción de almacenamiento remoto a través de SSH.

## 4. Conectar Clonezilla al servidor Debian mediante SSH

Introduce la IP del servidor Debian y las credenciales del usuario `backupuser` que creaste previamente:

```bash
ssh backupuser@ip_del_servidor
```

## 5. Seleccionar la ubicación de almacenamiento de las copias de seguridad

Una vez que Clonezilla esté conectado al servidor, selecciona la carpeta `/backup-imagenes` donde se almacenarán las imágenes de las copias de seguridad.

## 6. Realizar la copia de seguridad

1. Selecciona el disco que deseas clonar.
2. Elige la opción para crear una imagen del disco y guardar esta imagen en el servidor Debian.
3. Clonezilla procederá a crear la copia de seguridad del disco y la almacenará en la carpeta especificada en el servidor Debian.

## 7. Verificación de la copia de seguridad

Una vez completado el proceso, puedes verificar que la copia se ha realizado correctamente conectándote al servidor Debian y comprobando el contenido de la carpeta `/backup-imagenes`:

```bash
ls -l /backup-imagenes
```

---

Con estos pasos habrás realizado con éxito una copia de seguridad de los equipos del laboratorio y la habrás almacenado en el servidor Debian.
