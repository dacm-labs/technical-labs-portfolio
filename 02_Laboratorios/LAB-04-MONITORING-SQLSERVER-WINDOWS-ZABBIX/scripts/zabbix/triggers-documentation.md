# LAB-04 — Zabbix SQL Server Custom Triggers

## Objetivo

Este documento recoge los triggers personalizados creados en Zabbix para monitorización DBA sobre SQL Server Always On.

Los triggers se basan en los UserParameters SQL custom validados previamente desde ORN-MON01 mediante zabbix_get y posteriormente integrados en el template:

- ORION SQL Server Custom Checks

El objetivo es detectar fallos relevantes de operación SQL Server sin generar falsos positivos en réplicas secundarias del Availability Group.

## Entorno validado

| Elemento | Valor |
|---|---|
| Zabbix Server | ORN-MON01 |
| Hosts SQL monitorizados | ORN-SQL01, ORN-SQL02 |
| SQL Server | SQL Server 2025 Developer |
| Base validada | OrionLabDB |
| Availability Group | ORION_AG01 |
| Template Zabbix | ORION SQL Server Custom Checks |
| Cuenta técnica objetivo | ORION\svc_zbx_sqlmon |
| Excepción documentada | ORN-SQL01 validado temporalmente con LocalSystem para mantener estabilidad. |
| Puerto Agent | 10050 |

## Items SQL custom usados

| Item | Key | Valor esperado |
|---|---|---:|
| SQL custom ping | orion.sql.ping | 1 |
| SQL Server service running | orion.sql.service.running | 1 |
| SQL Server Agent running | orion.sql.agent.running | 1 |
| Always On health | orion.sql.ag.health | 1 |
| Always On is primary for OrionLabDB | orion.sql.ag.is_primary[OrionLabDB] | 1 en primario, 0 en secundario |
| SQL blocking sessions | orion.sql.blocking.sessions | 0 |
| SQL Agent failed jobs last 24h | orion.sql.jobs.failed24h | 0 |
| SQL user sessions | orion.sql.sessions.user | valor numérico |
| SQL backup FULL age hours for OrionLabDB | orion.sql.backup.full.age.hours[OrionLabDB] | según política |
| SQL backup LOG age hours for OrionLabDB | orion.sql.backup.log.age.hours[OrionLabDB] | según política |

## Triggers creados

| Trigger | Severidad | Expresión | Objetivo |
|---|---|---|---|
| Always On unhealthy on {HOST.NAME} | High | max(/ORION SQL Server Custom Checks/orion.sql.ag.health,3m)=0 | Detectar estado no saludable del AG en el nodo local. |
| SQL Agent failed jobs detected on {HOST.NAME} | Average | last(/ORION SQL Server Custom Checks/orion.sql.jobs.failed24h)>0 | Detectar jobs fallidos en las últimas 24 horas. |
| SQL blocking sessions detected on {HOST.NAME} | Warning | min(/ORION SQL Server Custom Checks/orion.sql.blocking.sessions,5m)>0 | Detectar bloqueos SQL sostenidos. |
| SQL custom ping failed on {HOST.NAME} | High | max(/ORION SQL Server Custom Checks/orion.sql.ping,3m)=0 | Detectar fallo general del check SQL custom. |
| SQL FULL backup old for OrionLabDB on {HOST.NAME} | Average | last(/ORION SQL Server Custom Checks/orion.sql.backup.full.age.hours[OrionLabDB])>168 and last(/ORION SQL Server Custom Checks/orion.sql.ag.is_primary[OrionLabDB])=1 | Alertar si el FULL backup es antiguo solo en el primario. |
| SQL LOG backup old for OrionLabDB on {HOST.NAME} | Average | last(/ORION SQL Server Custom Checks/orion.sql.backup.log.age.hours[OrionLabDB])>24 and last(/ORION SQL Server Custom Checks/orion.sql.ag.is_primary[OrionLabDB])=1 | Alertar si el LOG backup es antiguo solo en el primario. |
| SQL Server Agent down on {HOST.NAME} | High | max(/ORION SQL Server Custom Checks/orion.sql.agent.running,3m)=0 | Detectar SQL Server Agent detenido. |
| SQL Server service down on {HOST.NAME} | Disaster | max(/ORION SQL Server Custom Checks/orion.sql.service.running,3m)=0 | Detectar SQL Server Database Engine detenido. |

