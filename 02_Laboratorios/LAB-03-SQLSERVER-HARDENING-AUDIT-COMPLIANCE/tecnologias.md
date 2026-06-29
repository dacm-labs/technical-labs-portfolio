# Tecnologías — LAB-03 SQL Server Hardening, Audit & Compliance

## Stack principal

| Tecnología | Uso en el laboratorio |
|---|---|
| Windows Server 2025 | Controlador de dominio, nodos SQL Server y File Share Witness. |
| Windows 11 Pro | Estación administrativa `ORN-DBA01`. |
| Active Directory Domain Services | Dominio `orion.lab`, usuarios, grupos y autenticación integrada. |
| DNS | Resolución de nodos, listener y servicios del laboratorio. |
| SQL Server 2025 Developer | Motor de base de datos, Always On, auditoría, SQL Agent y roles. |
| SQL Server Management Studio | Administración, validaciones T-SQL y pruebas con usuarios reales. |
| PowerShell 7 | Validación de DNS, puertos, servicios, rutas y ficheros. |
| Windows Server Failover Cluster | Base del Availability Group. |
| SQL Server Always On Availability Groups | Alta disponibilidad de `OrionLabDB`. |

---

## Componentes SQL Server utilizados

| Componente | Uso |
|---|---|
| Database Engine | Motor principal para `OrionLabDB`. |
| Always On Availability Groups | Replicación síncrona entre `ORN-SQL01` y `ORN-SQL02`. |
| HADR endpoint | Comunicación entre réplicas por puerto `5022`. |
| SQL Server Audit | Auditoría de servidor y base de datos. |
| SQL Server Agent | Validación de jobs AG-aware heredados del LAB-02. |
| `sys.fn_get_audit_file` | Lectura de eventos `.sqlaudit`. |
| Catálogos del sistema | Inventario de logins, roles, permisos, endpoints y auditorías. |

---

## PowerShell

PowerShell se utilizó para:

- Validar resolución DNS.
- Comprobar conectividad TCP.
- Reiniciar servicios de SQL Server de forma controlada.
- Crear carpetas para auditoría y backups.
- Validar existencia de ficheros de backup.
- Abrir SSMS con `runas /netonly` para pruebas con identidades de dominio.

---

## T-SQL

T-SQL se utilizó para:

- Inventariar configuración base de las instancias.
- Validar Always On y estado de réplicas.
- Revisar logins, roles y permisos.
- Cambiar SQL02 a Windows Authentication only.
- Deshabilitar `sa`.
- Crear y validar logins de grupos AD.
- Configurar SQL Server Audit.
- Alinear `audit_guid` entre réplicas.
- Crear una Database Audit Specification sobre `lab.Clientes`.
- Generar eventos auditados.
- Validar mínimo privilegio con usuarios reales.

---

## Controles de seguridad trabajados

| Control | Tecnología asociada |
|---|---|
| Autenticación centralizada | Active Directory + Windows Authentication |
| Reducción de superficie | `sys.configurations` / `sp_configure` |
| Deshabilitación de `sa` | SQL Server logins |
| Separación de funciones | Grupos AD + roles SQL Server |
| Auditoría servidor | SQL Server Audit |
| Auditoría base de datos | Database Audit Specification |
| Trazabilidad | Ficheros `.sqlaudit` |
| Mínimo privilegio | Roles `db_datareader`, `db_backupoperator`, rol custom `ORION_AuditReaders` |
| Alta disponibilidad segura | Always On + WSFC |

---

## Herramientas de documentación

- Markdown para documentación pública en GitHub.
- Capturas del laboratorio como evidencias visuales.
- Documento Word privado como memoria completa del proceso.
- GitHub como portfolio técnico navegable.

---

## Criterio de publicación

La documentación pública evita exponer credenciales, contraseñas, datos personales o correos completos. Las capturas sensibles deben anonimizarse antes de publicarse.