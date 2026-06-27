# Seguridad SQL — LAB-01 SQL Server DBA

## Objetivo

Este documento resume el bloque de seguridad SQL del LAB-01.

El objetivo fue aplicar mínimo privilegio usando grupos de Active Directory, logins Windows, usuarios de base de datos y roles específicos dentro de `OrionLabDB`.

## Grupos Active Directory

| Grupo | Función |
|---|---|
| `GG_SQL_DBA_ADMINS` | Administración DBA. |
| `GG_SQL_READONLY` | Lectura de datos. |
| `GG_SQL_BACKUP_OPERATORS` | Operaciones de backup. |
| `GG_SQL_AUDIT_READERS` | Lectura limitada de auditoría. |
| `GG_SQL_SERVICE_ACCOUNTS` | Cuentas de servicio SQL. |

## Usuarios de prueba

| Usuario | Grupo | Resultado esperado |
|---|---|---|
| `usr_sql_readonly` | `GG_SQL_READONLY` | SELECT permitido, escritura denegada. |
| `usr_sql_backupop` | `GG_SQL_BACKUP_OPERATORS` | BACKUP permitido, SELECT denegado. |
| `usr_sql_audit` | `GG_SQL_AUDIT_READERS` | Lectura limitada al esquema `audit`. |
| `usr_sql_noperms` | Sin grupo SQL | Acceso denegado a SQL Server. |

## Roles SQL

| Rol / permiso | Miembro |
|---|---|
| `sysadmin` | `ORION\GG_SQL_DBA_ADMINS` |
| `db_datareader` | `ORION\GG_SQL_READONLY` |
| `db_backupoperator` | `ORION\GG_SQL_BACKUP_OPERATORS` |
| `ORION_AuditReaders` | `ORION\GG_SQL_AUDIT_READERS` |

## Validaciones

Se validaron cuatro perfiles:

- Readonly: puede consultar datos, pero no puede insertar.
- Backup operator: puede lanzar backup, pero no puede leer tablas generales.
- Audit reader: puede leer objetos del esquema `audit`, pero no tablas generales.
- No permissions: no puede iniciar sesión en SQL Server.

## Valor profesional

Este bloque demuestra segregación de funciones, uso de grupos AD, acceso basado en roles, pruebas reales de permisos y aplicación práctica del principio de mínimo privilegio.

## Evidencias

- [13-seguridad-minimo-privilegio.png](capturas/13-seguridad-minimo-privilegio.png)

Galería completa: [evidencias.md](evidencias.md).

