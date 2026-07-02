# SQL Server Monitoring

## Objetivo

Documentar la validación inicial de los scripts SQL de monitorización preparados para el LAB-04, ejecutados desde ORN-DBA01 mediante SSMS contra los nodos SQL Server del entorno Always On.

Esta fase valida que las consultas base funcionan antes de integrarlas como checks custom en Zabbix mediante Zabbix Agent 2, UserParameters y scripts auxiliares.

## Entorno validado

| Elemento | Valor |
|---|---|
| Servidor administrativo | ORN-DBA01 |
| Herramienta | SQL Server Management Studio |
| Listener Always On | ORN-SQLAG01.orion.lab |
| Puerto listener | 1433 |
| Nodo primario | ORN-SQL01 |
| Nodo secundario | ORN-SQL02 |
| Availability Group | ORION_AG01 |
| Base protegida por AG | OrionLabDB |

## Scripts SQL validados

| Script | Objetivo |
|---|---|
| 01-baseline-sql-monitoring.sql | Estado general de instancia, memoria, sesiones, waits y Always On |
| 02-dmv-blocking-sessions.sql | Sesiones bloqueantes y bloqueadas |
| 03-dmv-wait-stats.sql | Wait stats principales |
| 04-alwayson-health.sql | Estado de Availability Groups, réplicas, bases y listener |
| 05-backup-age-check.sql | Edad de backups FULL, DIFF y LOG |
| 06-agent-jobs-check.sql | Jobs de SQL Server Agent y últimas ejecuciones |
| 07-audit-status-check.sql | Estado de SQL Server Audit y Database Audit Specification |
| 08-hardening-status-check.sql | Parámetros de hardening y autenticación |

## Validación en ORN-SQL01 / listener

La validación contra `tcp:ORN-SQLAG01.orion.lab,1433` se ejecuta correctamente desde SSMS en ORN-DBA01.

Resultados destacados:

| Elemento | Resultado |
|---|---|
| ConnectedServer | ORN-SQL01 |
| MachineName | ORN-SQL01 |
| IsHadrEnabled | 1 |
| HadrManagerStatus | 1 |
| Availability Group | ORION_AG01 |
| Rol local | PRIMARY |
| Réplica secundaria | ORN-SQL02 |
| Estado de réplicas | CONNECTED / HEALTHY |
| Modo de disponibilidad | SYNCHRONOUS_COMMIT |
| Listener | ORN-SQLAG01 |
| Listener IP | 10.10.20.60 |
| Listener Port | 1433 |
| Base OrionLabDB | ONLINE / SYNCHRONIZED / HEALTHY |
| SQL Server Audit | ORION_ServerAudit activo |
| Server Audit Specification | ORION_ServerAuditSpec activa |
| Database Audit Specification | ORION_OrionLabDB_AuditSpec activa |
| Hardening | WindowsAuthOnly habilitado, HADR activo y opciones sensibles deshabilitadas |

También se validan correctamente los resultados de:

- Información de instancia SQL Server.
- Memoria y CPU.
- Sesiones de usuario.
- Wait stats principales.
- Backups recientes.
- Jobs de SQL Server Agent.
- Sesiones bloqueantes.
- Estado de auditoría.
- Estado de hardening.

## Validación en ORN-SQL02

La validación contra `tcp:ORN-SQL02.orion.lab,1433` confirma el estado saludable del nodo secundario Always On.

Resultado DMV sobre OrionLabDB:

| Elemento | Resultado |
|---|---|
| ConnectedServer | ORN-SQL02 |
| MachineName | ORN-SQL02 |
| DatabaseName | OrionLabDB |
| is_local | 1 |
| is_primary_replica | 0 |
| synchronization_state_desc | SYNCHRONIZED |
| synchronization_health_desc | HEALTHY |
| database_state_desc | ONLINE |

Durante la ejecución inicial de los scripts se detecta un comportamiento esperado en entornos Always On: determinados checks de base de datos pueden fallar en una réplica secundaria si la conexión no se realiza con intención de lectura.

El mensaje detectado indica que la base `OrionLabDB` pertenece a un Availability Group y que, en el contexto de réplica secundaria, requiere una conexión adecuada para lectura.

## Validación con ApplicationIntent=ReadOnly

Para validar los checks de auditoría sobre SQL02, se crea una conexión nueva desde SSMS hacia:

```text
tcp:ORN-SQL02.orion.lab,1433
```

Con el parámetro adicional:

```text
ApplicationIntent=ReadOnly
```

Con esta conexión, el script `07-audit-status-check.sql` se ejecuta correctamente sobre el nodo secundario.

Resultado destacado:

| Elemento | Resultado |
|---|---|
| ConnectedServer | ORN-SQL02 |
| MachineName | ORN-SQL02 |
| Server Audit | ORION_ServerAudit activo |
| Server Audit Specification | ORION_ServerAuditSpec activa |
| Database Audit Specification | ORION_OrionLabDB_AuditSpec activa |

## Hallazgo técnico

La validación demuestra una diferencia importante entre tipos de checks:

| Tipo de check | Ejecución recomendada |
|---|---|
| Checks de instancia SQL Server | SQL01 y SQL02 |
| Checks de Always On | SQL01 y SQL02 |
| Checks de base de datos sobre OrionLabDB | Primario, listener o conexión ReadOnly cuando aplique |
| Checks de auditoría database-level | Primario, listener o conexión ReadOnly en secundario |
| Checks de backups y jobs | Diseñar teniendo en cuenta el rol de cada réplica |

Este comportamiento es normal en arquitecturas Always On y debe tenerse en cuenta antes de convertir las consultas en checks automáticos de Zabbix.

## Criterio para integración con Zabbix

La futura integración con Zabbix deberá evitar falsos positivos en réplicas secundarias.

Los checks custom deberán diseñarse con una lógica segura:

- Si el check es de instancia, puede ejecutarse localmente en cada nodo SQL.
- Si el check es de Always On, puede ejecutarse en ambos nodos.
- Si el check depende de una base de datos protegida por AG, debe ejecutarse contra el primario, contra el listener o usando conexión ReadOnly cuando aplique.
- Si el nodo no es primario para `OrionLabDB`, el check debe devolver un valor controlado y no generar error no tratado.

## Conclusión

Los scripts SQL de monitorización quedan validados manualmente sobre el entorno SQL Server Always On.

La validación confirma que el entorno está preparado para la siguiente fase del LAB-04:

- Crear checks SQL que devuelvan valores únicos.
- Crear wrapper PowerShell para ejecución desde Zabbix Agent 2.
- Definir UserParameters personalizados.
- Probar los checks mediante `zabbix_get` desde ORN-MON01.
- Crear items y triggers en Zabbix.
- Documentar resultados y evidencias.

Esta fase deja establecida la base técnica para pasar de monitorización Windows general a monitorización DBA específica sobre SQL Server y Always On.
