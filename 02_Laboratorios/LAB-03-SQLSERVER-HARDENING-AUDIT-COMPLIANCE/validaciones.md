# Validaciones — LAB-03 SQL Server Hardening, Audit & Compliance

## Objetivo

Este documento resume las validaciones técnicas realizadas durante LAB-03 y el resultado final obtenido.

---

## 1. Preflight inicial

| Validación | Resultado |
|---|---|
| Resolución DNS de nodos | OK |
| Resolución del listener `ORN-SQLAG01` | OK |
| Puerto SQL Server `1433` | OK |
| Puerto HADR `5022` | OK |
| Puerto WSFC `3343` | OK |
| Conexión al listener | OK |
| Availability Group `ORION_AG01` | Healthy |
| `OrionLabDB` | Synchronized / Healthy |
| Jobs AG-aware | Validados en SQL01 y SQL02 |

---

## 2. Baseline de seguridad

| Área | Resultado inicial |
|---|---|
| SQL01 authentication | Windows-only |
| SQL02 authentication | Mixed Mode |
| `sa` SQL01 | Deshabilitado |
| `sa` SQL02 | Habilitado |
| Grupos AD SQL01 | Completos |
| Grupos AD SQL02 | Parciales |
| Auditoría SQL01 | Activa |
| Auditoría SQL02 | No configurada inicialmente |
| Linked servers | Sin externos en ambos nodos |
| Proxies SQL Agent | Ninguno en ambos nodos |

---

## 3. Validación post-hardening

| Validación | SQL01 | SQL02 |
|---|---|---|
| Windows-only | OK | OK |
| `sa` deshabilitado | OK | OK |
| `GG_SQL_READONLY` | OK | OK |
| `GG_SQL_BACKUP_OPERATORS` | OK | OK |
| `GG_SQL_AUDIT_READERS` | OK | OK |
| `GG_SQL_DBA_ADMINS` | OK | OK |
| `xp_cmdshell` | 0 | 0 |
| `Ole Automation Procedures` | 0 | 0 |
| `Ad Hoc Distributed Queries` | 0 | 0 |
| `clr enabled` | 0 | 0 |
| `cross db ownership chaining` | 0 | 0 |
| `remote admin connections` | 0 | 0 |
| `contained database authentication` | 0 | 0 |
| `show advanced options` | 0 | 0 |

---

## 4. Validación de auditoría

| Validación | Resultado |
|---|---|
| `ORION_ServerAudit` SQL01 | Activo |
| `ORION_ServerAudit` SQL02 | Activo |
| `ORION_ServerAuditSpec` SQL01 | Activa |
| `ORION_ServerAuditSpec` SQL02 | Activa |
| `audit_guid` SQL01/SQL02 | Alineado |
| Ruta auditoría | `D:\SQLAudit\` |
| Lectura `.sqlaudit` SQL01 | OK |
| Lectura `.sqlaudit` SQL02 | OK |
| Database Audit Specification | Activa sobre `OrionLabDB.lab.Clientes` |
| Eventos `SELECT/INSERT/UPDATE/DELETE` | Registrados |
| SELECT en secundaria read-only | Registrado |

---

## 5. Validación de mínimo privilegio

| Usuario | Permiso esperado | Resultado |
|---|---|---|
| `ORION\usr_sql_readonly` | Leer datos, no modificar | OK |
| `ORION\usr_sql_audit` | Leer auditoría, no datos de negocio | OK |
| `ORION\usr_sql_backupop` | Ejecutar backup, no leer datos | OK |

Detalle:

| Usuario | SELECT datos | INSERT | UPDATE | DELETE | Auditoría | Backup |
|---|---|---|---|---|---|---|
| `usr_sql_readonly` | Permitido | Denegado | Denegado | Denegado | No validado | No validado |
| `usr_sql_audit` | Denegado | No aplica | No aplica | No aplica | Permitido | No validado |
| `usr_sql_backupop` | Denegado | No aplica | No aplica | No aplica | No validado | Permitido |

---

## 6. Validación Always On final

| Elemento | Resultado |
|---|---|
| Availability Group | `ORION_AG01` |
| Primary final | `ORN-SQL01` |
| Secondary final | `ORN-SQL02` |
| Primary health | Online / Healthy |
| Secondary health | Connected / Healthy |
| Synchronization | Synchronized / Healthy |
| Availability mode | `SYNCHRONOUS_COMMIT` |
| Failover mode | `MANUAL` |
| Listener | `ORN-SQLAG01.orion.lab:1433` |

---

## 7. Resultado final de cumplimiento

| Área | Estado final |
|---|---|
| Hardening | Completado |
| Seguridad de logins | Completado |
| Windows-only | Completado |
| Superficie de ataque | Reducida |
| Auditoría servidor | Activa en ambos nodos |
| Auditoría base de datos | Activa sobre `lab.Clientes` |
| Trazabilidad | Validada con eventos reales |
| Mínimo privilegio | Validado con usuarios reales |
| Always On | Healthy |

---

## Conclusión

Las validaciones confirman que LAB-03 cumple su objetivo: endurecer y auditar un entorno SQL Server Always On sin afectar negativamente a la disponibilidad ni a la sincronización de `OrionLabDB`.