# Scripts LAB-04

## Objetivo

Centralizar los scripts utilizados en el laboratorio de monitorización de SQL Server, Windows Server y Always On.

Los scripts se dividen en tres bloques:

- PowerShell
- SQL
- Zabbix

## scripts/powershell

Scripts para validaciones desde Windows Server:

- 02-check-sql-services.ps1: valida servicios MSSQLSERVER y SQLSERVERAGENT.
- 03-check-sql-dmv.ps1: wrapper para checks SQL custom ejecutados por Zabbix Agent 2.
- 05-create-perfmon-baseline-collector.ps1: crea un Data Collector Set de PerfMon con logman.
- 06-check-windows-critical-events.ps1: revisa eventos críticos, errores y warnings del log System.
- 07-check-cluster-dns-health.ps1: valida clúster, DNS y canal seguro de dominio.

## scripts/sql

Scripts para validaciones desde SQL Server Management Studio:

- 01-baseline-sql-monitoring.sql: baseline general de SQL Server.
- 02-dmv-blocking-sessions.sql: sesiones bloqueadas y bloqueantes.
- 03-dmv-wait-stats.sql: wait stats principales.
- 04-alwayson-health.sql: estado de Always On Availability Groups.
- 05-backup-age-check.sql: antigüedad de backups FULL, DIFF y LOG.
- 06-agent-jobs-check.sql: jobs SQL Agent, última ejecución y schedules.
- 07-audit-status-check.sql: estado de SQL Server Audit.
- 08-hardening-status-check.sql: validación de hardening SQL Server.

## scripts/zabbix

Archivos para integración con Zabbix Agent 2 y la fase de template/triggers:

- userparameters_orion_sql.conf: UserParameters SQL custom validados.
- template-orion-sqlserver-custom.yaml: reservado para export final del template de Zabbix UI.
- triggers-documentation.md: documentación prevista de triggers SQL custom.

## Autenticación

Los checks SQL custom están diseñados para Windows Authentication.

El fichero local en cada nodo SQL solo debe contener el servidor local:

```text
Server=tcp:localhost,1433
```

No se versionan usuarios SQL ni secretos.

## Estado

Scripts nativos creados durante el BLOQUE 1.

Wrapper PowerShell y UserParameters SQL custom creados y validados durante el BLOQUE 5.

Pendiente de BLOQUE 6: crear template, items, triggers y dashboard en Zabbix UI.
