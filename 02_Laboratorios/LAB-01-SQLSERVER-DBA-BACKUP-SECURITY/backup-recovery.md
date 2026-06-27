# Backup & Recovery — LAB-01 SQL Server DBA

## Resumen

`OrionLabDB` se configuró en recovery model `FULL` para practicar una estrategia completa de protección y recuperación de base de datos.

## Rutas

| Uso | Ruta |
|---|---|
| Datos | `D:\SQLData` |
| Logs | `L:\SQLLogs` |
| FULL | `B:\SQLBackups\FULL` |
| DIFF | `B:\SQLBackups\DIFF` |
| LOG | `B:\SQLBackups\LOG` |

## Backups manuales

Se ejecutaron backups FULL, diferenciales y de log. Todos se validaron con `CHECKSUM`, `RESTORE VERIFYONLY`, revisión del histórico de `msdb` y comprobación del archivo físico en disco.

## Restore y recuperación

Se validó un restore completo en `OrionLabDB_RestoreTest` usando la cadena FULL, DIFF y LOG.

También se validó una recuperación a un punto temporal en `OrionLabDB_PITR`, confirmando que la cadena de logs permitía volver a un momento concreto del laboratorio.

## Reparación de datos

`OrionLabDB_PITR` se utilizó como fuente limpia para devolver datos a `OrionLabDB`. Después se ejecutó un backup de log post-reparación y una comprobación de integridad con `DBCC CHECKDB`.

## Automatización

| Job | Frecuencia |
|---|---|
| `ORION - Backup FULL - OrionLabDB` | Diario 23:00 |
| `ORION - Backup DIFF - OrionLabDB` | Cada 6 horas |
| `ORION - Backup LOG - OrionLabDB` | Cada 15 minutos |
| `ORION - DBCC CHECKDB - OrionLabDB` | Domingo 02:00 |
| `ORION - Cleanup Backups - OrionLabDB` | Diario 01:00 |

## Retención

| Tipo | Retención |
|---|---|
| FULL | 14 días |
| DIFF | 7 días |
| LOG | 3 días |
| Histórico msdb | 30 días |

## Valor profesional

Este bloque demuestra backup, restore, recuperación granular, validación de integridad, automatización con SQL Server Agent y control de retención.

## Evidencias

- [05-rutas-sql-datos-logs.png](capturas/05-rutas-sql-datos-logs.png)
- [06-backups-full-diff-log.png](capturas/06-backups-full-diff-log.png)
- [07-restore-completo-validado.png](capturas/07-restore-completo-validado.png)
- [08-pitr-validado.png](capturas/08-pitr-validado.png)
- [09-reparacion-datos-pitr.png](capturas/09-reparacion-datos-pitr.png)
- [10-sql-agent-jobs-schedules.png](capturas/10-sql-agent-jobs-schedules.png)

Galería completa: [evidencias.md](evidencias.md).

