# Tecnologías LAB-04

## Objetivo

Documentar el stack técnico utilizado para desplegar la monitorización centralizada del LAB-04 sobre Windows Server, SQL Server y Always On Availability Groups.

## Plataforma base

| Tecnología | Uso |
|---|---|
| VMware Workstation | Virtualización local del laboratorio. |
| Windows Server | Controlador de dominio, SQL Server, File Share Witness y nodos monitorizados. |
| Windows 11 / ORN-DBA01 | Estación administrativa para SSMS, navegador, PowerShell y validaciones. |
| Ubuntu Server 26.04 LTS | Sistema operativo de ORN-MON01. |
| open-vm-tools | Integración VMware en ORN-MON01. |

## Monitorización centralizada

| Tecnología | Versión / uso |
|---|---|
| Zabbix Server | 7.0.27 LTS, servidor central de monitorización. |
| Zabbix Frontend | 7.0.27, interfaz web de operación. |
| Zabbix Agent | Agente local en ORN-MON01. |
| Zabbix Agent 2 | 7.0.27, agente en nodos Windows. |
| Zabbix template | `Windows by Zabbix agent` para monitorización base Windows. |
| Template custom | `ORION SQL Server Custom Checks` para métricas SQL específicas. |
| zabbix_get | Validación directa de items desde ORN-MON01. |

## Backend Zabbix

| Tecnología | Uso |
|---|---|
| PostgreSQL | Base de datos de Zabbix. |
| Apache | Servidor web del frontend. |
| PHP-FPM | Ejecución PHP del frontend Zabbix. |
| netplan / systemd-networkd | Configuración de red en Ubuntu. |
| SSH | Administración remota de ORN-MON01. |

## Monitorización nativa Windows / SQL Server

| Herramienta | Uso |
|---|---|
| Get-Counter | Inventario y lectura puntual de contadores Windows / SQL Server. |
| Performance Monitor | Validación clásica de contadores. |
| logman | Creación de Data Collector Sets y CSV de baseline. |
| Windows Event Log | Revisión de eventos críticos, errores y warnings. |
| FailoverClusters PowerShell module | Validación de grupos, recursos y nodos del clúster. |
| Resolve-DnsName / Test-NetConnection | Validación de DNS y puertos críticos. |

## SQL Server / DBA

| Tecnología | Uso |
|---|---|
| SQL Server 2025 Developer | Instancias SQL del laboratorio. |
| SQL Server Always On Availability Groups | Alta disponibilidad sobre `ORION_AG01`. |
| Windows Server Failover Cluster | Base del clúster `ORN-SQLCL01`. |
| SQL Server Agent | Jobs, historial y validaciones de operación. |
| msdb | Fuente para backups y jobs. |
| SQL Server Audit | Auditoría heredada del LAB-03. |
| DMVs SQL Server | Fuente de checks para sesiones, bloqueos, memoria, waits y HADR. |

## Automatización y checks custom

| Tecnología | Uso |
|---|---|
| PowerShell 5.1 / 7.x | Scripts de instalación, validación y checks SQL. |
| System.Data.SqlClient | Conexión SQL desde el wrapper PowerShell. |
| Windows Authentication | Ejecución de checks sin usuarios SQL ni contraseñas versionadas. |
| UserParameters Zabbix | Exposición de métricas SQL custom al agente. |
| YAML export Zabbix | Versionado del template `ORION SQL Server Custom Checks`. |

## Seguridad aplicada

| Control | Decisión |
|---|---|
| Contraseñas | No se documentan ni versionan. |
| Usuarios SQL | No se crean logins SQL para monitorización. |
| Hardening SQL | Se respeta Windows Authentication Only heredado del LAB-03. |
| Firewall Windows | TCP 10050 restringido a `10.10.20.70`. |
| Cookies / tokens | Capturas sensibles excluidas o recortadas. |
| Cuenta técnica | `ORION\svc_zbx_sqlmon` usada donde es viable. |

## Conclusión

El stack combina herramientas nativas de Windows / SQL Server con una plataforma libre de monitorización centralizada basada en Zabbix, manteniendo el hardening previo y añadiendo controles operativos reutilizables para SQL Server Always On.
