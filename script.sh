#!/bin/bash

# ==== CONFIGURACIÓN ====
USUARIO="andres"               # Usuario del sistema
DB_NAME="myDB"        # Base de datos MariaDB a respaldar
DB_USER="webuser"         # Usuario de MariaDB
DB_PASS="practicas,ise"
BACKUP_DIR="/home/$USUARIO"
DUMP_FILE="$BACKUP_DIR/dump.sql"
ARCHIVE="$BACKUP_DIR/backup_cliente.tar.gz"

# ==== 1. CREAR DUMP DE MARIADB ====
echo "Generando volcado de la base de datos..."
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$DUMP_FILE"

if [ $? -ne 0 ]; then
    echo "Error: Falló el volcado de la base de datos."
    exit 1
fi

# ==== 2. PREPARAR LISTA DE ARCHIVOS ====
FILES_TO_BACKUP="$DUMP_FILE"

# Agregar bash_history si existe
if [ -f "$BACKUP_DIR/.bash_history" ]; then
    FILES_TO_BACKUP="$FILES_TO_BACKUP $BACKUP_DIR/.bash_history"
else
    echo "Aviso: No existe .bash_history — continúa..."
fi

# Agregar mysql_history si existe
if [ -f "$BACKUP_DIR/.mysql_history" ]; then
    FILES_TO_BACKUP="$FILES_TO_BACKUP $BACKUP_DIR/.mysql_history"
else
    echo "Aviso: No existe .mysql_history — continúa..."
fi

# ==== 3. VERIFICAR QUE HAYA ARCHIVOS ====
if [ -z "$FILES_TO_BACKUP" ]; then
    echo "Error: No hay archivos para comprimir."
    exit 1
fi

# ==== 4. CREAR ARCHIVO TAR ====
echo "Empaquetando archivos..."
tar -czf "$ARCHIVE" $FILES_TO_BACKUP

if [ $? -ne 0 ]; then
    echo "Error: Falló la compresión con tar."
    exit 1
fi

echo "Backup generado correctamente en: $ARCHIVE"

# ==== 5. BORRAR DUMP PLANO ====
rm "$DUMP_FILE"

echo "Proceso finalizado."
