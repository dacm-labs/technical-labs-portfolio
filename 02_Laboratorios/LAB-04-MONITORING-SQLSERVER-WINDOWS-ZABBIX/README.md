# LAB-04 — Monitoring Stack for SQL Server & Windows

## Objetivo

Implementar un laboratorio de monitorización para SQL Server, Windows Server y Always On Availability Groups.

El laboratorio parte de una validación nativa previa con herramientas de Windows y SQL Server y evoluciona hacia monitorización centralizada con Zabbix 7.0 LTS.

## Alcance

- Monitorización nativa Windows / SQL Server.
- Performance Counters.
- PerfMon / logman.
- SQL Server DMVs.
- SQL Server Error Log.
- Windows Event Log.
- Validación de DNS, dominio y clúster.
- Despliegue de Zabbix Server.
- Instalación de Zabbix Agent 2 en nodos Windows.
- Checks personalizados para SQL Server y Always On.
- Preparación de template, items, triggers, dashboards y evidencias.

## Entorno

| Máquina | Rol | IP |
|---|---|---:|
| ORN-DC01 | Domain Controller / DNS | 10.10.20.10 |
| ORN-SQL01 | SQL Server primary replica | 10.10.20.20 |
| ORN-SQL02 | SQL Server secondary replica | 10.10.20.21 |
| ORN-SQLCL01 | WSFC Cluster Name | 10.10.20.50 |
| ORN-SQLAG01 | Always On Listener | 10.10.20.60 |
| ORN-FSW01 | File Share Witness | 10.10.20.40 |
| ORN-DBA01 | DBA workstation | 10.10.20.30 |
| ORN-MON01 | Zabbix Server | 10.10.20.70 |

## Bloques del laboratorio

### BLOQUE 0 — Preflight del entorno

Validación inicial de memoria, conectividad, DNS, puertos, Always On, backups, jobs, auditoría y hardening.

### BLOQUE 1 — Monitorización nativa Windows / SQL Server

Validación de herramientas nativas antes de Zabbix:

- Get-Counter.
- PerfMon / logman.
- SQL DMVs.
- SQL Error Log.
- Windows Event Log.
- Cluster PowerShell.
- DNS y secure channel.

### BLOQUE 2 — Creación de ORN-MON01

Creación de la VM Ubuntu Server que aloja Zabbix Server.

### BLOQUE 3 — Instalación de Zabbix Server

Instalación y configuración inicial de Zabbix Server 7.0 LTS, PostgreSQL y frontend web.

### BLOQUE 4 — Zabbix Agents

Instalación de Zabbix Agent 2 en nodos Windows y validación de hosts monitorizados.

### BLOQUE 5 — Monitorización SQL Server avanzada

Checks personalizados para:

- Conectividad SQL.
- Servicios SQL Server.
- SQL Server Agent.
- Always On.
- Backups.
- Jobs SQL Agent.
- Bloqueos.
- Sesiones.

### BLOQUE 6 — Alertas, dashboards y evidencias

Creación de template, items, triggers, dashboards y documentación final del laboratorio.

## Estado actual

- BLOQUE 0 completado.
- BLOQUE 1 completado.
- BLOQUE 2 completado.
- BLOQUE 3 completado.
- BLOQUE 4 completado.
- BLOQUE 5 completado a nivel de scripts, UserParameters y validación con zabbix_get.
- ORN-MON01 desplegado y operativo.
- Zabbix Server 7.0.27 operativo.
- Zabbix Agent 2 7.0.27 validado en nodos Windows.
- Checks SQL custom validados desde ORN-MON01 contra ORN-SQL01 y ORN-SQL02.
- Pendiente: template, items, triggers y dashboards en Zabbix UI.

## Documentación relacionada

- monitorizacion-nativa.md
- zabbix-server.md
- zabbix-agents.md
- sqlserver-monitoring.md
- validaciones.md
- scripts/README.md
- scripts/sql/
- scripts/powershell/
- scripts/zabbix/

## Valor profesional

Este laboratorio demuestra capacidad para validar un entorno SQL Server Always On antes de desplegar monitorización centralizada, combinando herramientas nativas, PowerShell, SQL DMVs, Windows Event Log, Zabbix Server, Zabbix Agent 2, UserParameters y checks SQL personalizados mediante Windows Authentication.