## Diseño anti-falsos positivos en Always On

Los triggers de backup se han diseñado con lógica primary-only.

Esto evita que una réplica secundaria genere alertas por antigüedad de backups cuando la responsabilidad operativa del backup se valida sobre el nodo primario.

La condición usada es:

```text
last(/ORION SQL Server Custom Checks/orion.sql.ag.is_primary[OrionLabDB])=1
```

Con esta lógica:

| Host | Rol | is_primary | Debe alertar por backup antiguo |
|---|---|---:|---|
| ORN-SQL01 | Primario | 1 | Sí, si supera el umbral |
| ORN-SQL02 | Secundario | 0 | No |

## Validación funcional

Se validó el ciclo completo de detección y recuperación sobre el trigger:

- SQL LOG backup old for OrionLabDB on {HOST.NAME}

### Estado inicial

En Latest data se observó:

| Host | Item | Valor |
|---|---|---:|
| ORN-SQL01 | SQL backup LOG age hours for OrionLabDB | 335 h |
| ORN-SQL02 | SQL backup LOG age hours for OrionLabDB | 334 h / 335 h |

Como ORN-SQL01 era el primario, Zabbix generó correctamente el problema:

```text
SQL LOG backup old for OrionLabDB on ORN-SQL01
```

No se generó problema equivalente en ORN-SQL02 porque el item is_primary[OrionLabDB] devolvía 0.

### Corrección aplicada

Se ejecutó un backup LOG manual sobre ORN-SQL01 usando la ruta real detectada en msdb:

```text
B:\SQLBackups
```

El backup generado quedó registrado en msdb como tipo L:

```text
database_name: OrionLabDB
type: L
backup_finish_date: 2026-07-03 18:14:50
backup_size_mb: 3.77
```

### Estado final

Tras el nuevo backup LOG, Zabbix actualizó el item:

| Host | Item | Valor final |
|---|---|---:|
| ORN-SQL01 | SQL backup LOG age hours for OrionLabDB | 0 h |
| ORN-SQL02 | SQL backup LOG age hours for OrionLabDB | 335 h |

El problema SQL quedó recuperado:

```text
SQL LOG backup old for OrionLabDB on ORN-SQL01
Status: RESOLVED
Recovery time: 06:15:48 PM
```

Finalmente se filtró Monitoring > Problems con:

```text
Show: Problems
Hosts: ORN-SQL01, ORN-SQL02
Problem: SQL
```

Resultado final:

```text
No active SQL custom problems
```

## Resultado del bloque

Queda validado que el template ORION SQL Server Custom Checks no solo recoge métricas SQL Server reales, sino que también evalúa alertas operativas DBA con recuperación automática.

La validación demuestra:

- Monitorización SQL custom mediante Zabbix Agent 2.
- Diseño preparado para Windows Authentication y cuenta técnica de dominio, con excepción documentada en ORN-SQL01.
- Detección de estado SQL Server y SQL Server Agent.
- Detección de salud Always On.
- Detección de bloqueos SQL.
- Detección de jobs fallidos.
- Control de antigüedad de backups FULL y LOG.
- Lógica primary-only para evitar falsos positivos en réplicas secundarias.
- Generación real de problema en Zabbix.
- Resolución real tras corrección operativa.

## Ficheros relacionados

| Fichero | Descripción |
|---|---|
| template-orion-sqlserver-custom.yaml | Export real del template Zabbix con items y triggers SQL custom. |
| userparameters_orion_sql.conf | UserParameters usados por Zabbix Agent 2. |
| ../powershell/03-check-sql-dmv.ps1 | Wrapper PowerShell que ejecuta los checks SQL. |
