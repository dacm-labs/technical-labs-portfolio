# Auditoría y trazabilidad — LAB-03 SQL Server

## Objetivo

Configurar y validar una capa de auditoría coherente en un entorno SQL Server Always On, cubriendo eventos de servidor y operaciones específicas sobre la base de datos `OrionLabDB`.

---

## Auditoría de servidor

Se validó y alineó la auditoría de servidor en ambos nodos SQL Server.

| Elemento | Valor |
|---|---|
| Server Audit | `ORION_ServerAudit` |
| Server Audit Specification | `ORION_ServerAuditSpec` |
| Destino | FILE |
| Ruta | `D:\SQLAudit\` |
| On failure | `CONTINUE` |
| Queue delay | `1000` |
| Max file size | `100 MB` |
| Max rollover files | `10` |

---

## Eventos auditados a nivel servidor

La especificación `ORION_ServerAuditSpec` registra eventos relevantes para seguridad y cumplimiento:

| Evento | Finalidad |
|---|---|
| `AUDIT_CHANGE_GROUP` | Cambios en auditorías. |
| `FAILED_LOGIN_GROUP` | Inicios de sesión fallidos. |
| `SUCCESSFUL_LOGIN_GROUP` | Inicios de sesión correctos. |
| `SERVER_PERMISSION_CHANGE_GROUP` | Cambios de permisos a nivel servidor. |
| `SERVER_PRINCIPAL_CHANGE_GROUP` | Cambios en logins/principales. |
| `SERVER_ROLE_MEMBER_CHANGE_GROUP` | Cambios en membresía de roles de servidor. |

---

## Alineación de audit_guid

Durante el laboratorio se detectó que SQL01 y SQL02 tenían GUID de auditoría diferentes. En un entorno Always On, esta diferencia puede generar problemas si una Database Audit Specification referencia una auditoría con GUID distinto tras un failover.

Se recreó la auditoría de SQL02 con el mismo `audit_guid` de SQL01:

```text
71C8B8E7-2FA2-4F45-8EF0-29AF15D30A28
```

Resultado final:

| Nodo | Server Audit | Audit GUID | Estado |
|---|---|---|---|
| `ORN-SQL01` | `ORION_ServerAudit` | `71C8B8E7-2FA2-4F45-8EF0-29AF15D30A28` | Activo |
| `ORN-SQL02` | `ORION_ServerAudit` | `71C8B8E7-2FA2-4F45-8EF0-29AF15D30A28` | Activo |

---

## Auditoría de base de datos

Se creó una Database Audit Specification sobre la base `OrionLabDB`.

| Elemento | Valor |
|---|---|
| Database Audit Specification | `ORION_OrionLabDB_AuditSpec` |
| Base de datos | `OrionLabDB` |
| Esquema | `lab` |
| Objeto | `Clientes` |
| Principal auditado | `public` |

Acciones auditadas:

- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`

---

## Eventos generados

Para validar la auditoría se ejecutaron operaciones reales sobre `lab.Clientes`:

| Acción | Resultado |
|---|---|
| `SELECT TOP (5)` | Correcto |
| `UPDATE ... WHERE 1 = 0` | Correcto, sin modificar filas |
| `DELETE ... WHERE 1 = 0` | Correcto, sin borrar filas |
| `INSERT DEFAULT VALUES` | Falló por restricción `NOT NULL`, pero dejó intento auditado |

También se validó un `SELECT` desde `ORN-SQL02` en modo secundaria read-only.

---

## Lectura de auditoría

La lectura de eventos se realizó con:

```sql
SELECT TOP (100)
    event_time,
    action_id,
    succeeded,
    server_principal_name,
    database_name,
    schema_name,
    object_name,
    statement
FROM sys.fn_get_audit_file('D:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
WHERE database_name = N'OrionLabDB'
   OR object_name = N'Clientes'
   OR statement LIKE N'%lab.Clientes%'
ORDER BY event_time DESC;
```

Eventos observados:

| `action_id` | Significado |
|---|---|
| `SL` | SELECT |
| `IN` | INSERT |
| `UP` | UPDATE |
| `DL` | DELETE |
| `CR` | CREATE |
| `DR` | DROP |
| `AL` | ALTER |
| `LGIS` | Successful login |

---

## Validación en SQL02

La auditoría también se validó en la réplica secundaria:

- `ORION_ServerAudit` activo.
- `ORION_ServerAuditSpec` activo.
- `audit_guid` alineado con SQL01.
- `ORION_OrionLabDB_AuditSpec` visible y activa en `OrionLabDB`.
- SELECT sobre `lab.Clientes` registrado correctamente desde la secundaria.

---

## Resultado final

| Control | SQL01 | SQL02 |
|---|---|---|
| Server Audit | Activo | Activo |
| Server Audit Specification | Activa | Activa |
| Audit GUID | Alineado | Alineado |
| Ruta auditoría | `D:\SQLAudit\` | `D:\SQLAudit\` |
| Database Audit Specification | Activa | Visible y activa |
| Eventos sobre `lab.Clientes` | Validados | Validados |

---

## Conclusión

LAB-03 deja el entorno Always On con una capa de auditoría operativa y coherente entre réplicas. Se auditan eventos críticos a nivel servidor y operaciones de datos sobre `OrionLabDB.lab.Clientes`.

La alineación del `audit_guid` aporta valor específico en escenarios Always On, porque prepara la auditoría para mantenerse coherente tras un posible failover.