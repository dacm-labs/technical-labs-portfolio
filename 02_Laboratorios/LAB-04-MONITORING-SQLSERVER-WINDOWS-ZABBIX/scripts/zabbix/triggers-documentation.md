# ORION LAB-04 - SQL Server trigger documentation

## Estado

Pendiente de creación en Zabbix UI.

## Triggers previstos

| Área | Trigger previsto | Severidad inicial |
|---|---|---|
| Conectividad SQL | SQL custom ping failed | High |
| Servicio SQL Server | SQL Server service down | High |
| SQL Server Agent | SQL Server Agent down | Average |
| Bloqueos | Blocking sessions detected | Warning |
| Jobs | Failed SQL Agent jobs detected | Average |
| Backups | FULL backup age too high | Warning |
| Backups | LOG backup age too high | Warning |
| Always On | AG health not healthy | High |
| Always On | Unexpected AG role | Average |
| Datos Zabbix | No custom SQL monitoring data | Warning |

## Criterio operacional

Los triggers se crearán en un template reutilizable y se enlazarán a ORN-SQL01 y ORN-SQL02.

Los umbrales de backups deben empezar con valores de laboratorio para evitar ruido hasta que los jobs AG-aware queden programados.
