# Tecnologías — LAB-02 SQL Server Always On

## Stack utilizado

| Tecnología | Uso |
|---|---|
| Windows Server 2025 | Sistema operativo de los servidores del laboratorio. |
| Windows 11 Pro | Estación administrativa `ORN-DBA01`. |
| Active Directory Domain Services | Dominio `orion.lab` y autenticación. |
| DNS | Resolución de nodos, clúster y listener. |
| SQL Server 2025 Enterprise Developer | Motor SQL Server en los dos nodos. |
| SQL Server Agent | Jobs de backup y mantenimiento. |
| Windows Server Failover Cluster | Clúster base para Always On. |
| Always On Availability Groups | Alta disponibilidad de `OrionLabDB`. |
| SQL Server Management Studio | Administración y validaciones. |
| PowerShell 7 | Automatización y comprobaciones. |
| VMware Workstation | Virtualización del laboratorio. |

## Herramientas administrativas

- SQL Server Management Studio.
- SQL Server Configuration Manager.
- Failover Cluster Manager.
- PowerShell 7.
- DNS Manager.
- Active Directory Users and Computers.
- Event Viewer.

## Componentes reutilizados de LAB-01

- Dominio `orion.lab`.
- `ORN-DC01`.
- `ORN-SQL01`.
- `ORN-DBA01`.
- Base `OrionLabDB`.
- Cuentas de servicio SQL.
- Estructura de discos y backups.

## Componentes añadidos en LAB-02

- `ORN-SQL02`.
- `ORN-FSW01`.
- Clúster `ORN-SQLCL01`.
- Availability Group `ORION_AG01`.
- Listener `ORN-SQLAG01`.
- Endpoint HADR `5022`.
- Jobs AG-aware.

## Puertos validados

| Puerto | Uso | Estado final |
|---:|---|---|
| `1433` | SQL Server y listener | Validado. |
| `5022` | Endpoint HADR | Validado. |
| `3343` | Clúster WSFC | Validado. |

