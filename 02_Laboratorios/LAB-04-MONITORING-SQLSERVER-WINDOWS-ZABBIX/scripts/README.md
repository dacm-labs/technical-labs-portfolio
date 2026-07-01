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

Contenido reservado para la fase Zabbix:

- userparameters_orion_sql.conf
- template-orion-sqlserver-custom.yaml
- triggers-documentation.md

## Uso recomendado

Primero ejecutar los scripts nativos para obtener baseline.

Después desplegar Zabbix y reutilizar parte de estas validaciones como checks personalizados.

## Estado

Scripts base de monitorización nativa creados durante el BLOQUE 1.
