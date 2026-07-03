# Validaciones LAB-04

## Estado final

Se valida el cierre del LAB-04 con Zabbix Server, frontend, agentes Windows, checks SQL custom, template reutilizable, items, triggers y recuperación real de una alerta SQL.

## ORN-MON01

| Elemento | Resultado |
|---|---|
| Sistema operativo | Ubuntu Server 26.04 LTS |
| Hostname | orn-mon01 |
| Timezone | Europe/Madrid |
| NTP | Activo y sincronizado |
| SSH | Activo |
| open-vm-tools | Activo |
| Root filesystem | 48 GB |
| RAM | 2 GB asignados |
| IP interna | 10.10.20.70/24 |

## Zabbix Server

| Componente | Resultado |
|---|---|
| Zabbix Server | active |
| Zabbix Agent | active |
| Apache | active |
| PostgreSQL | active |
| PHP-FPM | active |

Versiones validadas:

| Elemento | Versión |
|---|---|
| Zabbix Server | 7.0.27 |
| Zabbix Frontend | 7.0.27 |
| Zabbix Agent | 7.0.27 |
| Apache | 2.4.66 |

Puertos validados:

| Puerto | Servicio |
|---:|---|
| 80 | Apache / Zabbix Frontend |
| 10050 | Zabbix Agent |
| 10051 | Zabbix Server |

## Monitorización completa del entorno Windows

| Host | IP | Rol | Estado Zabbix | Validación |
|---|---:|---|---|---|
| ORN-DC01 | 10.10.20.10 | Domain Controller / DNS | ZBX verde | OK |
| ORN-FSW01 | 10.10.20.40 | File Share Witness / Quorum | ZBX verde | OK |
| ORN-DBA01 | 10.10.20.30 | Estación administrativa DBA | ZBX verde | OK |
| ORN-SQL01 | 10.10.20.20 | SQL Server / Always On node | ZBX verde | OK |
| ORN-SQL02 | 10.10.20.21 | SQL Server / Always On node | ZBX verde | OK |
| ORN-MON01 | 10.10.20.70 | Zabbix Server | ZBX verde | OK |

Validaciones realizadas:

- Zabbix Agent 2 versión 7.0.27 instalado en nodos Windows.
- Servicio `Zabbix Agent 2` en estado `Running / Automatic`.
- Puerto TCP 10050 en escucha.
- Firewall Windows restringido a `10.10.20.70`.
- Conectividad hacia Zabbix Server `10.10.20.70:10051`.
- Validación desde ORN-MON01 mediante `nc` y `zabbix_get`.
- Hosts creados en Zabbix con plantilla `Windows by Zabbix agent`.

## Checks SQL custom

Validación desde ORN-MON01 contra los nodos SQL:

| Host | IP | agent.ping | agent.version | hostname | SQL ping | SQL service | SQL Agent | AG health | is_primary |
|---|---:|---:|---|---|---:|---:|---:|---:|---:|
| ORN-SQL01 | 10.10.20.20 | 1 | 7.0.27 | ORN-SQL01 | 1 | 1 | 1 | 1 | 1 |
| ORN-SQL02 | 10.10.20.21 | 1 | 7.0.27 | ORN-SQL02 | 1 | 1 | 1 | 1 | 0 |

Resultado:

- ORN-SQL01 devuelve métricas SQL custom correctamente.
- ORN-SQL02 devuelve métricas SQL custom correctamente.
- Always On queda healthy en ambos nodos.
- ORN-SQL01 queda validado como primary para `OrionLabDB`.
- ORN-SQL02 queda validado como secondary para `OrionLabDB`.
- SQL Server se mantiene alineado con Windows Authentication Only.
- No se publican usuarios SQL ni contraseñas SQL.

## Template SQL custom

| Elemento | Resultado |
|---|---|
| Template | ORION SQL Server Custom Checks |
| Hosts enlazados | ORN-SQL01, ORN-SQL02 |
| Items custom por host | 10 |
| Métricas SQL custom esperadas | 20 |
| Export YAML | `scripts/zabbix/template-orion-sqlserver-custom.yaml` |
| Latest data SQL | OK |
| Latest data Always On | OK |

## Triggers SQL custom

| Trigger | Severidad | Estado |
|---|---|---|
| SQL custom ping failed on `{HOST.NAME}` | High | Creado |
| SQL Server service down on `{HOST.NAME}` | Disaster | Creado |
| SQL Server Agent down on `{HOST.NAME}` | High | Creado |
| Always On unhealthy on `{HOST.NAME}` | High | Creado |
| SQL blocking sessions detected on `{HOST.NAME}` | Warning | Creado |
| SQL Agent failed jobs detected on `{HOST.NAME}` | Average | Creado |
| SQL FULL backup old for OrionLabDB on `{HOST.NAME}` | Average | Creado |
| SQL LOG backup old for OrionLabDB on `{HOST.NAME}` | Average | Creado |

## Validación real de alerta y recuperación

Se valida el ciclo completo sobre el trigger:

```text
SQL LOG backup old for OrionLabDB on ORN-SQL01
```

Secuencia validada:

1. Zabbix detecta LOG backup antiguo en el primario.
2. El trigger salta solo en ORN-SQL01.
3. ORN-SQL02 no alerta porque `is_primary[OrionLabDB]=0`.
4. Se ejecuta backup LOG manual en ORN-SQL01.
5. Zabbix recalcula el item.
6. El valor de `SQL backup LOG age hours for OrionLabDB` baja a `0 h` en ORN-SQL01.
7. El problema queda `RESOLVED`.
8. El filtro `Problem: SQL` queda sin problemas activos.

## Hallazgos no bloqueantes

| Hallazgo | Estado | Decisión |
|---|---|---|
| Jobs AG-aware sin schedule detectado en preflight | Documentado | No bloquea el LAB-04; explica backups antiguos. |
| Problemas genéricos Windows AppXSvc / InventorySvc | Documentado | No afectan a SQL custom; revisar si se quiere limpiar ruido. |
| ORN-SQL01 recuperado temporalmente con LocalSystem para Agent 2 | Documentado | Checks OK; homogeneización futura opcional. |
| Dashboard visual específico | Mejora futura | Latest data, Problems y evidencias cubren la validación v1. |

## Evidencias

El manifest de evidencias queda documentado en:

- [evidencias/README.md](evidencias/README.md)

## Conclusión

El entorno de monitorización queda validado con Zabbix Server, Zabbix Frontend, agentes Windows, template SQL custom, items, triggers y checks SQL operativos.

LAB-04 queda cerrado como **Completado v1**.
