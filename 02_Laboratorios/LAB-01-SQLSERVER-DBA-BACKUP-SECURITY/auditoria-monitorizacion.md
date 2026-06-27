# Observabilidad LAB-01 SQL Server DBA

## Resumen

Documento de seguimiento operativo del LAB-01.

Incluye correo SQL, operador DBA, avisos de jobs, registro de eventos SQL y revisiones del estado final del laboratorio.

## Correo SQL

Se preparó un perfil de correo para que SQL Server pudiera enviar mensajes operativos desde el laboratorio.

| Elemento | Valor |
|---|---|
| Perfil | `ORION_DBMail_Profile` |
| Operador | `ORION_DBA_Operator` |
| Destinatario | Cuenta técnica principal del laboratorio |

## Avisos de jobs

Los jobs principales de mantenimiento quedaron configurados para avisar cuando fallan.

| Job | Aviso |
|---|---|
| Backup FULL | En fallo |
| Backup DIFF | En fallo |
| Backup LOG | En fallo |
| DBCC CHECKDB | En fallo |
| Cleanup Backups | En fallo |

## Registro de eventos SQL

Se preparó una ruta dedicada para eventos SQL en `D:\SQLAudit` y se validó la lectura de eventos generados durante las pruebas del laboratorio.

## Evidencias

- [11-database-mail-sent.png](capturas/11-database-mail-sent.png)
- [12-operador-alertas-job-fallido.png](capturas/12-operador-alertas-job-fallido.png)
- [14-sql-server-audit-eventos.png](capturas/14-sql-server-audit-eventos.png)

Galería completa: [evidencias.md](evidencias.md).

## Estado

Bloque completado y validado en el documento final del LAB-01.

