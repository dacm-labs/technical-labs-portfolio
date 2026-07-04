# Checks custom con DMVs

## Objetivo

Documentar los checks SQL custom creados para exponer métricas DBA desde SQL Server hacia Zabbix mediante Zabbix Agent 2, UserParameters y PowerShell.

La finalidad es convertir consultas SQL Server / DMVs en valores simples que Zabbix pueda almacenar como items y evaluar con triggers.

## Diseño general

```text
Zabbix Server
  -> Zabbix Agent 2 en ORN-SQL01 / ORN-SQL02
    -> UserParameter
      -> 03-check-sql-dmv.ps1
        -> SQL Server vía Windows Authentication
          -> Valor numérico para Zabbix
```

## Principios de diseño

- Cada check devuelve un único valor.
- Los valores deben ser estables para Zabbix: `0`, `1` o número entero.
- No se guardan usuarios SQL ni contraseñas en Git.
- Se usa Windows Authentication.
- La configuración local solo define el servidor SQL local.
- Los errores se controlan devolviendo `0` para evitar salida no parseable.
- Los checks de backup se combinan con lógica `primary-only` para evitar falsos positivos en la secundaria.

## Configuración local

Archivo local en cada nodo SQL:

```text
C:\ProgramData\ORION\ZabbixSql\orion_sql_monitor.env
```

Formato:

```text
Server=tcp:localhost,1433
```

Este archivo no contiene credenciales.

## UserParameters

Archivo versionado:

```text
scripts/zabbix/userparameters_orion_sql.conf
```

Ubicación destino en cada nodo SQL:

```text
C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\userparameters_orion_sql.conf
```

## Wrapper PowerShell

Archivo versionado:

```text
scripts/powershell/03-check-sql-dmv.ps1
```

Ubicación destino en cada nodo SQL:

```text
C:\ProgramData\ORION\ZabbixSql\03-check-sql-dmv.ps1
```

## Checks implementados

| Check | Key Zabbix | Fuente | Valor esperado |
|---|---|---|---:|
| SQL ping | `orion.sql.ping` | `SELECT 1` | 1 |
| SQL Server service | `orion.sql.service.running` | Servicio `MSSQLSERVER` | 1 |
| SQL Agent service | `orion.sql.agent.running` | Servicio `SQLSERVERAGENT` | 1 |
| User sessions | `orion.sql.sessions.user` | `sys.dm_exec_sessions` | número |
| Blocking sessions | `orion.sql.blocking.sessions` | `sys.dm_exec_requests` | 0 |
| Failed jobs 24h | `orion.sql.jobs.failed24h` | `msdb.dbo.sysjobhistory` | 0 |
| FULL backup age | `orion.sql.backup.full.age.hours[OrionLabDB]` | `msdb.dbo.backupset` | según política |
| LOG backup age | `orion.sql.backup.log.age.hours[OrionLabDB]` | `msdb.dbo.backupset` | según política |
| Always On health | `orion.sql.ag.health` | `sys.dm_hadr_database_replica_states` | 1 |
| Is primary | `orion.sql.ag.is_primary[OrionLabDB]` | `sys.dm_hadr_database_replica_states` | 1 primario / 0 secundario |

## Consultas base

### Bloqueos actuales

```sql
SELECT COUNT(*)
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
```

### Jobs fallidos en 24 horas

```sql
SELECT COUNT(*)
FROM msdb.dbo.sysjobhistory h
WHERE h.step_id = 0
  AND h.run_status <> 1
  AND msdb.dbo.agent_datetime(h.run_date, h.run_time) >= DATEADD(HOUR, -24, GETDATE());
```

### Edad de backup LOG

```sql
SELECT COALESCE(DATEDIFF(HOUR, MAX(backup_finish_date), GETDATE()), 999999)
FROM msdb.dbo.backupset
WHERE database_name = N'OrionLabDB'
  AND type = 'L';
```

### Salud Always On

```sql
SELECT CASE
    WHEN EXISTS (
        SELECT 1
        FROM sys.dm_hadr_database_replica_states
        WHERE is_local = 1
          AND synchronization_health_desc <> N'HEALTHY'
    )
    THEN 0
    ELSE 1
END;
```

### Rol primario para OrionLabDB

```sql
SELECT CASE
    WHEN EXISTS (
        SELECT 1
        FROM sys.dm_hadr_database_replica_states
        WHERE is_local = 1
          AND database_id = DB_ID(N'OrionLabDB')
          AND is_primary_replica = 1
    )
    THEN 1
    ELSE 0
END;
```

## Validación con zabbix_get

Desde ORN-MON01 se validan los checks contra SQL01 y SQL02:

```bash
zabbix_get -s 10.10.20.20 -p 10050 -k orion.sql.ping
zabbix_get -s 10.10.20.20 -p 10050 -k orion.sql.service.running
zabbix_get -s 10.10.20.20 -p 10050 -k orion.sql.agent.running
zabbix_get -s 10.10.20.20 -p 10050 -k orion.sql.ag.health
zabbix_get -s 10.10.20.20 -p 10050 -k 'orion.sql.ag.is_primary[OrionLabDB]'
```

Resultado validado:

| Host | SQL ping | SQL service | SQL Agent | AG health | is_primary |
|---|---:|---:|---:|---:|---:|
| ORN-SQL01 | 1 | 1 | 1 | 1 | 1 |
| ORN-SQL02 | 1 | 1 | 1 | 1 | 0 |

## Seguridad

La integración respeta el hardening del LAB-03:

- SQL Server permanece en Windows Authentication Only.
- `sa` sigue deshabilitado.
- No se reintroducen usuarios SQL.
- No se publican contraseñas.
- El diseño se apoya en cuenta de dominio y permisos mínimos cuando aplica.

## Limitación documentada

ORN-SQL01 queda temporalmente con Zabbix Agent 2 ejecutándose como LocalSystem para priorizar estabilidad, aunque los checks SQL custom están validados.

ORN-SQL02 queda usando la cuenta `ORION\svc_zbx_sqlmon`.

La homogeneización de cuenta en ORN-SQL01 queda como mejora futura no bloqueante.

## Conclusión

Los checks custom convierten DMVs y metadatos SQL Server en métricas operativas consumibles por Zabbix, permitiendo alertar sobre servicios, backups, jobs, bloqueos y salud Always On sin romper el modelo de seguridad del laboratorio.
