# Monitorización nativa Windows / SQL Server

## Objetivo

Validar las capacidades de monitorización nativa disponibles antes de desplegar Zabbix.

Este bloque sirve como baseline operativo inicial para SQL Server, SQL Server Agent, Always On, contadores de rendimiento, Windows Event Log, DNS y clúster.

## Estado validado

### Servicios SQL Server

Nodos validados:

- ORN-SQL01
- ORN-SQL02

Servicios comprobados:

- MSSQLSERVER
- SQLSERVERAGENT

Resultado:

- SQL Server Engine: Running / Automatic
- SQL Server Agent: Running / Automatic
- Cuenta SQL Engine: ORION\svc_sql_engine
- Cuenta SQL Agent: ORION\svc_sql_agent

## Contadores nativos SQL Server

Se validó la disponibilidad de contadores SQL Server mediante PowerShell con Get-Counter.

Contadores relevantes detectados:

- SQLServer:Availability Group
- SQLServer:Availability Replica
- SQLServer:Buffer Manager
- SQLServer:General Statistics
- SQLServer:Locks
- SQLServer:SQL Statistics
- SQLServer:Wait Statistics
- SQLAgent:Jobs
- SQLAgent:JobSteps

Resultado:

- ORN-SQL01: contadores SQL disponibles.
- ORN-SQL02: contadores SQL disponibles.

## Lectura rápida de contadores

Se validaron contadores base en ambos nodos SQL:

- CPU
- Memoria disponible
- Espacio libre en disco
- Batch Requests/sec
- User Connections
- Page Life Expectancy
- Lock Waits/sec
- Number of Deadlocks/sec

Resultado:

- ORN-SQL01: lectura de contadores OK.
- ORN-SQL02: lectura de contadores OK.

## PerfMon y logman

Se crearon Data Collector Sets nativos con logman para generar CSV de baseline.

### ORN-SQL01

- Collector: ORION_SQL01_BASELINE
- Ruta: D:\Monitoring\PerfMon\ORION_SQL01_BASELINE\
- CSV generado correctamente.
- Collector iniciado y detenido correctamente.

### ORN-SQL02

- Collector: ORION_SQL02_BASELINE
- Ruta: D:\Monitoring\PerfMon\ORION_SQL02_BASELINE\
- CSV generado correctamente.
- Collector iniciado y detenido correctamente.

## SQL Server Error Log

Se validó el acceso al SQL Server Error Log desde T-SQL mediante xp_readerrorlog.

Resultado:

- ORN-SQL01: SQL Error Log accesible.
- ORN-SQL02: SQL Error Log accesible.

Se observaron eventos recientes de arranque SQL Server, CHECKDB y Always On.

## Windows Event Log

Se revisó el log System en ORN-SQL01 y ORN-SQL02.

Eventos observados:

- Microsoft-Windows-Time-Service
- Microsoft-Windows-DNS-Client
- Microsoft-Windows-FailoverClustering
- Microsoft-Windows-TPM-WMI
- Microsoft-Windows-DistributedCOM
- LsaSrv

Conclusión:

- No se detectó impacto operativo actual.
- Los eventos de clúster se consideran transitorios por reinicio o redimensionado de VMs.
- Se validó posteriormente que el clúster estaba online.

## Clúster y Always On

Estado validado:

- ORION_AG01: Online
- OwnerNode: ORN-SQL01
- ORN-SQL01: Up
- ORN-SQL02: Up
- File Share Witness: Online
- Listener ORN-SQLAG01: operativo

Conclusión:

- Always On queda saludable tras el redimensionamiento de memoria.
- Los eventos previos de clúster quedan como hallazgo transitorio.

## Hallazgo DNS en ORN-SQL02

Durante la revisión se detectó resolución local de ORN-SQL02 hacia la IP APIPA 169.254.2.19.

Causa:

- Microsoft Failover Cluster Virtual Adapter.

Acción aplicada:

- Se desactivó el registro DNS del adaptador virtual de clúster en ORN-SQL02.

Validación final:

- DNS del dominio en ORN-DC01 limpio.
- ORN-SQL02.orion.lab desde ORN-DBA01 resuelve a 10.10.20.21.
- Puertos 1433, 5022 y 445 hacia ORN-SQL02: OK.

Conclusión:

- Sin impacto operativo actual.
- Hallazgo documentado como parte del baseline.

## Scripts generados

### PowerShell

- 02-check-sql-services.ps1
- 05-create-perfmon-baseline-collector.ps1
- 06-check-windows-critical-events.ps1
- 07-check-cluster-dns-health.ps1

### SQL

- 01-baseline-sql-monitoring.sql
- 02-dmv-blocking-sessions.sql
- 03-dmv-wait-stats.sql
- 04-alwayson-health.sql
- 05-backup-age-check.sql
- 06-agent-jobs-check.sql
- 07-audit-status-check.sql
- 08-hardening-status-check.sql

## Conclusión

La monitorización nativa queda validada como baseline inicial antes del despliegue de Zabbix.

Este baseline servirá para comparar posteriormente la monitorización centralizada con Zabbix.
