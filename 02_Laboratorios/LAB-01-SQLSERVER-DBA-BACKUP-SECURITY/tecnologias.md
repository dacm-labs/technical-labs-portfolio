# Tecnologías — LAB-01 SQL Server DBA

## Stack principal

El LAB-01 utiliza un stack Microsoft orientado a administración profesional de SQL Server dentro de un entorno de dominio controlado.

| Área | Tecnología / componente | Uso en el laboratorio |
|---|---|---|
| Directorio | Active Directory Domain Services | Dominio `orion.lab`, OUs, grupos y cuentas de servicio. |
| DNS | Windows Server DNS | Resolución directa e inversa de la red `10.10.20.0/24`. |
| Sistema servidor | Windows Server 2025 | Base para `ORN-DC01` y `ORN-SQL01`. |
| Estación cliente | Windows 11 Pro | Base para `ORN-DBA01`, estación administrativa DBA. |
| Base de datos | SQL Server 2025 Developer Edition | Instancia principal en `ORN-SQL01`. |
| Administración SQL | SQL Server Management Studio | Administración remota desde `ORN-DBA01`. |
| Automatización SQL | SQL Server Agent | Jobs de backup, CHECKDB, limpieza y alertas. |
| Correo SQL | Database Mail | Envío de notificaciones operativas desde SQL Server. |
| Relay SMTP | Relay técnico dedicado | Salida de correo usada para validar Database Mail. |
| Scripting | T-SQL | Bases, logins, roles, backups, restores, auditoría y vistas DBA. |
| Automatización sistema | PowerShell | Configuración de red, DNS, discos, permisos y validaciones. |
| Auditoría | SQL Server Audit | Trazabilidad de logins, cambios de permisos y eventos. |
| Rendimiento | Query Store | Comparativa de consulta lenta frente a consulta optimizada. |
| Documentación | Markdown + GitHub | Publicación del laboratorio en formato portfolio técnico. |
| Virtualización | VMware Workstation | Ejecución de las máquinas del laboratorio. |

## Componentes SQL Server utilizados

| Componente | Estado | Detalle |
|---|---|---|
| Database Engine Services | Instalado | Motor principal de SQL Server. |
| Instancia por defecto | Configurada | Instancia principal del laboratorio. |
| SQL Server Agent | Activo | Automatización de mantenimiento y alertas. |
| SQL Server Browser | Deshabilitado | No necesario al usar instancia por defecto. |
| SQL Writer | Activo | Servicio auxiliar para operaciones VSS. |
| Query Store | Activado | Análisis de consultas y planes. |
| Database Mail | Activado | Perfil de correo operativo del laboratorio. |
| SQL Server Audit | Activado | Auditoría de eventos relevantes. |

## Herramientas de administración

La administración del entorno se realiza principalmente desde `ORN-DBA01`, evitando instalar herramientas cliente innecesarias sobre el servidor SQL.

Herramientas usadas:

- SQL Server Management Studio.
- PowerShell 7.
- Consolas administrativas de Windows Server.
- SQL Server Configuration Manager.
- VMware Workstation.

## Almacenamiento SQL

El laboratorio separa rutas para:

- Datos.
- Logs de transacciones.
- TempDB.
- Backups FULL, DIFF y LOG.
- Ficheros de auditoría.

Esta separación mejora la claridad operativa del entorno y permite explicar buenas prácticas básicas de administración SQL Server.

## Decisiones técnicas relevantes

- Uso de autenticación Windows integrada con Active Directory.
- Administración remota desde una estación DBA separada.
- Apertura controlada del puerto SQL solo desde la estación administrativa.
- Separación de rutas para datos, logs, TempDB, backups y auditoría.
- Uso de grupos AD para aplicar mínimo privilegio.
- Activación de Database Mail para notificación de fallos.
- Uso de SQL Server Audit y Query Store para trazabilidad y diagnóstico.
- Preparación del laboratorio como base para una futura fase Always On.
