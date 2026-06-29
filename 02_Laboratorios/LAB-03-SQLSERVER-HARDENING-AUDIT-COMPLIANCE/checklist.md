# Checklist — LAB-03 SQL Server Hardening, Audit & Compliance

## Estado general

| Item | Estado |
|---|---|
| LAB-03 finalizado | ✅ |
| Entorno Always On operativo | ✅ |
| Documentación pública creada | ✅ |
| Memoria Word completa mantenida como documento privado | ✅ |
| Capturas sensibles revisadas antes de publicar | ✅ |

---

## Preflight y baseline

| Validación | Estado |
|---|---|
| DNS de nodos validado | ✅ |
| Listener `ORN-SQLAG01` resuelve correctamente | ✅ |
| Puerto `1433` validado | ✅ |
| Puerto HADR `5022` validado | ✅ |
| Puerto WSFC `3343` validado | ✅ |
| Conexión por listener validada | ✅ |
| `ORION_AG01` healthy | ✅ |
| `OrionLabDB` synchronized / healthy | ✅ |
| Jobs AG-aware revisados | ✅ |

---

## Hardening

| Control | SQL01 | SQL02 |
|---|---|---|
| Windows Authentication only | ✅ | ✅ |
| `sa` deshabilitado | ✅ | ✅ |
| `show advanced options` deshabilitado | ✅ | ✅ |
| `xp_cmdshell` deshabilitado | ✅ | ✅ |
| `Ole Automation Procedures` deshabilitado | ✅ | ✅ |
| `Ad Hoc Distributed Queries` deshabilitado | ✅ | ✅ |
| `clr enabled` deshabilitado | ✅ | ✅ |
| `cross db ownership chaining` deshabilitado | ✅ | ✅ |
| `remote admin connections` deshabilitado | ✅ | ✅ |
| `contained database authentication` deshabilitado | ✅ | ✅ |

---

## Seguridad y permisos

| Control | Estado |
|---|---|
| `ORION\GG_SQL_DBA_ADMINS` presente | ✅ |
| `ORION\GG_SQL_READONLY` presente | ✅ |
| `ORION\GG_SQL_BACKUP_OPERATORS` presente | ✅ |
| `ORION\GG_SQL_AUDIT_READERS` presente | ✅ |
| Roles de base de datos revisados | ✅ |
| Permisos explícitos revisados | ✅ |
| Sin linked servers externos | ✅ |
| Sin SQL Agent proxies | ✅ |
| Credenciales revisadas y marcadas como sensibles | ✅ |

---

## Auditoría

| Control | SQL01 | SQL02 |
|---|---|---|
| `ORION_ServerAudit` activo | ✅ | ✅ |
| `ORION_ServerAuditSpec` activa | ✅ | ✅ |
| Ruta `D:\SQLAudit\` validada | ✅ | ✅ |
| `audit_guid` alineado | ✅ | ✅ |
| Lectura con `sys.fn_get_audit_file` | ✅ | ✅ |
| Eventos de login registrados | ✅ | ✅ |
| Eventos de seguridad de servidor auditados | ✅ | ✅ |

---

## Auditoría de base de datos

| Control | Estado |
|---|---|
| `ORION_OrionLabDB_AuditSpec` creada | ✅ |
| Auditoría sobre `lab.Clientes` activa | ✅ |
| `SELECT` auditado | ✅ |
| `INSERT` auditado | ✅ |
| `UPDATE` auditado | ✅ |
| `DELETE` auditado | ✅ |
| Lectura de eventos en SQL01 | ✅ |
| Lectura de eventos en SQL02 | ✅ |
| SELECT en secundaria read-only auditado | ✅ |

---

## Mínimo privilegio

| Usuario | Validación | Estado |
|---|---|---|
| `ORION\usr_sql_readonly` | Lee datos y no modifica | ✅ |
| `ORION\usr_sql_audit` | Lee auditoría y no datos de negocio | ✅ |
| `ORION\usr_sql_backupop` | Ejecuta backup y no lee datos | ✅ |

---

## Always On final

| Validación | Estado |
|---|---|
| `ORN-SQL01` primary final | ✅ |
| `ORN-SQL02` secondary final | ✅ |
| Réplicas conectadas | ✅ |
| Sincronización healthy | ✅ |
| `OrionLabDB` no suspendida | ✅ |
| Listener operativo | ✅ |
| Modo `SYNCHRONOUS_COMMIT` | ✅ |
| Failover manual documentado como diseño actual | ✅ |

---

## Publicación GitHub

| Criterio | Estado |
|---|---|
| No publicar contraseñas | ✅ |
| No publicar memoria Word completa | ✅ |
| Evitar correos visibles en capturas | ✅ |
| Usar Markdown navegable | ✅ |
| Separar README, arquitectura, hardening, auditoría, validaciones y evidencias | ✅ |
| Mantener nombres internos explicados como nomenclatura de laboratorio | ✅ |

---

## Resultado

LAB-03 queda validado como **completado v1**.