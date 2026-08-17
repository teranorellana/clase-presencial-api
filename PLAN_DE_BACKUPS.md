# Plan de Respaldos y Recuperación ante Desastres (Disaster Recovery Plan)

**Proyecto:** API REST - Colegio San Marcos
**Responsable:** Fredy Terán

## 1. Información a Respaldar
Se realizará un respaldo completo (Dump lógico) de la base de datos PostgreSQL de producción correspondiente a la plataforma del colegio. Esto incluye:
- El esquema completo de la base de datos (tablas, relaciones, restricciones).
- Registros de la tabla de alumnos.
- Registros de las tablas de autenticación y usuarios.
- Cualquier configuración interna almacenada en la base de datos.

## 2. Frecuencia de los Respaldos
- **Frecuencia:** Diaria.
- **Horario de ejecución:** 02:00 AM (Hora local, El Salvador), aprovechando la ventana de menor tráfico y uso de la plataforma institucional.
- **Tipo de ejecución:** Automatizada.

## 3. Lugar de Almacenamiento
- Los archivos resultantes del dump serán enviados, transferidos y almacenados de manera segura en un bucket dedicado dentro de **Google Cloud Storage**.
- Se mantendrá un historial de copias de seguridad accesible para evitar la pérdida total ante sobrescrituras corruptas.

## 4. Procedimiento de Recuperación ante Fallos (Disaster Recovery)
En caso de una caída catastrófica, pérdida o corrupción de datos en el servidor principal de PostgreSQL, se seguirá de forma estricta el siguiente protocolo de restauración:

1. **Notificación y Aislamiento:** Se detendrán temporalmente las peticiones a la API para evitar conflictos de escritura mientras se diagnostica el fallo.
2. **Obtención del Respaldo:** El responsable técnico accederá a la consola de Google Cloud Storage y descargará a un entorno local seguro el archivo de respaldo válido más reciente.
3. **Preparación del Entorno:** Se provisionará una nueva instancia en blanco de PostgreSQL (o se limpiará la actual si es recuperable) asegurando que las versiones coincidan.
4. **Restauración:** Desde la terminal local, o utilizando una herramienta de administración como pgAdmin, se ejecutará la restauración de los datos utilizando la herramienta oficial. 
   - *Ejemplo de comando:* `pg_restore -d <url_de_la_nueva_base_de_datos> archivo_de_respaldo.tar` o mediante restauración en entorno gráfico.
5. **Verificación de Integridad:** Se realizarán consultas de prueba a las tablas de alumnos directamente en la nueva base de datos para validar que los registros se restauraron correctamente.
6. **Actualización de Variables de Entorno:** Si el proceso requirió levantar un nuevo servidor de base de datos con una URL distinta, se actualizará inmediatamente la variable `DATABASE_URL` en la configuración del servicio web en Render.
7. **Restablecimiento del Servicio:** Se reiniciará el servicio backend y se confirmará su operatividad completa ingresando al endpoint de monitoreo `/health`.

Plan_de_Backups.md
Mostrando Plan_de_Backups.md.