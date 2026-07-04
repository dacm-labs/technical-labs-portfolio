# Alertas y triggers LAB-04

## Objetivo

Documentar los triggers personalizados creados en Zabbix para supervisar SQL Server, SQL Server Agent, Always On, bloqueos, jobs y antigüedad de backups.

## Template utilizado

| Elemento | Valor |
|---|---|
| Template | ORION SQL Server Custom Checks |
| Hosts enlazados | ORN-SQL01, ORN-SQL02 |
| Items por nodo | 10 |
| Triggers custom | 8 |
| Validación | zabbix_get, Latest data y Problems |

## Triggers creados

| Nº | Trigger | Severidad | Objetivo |
|---:|---|---|---|
| 1 | SQL custom ping failed | High | Detectar fallo general del check SQL custom. |
| 2 | SQL Server service down | Disaster | Detectar caída del Database Engine. |
| 3 | SQL Server Agent down | High | Detectar caída de SQL Server Agent. |
| 4 | Always On unhealthy | High | Detectar estado no saludable de Always On. |
| 5 | SQL blocking sessions detected | Warning | Detectar bloqueos activos. |
| 6 | SQL Agent failed jobs detected | Average | Detectar jobs fallidos en las últimas 24 horas. |
| 7 | SQL FULL backup old for OrionLabDB | Average | Detectar backup FULL antiguo en el primario. |
| 8 | SQL LOG backup old for OrionLabDB | Average | Detectar backup LOG antiguo en el primario. |

## Diseño primary-only

Los triggers de backup se diseñan para evitar falsos positivos en la réplica secundaria.

Condición base:

```text
last(/ORION SQL Server Custom Checks/orion.sql.ag.is_primary[OrionLabDB])=1
```

Esto significa que solo el host primario para OrionLabDB debe evaluar antigüedad de backup como problema operativo.

## Validación real de alerta

Se valida una alerta real:

```text
SQL LOG backup old for OrionLabDB on ORN-SQL01
```

Secuencia validada:

1. Zabbix detecta un LOG backup antiguo.
2. El trigger aparece en ORN-SQL01.
3. ORN-SQL02 no alerta porque es secundaria.
4. Se ejecuta un backup LOG manual en ORN-SQL01.
5. El backup queda registrado en msdb.
6. Zabbix recalcula el item.
7. El valor baja a 0 horas.
8. El problema pasa a RESOLVED.
9. El filtro de problemas SQL queda sin problemas custom activos.

## Resultado documentado

| Evidencia | Resultado |
|---|---|
| Problema generado | LOG backup old detectado en ORN-SQL01. |
| Falso positivo evitado | ORN-SQL02 no alerta por ser secundaria. |
| Acción correctiva | Backup LOG manual. |
| Verificación SQL | Backup registrado en msdb.dbo.backupset. |
| Verificación Zabbix | Item baja a 0 h y trigger se resuelve. |
| Estado final | Sin problemas SQL custom activos. |

## Capturas relacionadas

| Fichero | Evidencia |
|---|---|
| 10-problem-log-backup-detected.jpg | Problema detectado. |
| 11-backup-log-executed-msdb.jpg | Backup LOG registrado. |
| 12-problem-log-backup-resolved.jpg | Problema resuelto. |
| 13-problems-sql-no-active.jpg | Estado final limpio. |

## Ruido del template Windows

Durante la validación aparecen problemas genéricos del template Windows by Zabbix agent.

Decisión:

- No se mezclan con la validación SQL custom.
- No bloquean LAB-04.
- Quedan como mejora futura si se quiere afinar ruido operativo.

## Conclusión

Los triggers demuestran monitorización operativa útil: detectan un problema real, respetan el rol de Always On y validan recuperación tras una acción DBA concreta.
