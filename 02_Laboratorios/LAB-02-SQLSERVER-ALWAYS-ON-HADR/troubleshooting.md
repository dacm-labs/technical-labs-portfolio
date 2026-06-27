# Troubleshooting — LAB-02 SQL Server Always On

## Error de Sysprep al intentar clonar nodo SQL

### Situación

Se valoró clonar una máquina existente para acelerar la creación de `ORN-SQL02`, pero el proceso no era adecuado para dejar un nodo limpio de clúster y SQL Server.

### Decisión

Se descartó el clon y se creó `ORN-SQL02` mediante instalación limpia.

### Motivo técnico

En un entorno con Active Directory, SQL Server y WSFC es preferible evitar problemas derivados de SID, servicios, identidad de máquina o residuos de configuración previa.

## Error de cadena LSN al unir `OrionLabDB` al Availability Group

### Síntoma

Al intentar incorporar la base secundaria al Availability Group apareció el error relacionado con que la copia remota no se encontraba en un punto de recuperación válido.

### Causa

La base secundaria no había sido restaurada con una cadena de backups `FULL + LOG` coherente con el estado actual de la base primaria.

### Resolución

Se reinicializó la réplica secundaria desde cero:

1. Backup FULL limpio en `ORN-SQL01`.
2. Backup LOG inmediatamente posterior en `ORN-SQL01`.
3. Restauración en `ORN-SQL02` con `NORECOVERY`.
4. Incorporación de la base al Availability Group.

### Resultado

`OrionLabDB` quedó `SYNCHRONIZED`, `HEALTHY` y sin suspensión.

## Error al crear el listener `ORN-SQLAG01`

### Síntoma

La creación del listener falló inicialmente porque el recurso de nombre de red no podía ponerse online.

### Causa

El objeto de equipo del listener no estaba preparado correctamente en Active Directory o el CNO del clúster no tenía permisos suficientes.

### Resolución

Se precreó el objeto `ORN-SQLAG01` en Active Directory y se delegaron permisos al objeto del clúster `ORN-SQLCL01`.

### Resultado

El listener quedó online con IP `10.10.20.60` y puerto `1433`.

## Conexión a réplica secundaria sin `ApplicationIntent=ReadOnly`

### Síntoma

Al conectar directamente a `ORN-SQL02` y seleccionar la base `OrionLabDB`, SQL Server indicó que la base estaba accesible únicamente para conexiones con intención de solo lectura.

### Causa

La réplica secundaria estaba configurada con `SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY)`.

### Resolución

Se configuró la conexión en SSMS con `Application Intent = ReadOnly`.

### Resultado

La consulta de lectura contra `lab.AG_Listener_Test` funcionó correctamente sobre la réplica secundaria.

## Registro DNS APIPA en `ORN-SQL01`

### Síntoma

Durante una validación final apareció una IP `169.254.x.x` asociada a `ORN-SQL01`.

### Causa

Una interfaz no utilizada conservaba direccionamiento APIPA y podía registrar DNS.

### Resolución

Se revisó la zona `orion.lab`, se confirmó que el registro A correcto era `10.10.20.20` y se deshabilitó el registro DNS en la interfaz afectada.

### Resultado

La resolución DNS final quedó limpia:

- `ORN-SQL01` -> `10.10.20.20`
- `ORN-SQL02` -> `10.10.20.21`
- `ORN-SQLAG01` -> `10.10.20.60`
- `ORN-SQLCL01` -> `10.10.20.50`
- `ORN-FSW01` -> `10.10.20.40`

## Jobs tradicionales no adaptados a Always On

### Situación

Los jobs del LAB-01 estaban diseñados para una única instancia SQL Server.

### Riesgo

En un Availability Group, un job puede ejecutarse en una réplica que no tiene el rol adecuado.

### Resolución

Se deshabilitaron los jobs tradicionales para `OrionLabDB` y se crearon jobs AG-aware en ambos nodos.

### Resultado

Los nuevos jobs comprueban el rol de la réplica antes de ejecutar backups o CHECKDB.

