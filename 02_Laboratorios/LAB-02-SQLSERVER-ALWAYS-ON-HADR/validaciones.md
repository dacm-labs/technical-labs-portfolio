# Validaciones — LAB-02 SQL Server Always On

## Estado final del Availability Group

Validación realizada desde `ORN-DBA01` conectando al listener `tcp:ORN-SQLAG01.orion.lab,1433`.

| Elemento | Resultado final |
|---|---|
| Listener | `ORN-SQLAG01` |
| Nodo atendiendo el listener | `ORN-SQL01` |
| Availability Group | `ORION_AG01` |
| Base protegida | `OrionLabDB` |
| `ORN-SQL01` | `PRIMARY`, `CONNECTED`, `HEALTHY` |
| `ORN-SQL02` | `SECONDARY`, `CONNECTED`, `HEALTHY` |
| Modo de disponibilidad | `SYNCHRONOUS_COMMIT` |
| Modo de failover | `MANUAL` |
| Preferencia de backup | `SECONDARY` |
| Listener IP | `10.10.20.60` |
| Listener port | `1433` |

## Validaciones de conectividad

Validación realizada desde `ORN-DBA01`.

| Prueba | Resultado |
|---|---|
| `ORN-SQL01.orion.lab` | Resuelve a `10.10.20.20` |
| `ORN-SQL02.orion.lab` | Resuelve a `10.10.20.21` |
| `ORN-SQLAG01.orion.lab` | Resuelve a `10.10.20.60` |
| `ORN-SQLCL01.orion.lab` | Resuelve a `10.10.20.50` |
| `ORN-FSW01.orion.lab` | Resuelve a `10.10.20.40` |
| `ORN-SQL01:1433` | OK |
| `ORN-SQL02:1433` | OK |
| `ORN-SQLAG01:1433` | OK |
| `ORN-SQL01:5022` | OK |
| `ORN-SQL02:5022` | OK |
| `ORN-SQLCL01:3343` | OK |

## Validaciones WSFC

| Elemento | Resultado |
|---|---|
| Clúster | `ORN-SQLCL01` |
| Dominio | `orion.lab` |
| Administrative Access Point | `ActiveDirectoryAndDns` |
| Nodo `ORN-SQL01` | Up |
| Nodo `ORN-SQL02` | Up |
| Quorum | File Share Witness |
| Recurso `ORION_AG01` | Online |
| IP listener `10.10.20.60` | Online |
| Network Name `ORN-SQLAG01` | Online |
| Red de clúster | `10.10.20.0/24`, `ClusterAndClient`, Up |

## Pruebas funcionales

- Escritura por listener con `ORN-SQL01` como réplica primaria.
- Failover manual hacia `ORN-SQL02`.
- Escritura por listener tras failover.
- Lectura en réplica secundaria con `ApplicationIntent=ReadOnly`.
- Parada controlada de servicios SQL Server en réplica secundaria.
- Validación de servicio activo por listener durante caída controlada.
- Recuperación de servicios y resincronización.
- Failback final hacia `ORN-SQL01`.

## Jobs AG-aware

| Job | Lógica aplicada |
|---|---|
| `ORION AG - Backup FULL - OrionLabDB` | Solo en réplica primaria. |
| `ORION AG - Backup DIFF - OrionLabDB` | Solo en réplica primaria. |
| `ORION AG - Backup LOG - OrionLabDB` | En réplica preferida para backup. |
| `ORION AG - DBCC CHECKDB - OrionLabDB` | Solo en réplica primaria. |

**Nota técnica:** el Availability Group se configuró con preferencia de backup `SECONDARY`. En este laboratorio, los backups FULL y DIFF se mantuvieron en la réplica primaria por simplicidad operativa y coherencia de la cadena de backups. El backup LOG quedó adaptado a la réplica preferida. Los jobs AG-aware validan el rol de la réplica antes de ejecutar cada tarea. Esta decisión queda documentada como criterio de laboratorio y no como diseño definitivo de producción.

Los jobs tradicionales de LAB-01 para `OrionLabDB` quedaron deshabilitados para evitar ejecuciones no adaptadas a Always On.

