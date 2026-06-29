# Troubleshooting — LAB-03 SQL Server Hardening, Audit & Compliance

## Objetivo

Documentar incidencias, hallazgos y decisiones técnicas surgidas durante LAB-03.

El foco no es ocultar problemas, sino demostrar criterio operativo: identificar causa, corregir de forma controlada y validar el resultado.

---

## 1. SQL02 en Mixed Mode

### Síntoma

Durante el baseline se detectó:

```text
ORN-SQL01 -> WindowsAuthOnly = 1
ORN-SQL02 -> WindowsAuthOnly = 0
```

### Causa

SQL02 no estaba alineado con SQL01 en modo de autenticación. Mantenía Mixed Mode.

### Resolución

Se cambió `LoginMode` a Windows Authentication only mediante `xp_instance_regwrite` y se reinició el servicio SQL Server en SQL02.

### Resultado

```text
ORN-SQL02 -> WindowsAuthOnly = 1
```

---

## 2. Login `sa` habilitado en SQL02

### Síntoma

El inventario de SQL logins mostró `sa` habilitado en `ORN-SQL02`.

### Riesgo

Aunque SQL Server estuviera protegido por dominio, mantener `sa` activo aumenta la superficie de ataque.

### Resolución

```sql
ALTER LOGIN [sa] DISABLE;
```

### Resultado

`sa` quedó deshabilitado en SQL01 y SQL02.

---

## 3. Grupos AD no alineados en SQL02

### Síntoma

SQL02 no tenía todos los grupos funcionales que sí existían en SQL01.

### Resolución

Se crearon o validaron como logins de Windows:

- `ORION\GG_SQL_READONLY`
- `ORION\GG_SQL_BACKUP_OPERATORS`
- `ORION\GG_SQL_AUDIT_READERS`
- `ORION\GG_SQL_DBA_ADMINS`

### Resultado

Ambos nodos quedaron alineados a nivel de logins funcionales.

---

## 4. `show advanced options` habilitado en SQL01

### Síntoma

SQL01 mantenía `show advanced options = 1` tras configuraciones anteriores.

### Resolución

Se cerró la opción al final del hardening:

```sql
EXEC sp_configure 'show advanced options', 0;
RECONFIGURE;
```

### Resultado

`show advanced options = 0` en SQL01 y SQL02.

---

## 5. SQL02 sin auditoría de servidor inicial

### Síntoma

SQL01 tenía `ORION_ServerAudit` activo, pero SQL02 no disponía de auditoría equivalente.

### Resolución

Se creó `ORION_ServerAudit` y `ORION_ServerAuditSpec` en SQL02 con salida a `D:\SQLAudit\`.

### Resultado

SQL02 comenzó a registrar eventos `.sqlaudit` correctamente.

---

## 6. Diferencia de audit_guid entre réplicas

### Síntoma

Tras crear la auditoría en SQL02, se detectó que el GUID no coincidía con SQL01.

```text
SQL01: 71C8B8E7-2FA2-4F45-8EF0-29AF15D30A28
SQL02: 567CC86F-A376-46B0-9CC3-C92880B3A6D9
```

### Causa

Crear un Server Audit de forma independiente genera un `audit_guid` distinto.

### Resolución

Se recreó la auditoría de SQL02 indicando explícitamente el GUID de SQL01.

### Resultado

Ambos nodos quedaron con:

```text
71C8B8E7-2FA2-4F45-8EF0-29AF15D30A28
```

---

## 7. Lectura de auditoría denegada al usuario auditor

### Síntoma

`ORION\usr_sql_audit` podía pertenecer al rol de auditoría de base, pero no podía ejecutar `sys.fn_get_audit_file`.

Error observado:

```text
VIEW SERVER SECURITY AUDIT permission was denied
```

### Causa

Leer ficheros de auditoría SQL requiere permiso a nivel servidor.

### Resolución

Se concedió el permiso mínimo al grupo auditor:

```sql
GRANT VIEW SERVER SECURITY AUDIT TO [ORION\GG_SQL_AUDIT_READERS];
```

### Resultado

El usuario auditor pudo leer auditoría, pero siguió sin acceso a datos de negocio.

---

## 8. Ruta de backup incorrecta en prueba de backup operator

### Síntoma

La prueba de backup con `usr_sql_backupop` falló inicialmente al usar una ruta no existente.

```text
Operating system error 3: The system cannot find the path specified
```

### Causa

El backup se ejecuta en el servidor SQL, no en la estación DBA. En `ORN-SQL01`, el disco de backups era `B:` y no `F:`.

### Resolución

Se validó la unidad real y se creó la ruta correcta:

```powershell
New-Item -Path "B:\SQLBackups" -ItemType Directory -Force
icacls "B:\SQLBackups" /grant "ORION\svc_sql_engine:(OI)(CI)M"
```

### Resultado

El backup se generó correctamente en:

```text
B:\SQLBackups\ORION_PrivilegeTest_BackupOperator_COPYONLY.bak
```

---

## 9. Marcas rojas de IntelliSense en SSMS

### Síntoma

SSMS mostraba subrayados rojos en algunas consultas contra catálogos y objetos.

### Causa

IntelliSense no siempre refresca metadatos correctamente, especialmente tras cambios de contexto, réplicas secundarias o nuevos objetos.

### Resolución

Se validó por ejecución real de la consulta y mensajes `Query executed successfully`.

### Resultado

No se trató como error funcional.

---

## Conclusión

Las incidencias detectadas fueron operativas y controladas. Todas se resolvieron sin dejar el Availability Group en estado inconsistente y sin comprometer la sincronización de `OrionLabDB`.

El troubleshooting del LAB-03 demuestra criterio DBA real: validar antes de corregir, aplicar cambios de forma controlada, comprobar efectos y documentar decisiones.