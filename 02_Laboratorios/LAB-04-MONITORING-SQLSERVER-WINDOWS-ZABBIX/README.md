# LAB-04 — Monitoring Stack for SQL Server & Windows

## Objetivo

Implementar un laboratorio de monitorización para SQL Server, Windows Server y Always On Availability Groups.

El laboratorio parte de una validación nativa previa con herramientas de Windows y SQL Server antes de desplegar monitorización centralizada con Zabbix.

## Alcance

- Monitorización nativa Windows / SQL Server.
- Performance Counters.
- PerfMon / logman.
- SQL Server DMVs.
- SQL Server Error Log.
- Windows Event Log.
- Validación de DNS, dominio y clúster.
- Preparación de scripts base.
- Despliegue posterior de Zabbix Server.
- Instalación posterior de Zabbix Agents.
- Checks personalizados para SQL Server y Always On.

## Entorno

| Máquina | Rol | IP |
|---|---|---|
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

Creación de la VM Ubuntu Server que alojará Zabbix Server.

### BLOQUE 3 — Instalación de Zabbix Server

Instalación y configuración inicial de Zabbix Server, base de datos y frontend web.

### BLOQUE 4 — Zabbix Agents

Instalación de agentes en servidores Windows y validación de hosts monitorizados.

### BLOQUE 5 — Monitorización SQL Server avanzada

Checks personalizados para:

- Always On.
- Backups.
- Jobs SQL Agent.
- Bloqueos.
- Wait stats.
- Auditoría.
- Hardening.

### BLOQUE 6 — Alertas, dashboards y evidencias

Creación de triggers, dashboards y documentación final del laboratorio.

## Estado actual

- BLOQUE 0 completado.
- BLOQUE 1 completado a nivel de validación nativa y scripts base.
- ORN-MON01 pendiente de creación.
- Zabbix pendiente de instalación.

## Documentación relacionada

- monitorizacion-nativa.md
- scripts/README.md
- scripts/sql/
- scripts/powershell/
- scripts/zabbix/

## Valor profesional

Este laboratorio demuestra capacidad para validar un entorno SQL Server Always On antes de desplegar monitorización centralizada, combinando herramientas nativas, PowerShell, SQL DMVs, Windows Event Log y posterior integración con Zabbix.
