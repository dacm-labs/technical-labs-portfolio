# Dashboard DBA — LAB-01

## Resumen

Vista resumen del estado final del laboratorio.

El dashboard DBA agrupa comprobaciones de base de datos, backups, jobs y estado operativo general.

## Vistas creadas

| Vista | Función |
|---|---|
| `vw_DatabaseStatus` | Estado de bases de datos |
| `vw_DatabaseFileUsage` | Uso de ficheros |
| `vw_BackupStatus` | Estado de backups |
| `vw_SQLAgentJobStatus` | Estado de jobs |
| `vw_SQLAgentJobFailures` | Fallos de jobs |
| `vw_DBAHealthDashboard` | Resumen final |

## Checks finales

- Base principal online.
- Backups registrados.
- Jobs habilitados.
- Avisos operativos preparados.
- Eventos revisados.
- Comparativa de consultas realizada.

## Evidencias

- [15-query-store-comparativa.png](capturas/15-query-store-comparativa.png)
- [16-dashboard-dba-ok.png](capturas/16-dashboard-dba-ok.png)

Galería completa: [evidencias.md](evidencias.md).

## Estado

Validado como cierre técnico del LAB-01.

