# Scripts LAB-04

## Objetivo

Centralizar los scripts utilizados en el laboratorio de monitorización de SQL Server, Windows Server y Always On.

Los scripts se dividen en tres bloques:

- PowerShell
- SQL
- Zabbix

## scripts/powershell

- `01-install-zabbix-agent2-windows.ps1`: instalación y configuración base de Zabbix Agent 2 en Windows.
- `02-check-sql-services.ps1`: validación de servicios `MSSQLSERVER` y `SQLSERVERAGENT`.
- `03-check-sql-dmv.ps1`: wrapper para checks SQL custom ejecutados por Zabbix Agent 2.
- `05-create-perfmon-baseline-collector.ps1`: creación de Data Collector Set de PerfMon con logman.
- `06-check-windows-critical-events.ps1`: revisión de eventos críticos, errores y warnings del log System.
- `07-check-cluster-dns-health.ps1`: validación de clúster, DNS y canal seguro de dominio.
- `09-extract-lab04-evidence-images.ps1`: extracción local de capturas seleccionadas desde el DOCX técnico del LAB-04.

## scripts/sql

- `01-baseline-sql-monitoring.sql`: baseline general de SQL Server.
- `02-dmv-blocking-sessions.sql`: sesiones bloqueadas y bloqueantes.
- `03-dmv-wait-stats.sql`: wait stats principales.
- `04-alwayson-health.sql`: estado de Always On Availability Groups.
- `05-backup-age-check.sql`: antigüedad de backups FULL, DIFF y LOG.
- `06-agent-jobs-check.sql`: jobs SQL Agent, última ejecución y schedules.
- `07-audit-status-check.sql`: estado de SQL Server Audit.
- `08-hardening-status-check.sql`: validación de hardening SQL Server.

## scripts/zabbix

- `userparameters_orion_sql.conf`: UserParameters SQL custom validados.
- `template-orion-sqlserver-custom.yaml`: export real del template `ORION SQL Server Custom Checks`.
- `triggers-documentation.md`: documentación final de items, triggers, lógica primary-only y recuperación real.

## Autenticación

Los checks SQL custom están diseñados para Windows Authentication.

El fichero local en cada nodo SQL solo debe contener el servidor local:

```text
Server=tcp:localhost,1433
```

No se versionan usuarios SQL ni secretos.

## Estado final

| Bloque | Estado |
|---|---|
| Scripts nativos Windows / SQL Server | Completado |
| Wrapper PowerShell SQL custom | Completado |
| UserParameters Zabbix | Completado |
| Template Zabbix exportado | Completado |
| Documentación de triggers | Completado |
| Manifest / extracción de evidencias | Completado |

El bloque de scripts queda cerrado para LAB-04 v1.
