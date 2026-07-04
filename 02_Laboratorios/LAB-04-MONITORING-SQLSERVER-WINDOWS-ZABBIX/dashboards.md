# Dashboards LAB-04

## Objetivo

Documentar el enfoque visual utilizado en LAB-04 para validar monitorización, métricas, problemas y recuperación operativa en Zabbix.

En la versión v1 no se crea un dashboard ejecutivo dedicado. La validación se apoya en vistas nativas de Zabbix que demuestran funcionamiento real: Dashboard inicial, Hosts, Latest data, Problems, template, items y triggers.

## Vistas utilizadas

| Vista Zabbix | Uso |
|---|---|
| Dashboard inicial | Confirmar Zabbix Server operativo y sin problemas iniciales relevantes. |
| Data collection > Hosts | Confirmar cobertura de hosts y disponibilidad ZBX verde. |
| Latest data | Validar recolección de métricas Windows y SQL custom. |
| Problems | Validar detección, estado PROBLEM y recuperación RESOLVED. |
| Templates | Confirmar creación del template ORION SQL Server Custom Checks. |
| Items | Confirmar 10 items SQL custom por host SQL. |
| Triggers | Confirmar 8 triggers custom con severidades. |

## Validación visual publicada

| Captura | Qué demuestra |
|---|---|
| 01-zabbix-dashboard-initial.jpg | Frontend Zabbix accesible y servidor operativo. |
| 02-zabbix-hosts-full-coverage-green.jpg | Hosts principales monitorizados y en verde. |
| 06-items-list-10-custom.jpg | Items custom creados. |
| 07-latest-data-sql-items.jpg | Métricas SQL custom recolectadas. |
| 08-latest-data-alwayson-items.jpg | Always On health e is_primary validados. |
| 09-triggers-list-final.jpg | Triggers SQL custom creados. |
| 10-problem-log-backup-detected.jpg | Problema SQL detectado. |
| 12-problem-log-backup-resolved.jpg | Problema SQL resuelto. |
| 13-problems-sql-no-active.jpg | Estado final sin problemas SQL custom activos. |

## Por qué no se crea dashboard dedicado en v1

La versión v1 prioriza demostrar la operación completa:

1. Recolección de métricas.
2. Items reales en Latest data.
3. Triggers funcionales.
4. Detección de problema.
5. Acción correctiva.
6. Recuperación automática.
7. Evidencias visuales.

Un dashboard dedicado aporta valor visual, pero no es imprescindible para demostrar la capacidad operativa del lab. Por eso queda identificado como mejora futura no bloqueante.

## Dashboard futuro recomendado

Una evolución v1.1 podría crear un dashboard llamado:

```text
ORION SQL Server Operations
```

Paneles sugeridos:

| Panel | Métrica / fuente |
|---|---|
| SQL Server status | orion.sql.service.running |
| SQL Agent status | orion.sql.agent.running |
| AG health | orion.sql.ag.health |
| Primary node | orion.sql.ag.is_primary[OrionLabDB] |
| User sessions | orion.sql.sessions.user |
| Blocking sessions | orion.sql.blocking.sessions |
| Failed jobs 24h | orion.sql.jobs.failed24h |
| Backup FULL age | orion.sql.backup.full.age.hours[OrionLabDB] |
| Backup LOG age | orion.sql.backup.log.age.hours[OrionLabDB] |
| Problems SQL | Vista filtrada por triggers SQL custom |

## Conclusión

LAB-04 v1 demuestra monitorización completa sin depender de un dashboard decorativo. Las vistas nativas de Zabbix y las evidencias publicadas prueban que hay métricas, triggers, problemas y recuperación real. El dashboard dedicado queda como mejora estética y operativa futura.
