# Mínimo privilegio — LAB-03 SQL Server

## Objetivo

Validar con usuarios reales que cada identidad funcional dispone solo de los permisos necesarios para su tarea.

Las pruebas se realizaron desde `ORN-DBA01` con SSMS, conectando al listener `ORN-SQLAG01` mediante Windows Authentication.

---

## Usuarios probados

| Usuario | Grupo principal | Función |
|---|---|---|
| `ORION\usr_sql_readonly` | `ORION\GG_SQL_READONLY` | Consulta de datos. |
| `ORION\usr_sql_audit` | `ORION\GG_SQL_AUDIT_READERS` | Consulta de auditoría. |
| `ORION\usr_sql_backupop` | `ORION\GG_SQL_BACKUP_OPERATORS` | Ejecución de backups. |

---

## Roles y permisos esperados

| Rol / permiso | Asignación |
|---|---|
| `db_datareader` | `ORION\GG_SQL_READONLY` |
| `db_backupoperator` | `ORION\GG_SQL_BACKUP_OPERATORS` |
| `ORION_AuditReaders` | `ORION\GG_SQL_AUDIT_READERS` |
| `VIEW SERVER SECURITY AUDIT` | `ORION\GG_SQL_AUDIT_READERS` |

---

## Usuario readonly

Resultado validado:

| Prueba | Resultado |
|---|---|
| `SELECT` sobre `lab.Clientes` | Permitido |
| `INSERT` sobre `lab.Clientes` | Denegado |
| `UPDATE` sobre `lab.Clientes` | Denegado |
| `DELETE` sobre `lab.Clientes` | Denegado |
| `db_datareader` | `1` |
| `db_datawriter` | `0` |
| `db_owner` | `0` |

Conclusión: el usuario puede consultar datos, pero no modificarlos.

---

## Usuario auditor

Resultado validado:

| Prueba | Resultado |
|---|---|
| Lectura de eventos `.sqlaudit` | Permitido |
| `SELECT` sobre `lab.Clientes` | Denegado |
| `ORION_AuditReaders` | `1` |
| `db_datareader` | `0` |
| `db_datawriter` | `0` |
| `db_owner` | `0` |

Conclusión: el usuario puede revisar trazabilidad sin acceder a datos de negocio.

---

## Usuario backup operator

Resultado validado:

| Prueba | Resultado |
|---|---|
| `BACKUP DATABASE OrionLabDB` | Permitido |
| `SELECT` sobre `lab.Clientes` | Denegado |
| `db_backupoperator` | `1` |
| `db_datareader` | `0` |
| `db_datawriter` | `0` |
| `db_owner` | `0` |

Fichero generado:

```text
B:\SQLBackups\ORION_PrivilegeTest_BackupOperator_COPYONLY.bak
```

Conclusión: el usuario puede realizar backups, pero no leer ni modificar datos.

---

## Resultado final

| Usuario | Función | Resultado |
|---|---|---|
| `ORION\usr_sql_readonly` | Consulta | Puede leer, no modificar. |
| `ORION\usr_sql_audit` | Auditoría | Puede leer auditoría, no datos. |
| `ORION\usr_sql_backupop` | Backup | Puede hacer backup, no leer datos. |

---

## Conclusión

La validación de mínimo privilegio quedó completada con usuarios reales. El laboratorio demuestra separación efectiva entre lectura, auditoría y backup, evitando permisos excesivos como `db_owner` o `db_datawriter` en perfiles funcionales.