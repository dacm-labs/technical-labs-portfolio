# Plan de trabajo — LAB-01 SQL Server DBA Backup, Recovery, Security, Monitoring & Maintenance

## Enfoque del laboratorio

El LAB-01 se desarrolló como un laboratorio completo de administración SQL Server orientado a portfolio técnico. El objetivo no fue únicamente instalar SQL Server, sino construir un entorno defendible con dominio, roles separados, mantenimiento automatizado, recuperación ante errores, seguridad por grupos, auditoría, diagnóstico y dashboard DBA.

## Fase 0 — Diseño

| Tarea | Estado | Resultado |
|---|---|---|
| Definir objetivo del laboratorio | Completado | Base SQL Server DBA del portfolio técnico. |
| Definir arquitectura | Completado | Dominio, servidor SQL y estación DBA separados. |
| Definir red | Completado | Red `10.10.20.0/24`. |
| Definir máquinas | Completado | `ORN-DC01`, `ORN-SQL01`, `ORN-DBA01`. |
| Definir estrategia de discos | Completado | Separación de datos, logs, TempDB, backups y auditoría. |
| Definir enfoque de documentación | Completado | Markdown profesional para GitHub y portfolio. |

## Fase 1 — Active Directory, DNS y red

| Tarea | Estado | Resultado |
|---|---|---|
| Instalar AD DS y DNS | Completado | `ORN-DC01` como DC/DNS. |
| Crear dominio | Completado | `orion.lab`. |
| Crear zona inversa DNS | Completado | Resolución PTR validada. |
| Crear OUs | Completado | Estructura del laboratorio organizada. |
| Crear grupos AD | Completado | Grupos IT, SQL, lectura, backup, auditoría y servicio. |
| Crear cuenta administrativa | Completado | Cuenta administrativa de laboratorio. |
| Unir `ORN-SQL01` al dominio | Completado | Servidor SQL miembro de `orion.lab`. |
| Unir `ORN-DBA01` al dominio | Completado | Estación DBA integrada. |
| Validar DNS y canal seguro | Completado | `nltest`, `Resolve-DnsName`, ping y conectividad. |

## Fase 2 — Preparación de servidor SQL y estación DBA

| Tarea | Estado | Resultado |
|---|---|---|
| Preparar discos SQL | Completado | Volúmenes `D:`, `L:`, `T:`, `B:`. |
| Crear rutas SQL | Completado | `SQLData`, `SQLLogs`, `SQLTempDB`, `SQLBackups`. |
| Crear cuentas de servicio | Completado | Cuentas dedicadas para motor SQL y SQL Agent. |
| Aplicar permisos NTFS | Completado | Permisos `Modify` controlados. |
| Instalar SSMS en `ORN-DBA01` | Completado | Administración remota preparada. |
| Configurar firewall SQL | Completado | TCP 1433 permitido desde `ORN-DBA01`. |

## Fase 3 — Instalación y validación de SQL Server

| Tarea | Estado | Resultado |
|---|---|---|
| Instalar SQL Server 2025 Enterprise Developer | Completado | Instancia `MSSQLSERVER`. |
| Configurar cuentas de servicio | Completado | Motor y Agent con cuentas de dominio. |
| Configurar rutas de datos | Completado | Datos, logs, backups y TempDB separados. |
| Configurar MaxDOP y memoria | Completado | MaxDOP 2 y memoria máxima controlada. |
| Activar TCP/IP | Completado | SQL escuchando en TCP 1433. |
| Validar conexión remota | Completado | SSMS desde `ORN-DBA01`. |
| Crear `OrionLabDB` | Completado | Base principal del laboratorio. |
| Configurar recovery model | Completado | `FULL`. |

## Fase 4 — Backup, restore y recuperación ante errores

| Tarea | Estado | Resultado |
|---|---|---|
| Backup FULL manual | Completado | Backup inicial validado con `VERIFYONLY`. |
| Backup LOG manual | Completado | Cadena de logs iniciada. |
| Backup DIFF manual | Completado | Diferencial validado. |
| Restore completo | Completado | `FULL + DIFF + LOG` en base de pruebas. |
| Point-in-time recovery | Completado | Recuperación hasta punto anterior al borrado. |
| Reparación de datos | Completado | Datos recuperados desde base PITR a original. |
| CHECKDB posterior | Completado | Integridad validada tras la reparación. |

## Fase 5 — Automatización con SQL Server Agent

| Tarea | Estado | Resultado |
|---|---|---|
| Job backup FULL | Completado | Diario 23:00. |
| Job backup DIFF | Completado | Cada 6 horas. |
| Job backup LOG | Completado | Cada 15 minutos. |
| Job DBCC CHECKDB | Completado | Domingo 02:00. |
| Job Cleanup Backups | Completado | Diario 01:00. |
| Política de retención | Completado | FULL 14 días, DIFF 7 días, LOG 3 días, msdb 30 días. |
| Validación de jobs | Completado | Históricos con ejecución correcta. |

## Fase 6 — Database Mail y alertas

| Tarea | Estado | Resultado |
|---|---|---|
| Precheck SMTP Outlook | Completado | Fallo documentado por SMTP AUTH deshabilitado. |
| Configurar salida NAT controlada | Completado | Conectividad SMTP validada. |
| Configurar relay SMTP técnico | Completado | Cuenta técnica SMTP dedicada del laboratorio. |
| Activar Database Mail | Completado | Perfil `ORION_DBMail_Profile`. |
| Asociar SQL Agent a Database Mail | Completado | Registro interno validado. |
| Crear operador DBA | Completado | `ORION_DBA_Operator`. |
| Asociar operador a jobs | Completado | Notificación `On Failure`. |
| Probar fallo controlado | Completado | Job temporal fallido y correo enviado. |
| Eliminar job temporal | Completado | Entorno limpio. |

## Fase 7 — Seguridad SQL y mínimo privilegio

| Tarea | Estado | Resultado |
|---|---|---|
| Crear usuarios de prueba en AD | Completado | Usuarios de laboratorio para lectura, backup, auditoría y sin permisos. |
| Crear logins por grupos AD | Completado | Logins Windows para grupos `GG_SQL_*`. |
| Mapear usuarios en `OrionLabDB` | Completado | Acceso basado en grupos. |
| Configurar readonly | Completado | SELECT permitido, INSERT denegado. |
| Configurar backup operator | Completado | BACKUP permitido, SELECT denegado. |
| Configurar audit reader | Completado | Lectura limitada a esquema `audit`. |
| Probar usuario sin permisos | Completado | Login denegado con error 18456. |

## Fase 8 — Auditoría, Query Store y dashboard

| Tarea | Estado | Resultado |
|---|---|---|
| Crear ruta de auditoría | Completado | Ruta dedicada para ficheros de auditoría. |
| Crear Server Audit | Completado | `ORION_ServerAudit`. |
| Crear Server Audit Specification | Completado | Logins y cambios de seguridad. |
| Crear Database Audit Specification | Completado | Eventos sobre `lab.Clientes`. |
| Validar eventos de auditoría | Completado | Lectura de ficheros `.sqlaudit`. |
| Activar Query Store | Completado | Captura y análisis de consultas. |
| Crear workload de prueba | Completado | Tabla `lab.QueryStoreWorkload`. |
| Comparar consulta lenta/optimizada | Completado | Índice creado y mejora validada. |
| Crear vistas DBA | Completado | Vistas `dba.vw_*`. |
| Validar dashboard final | Completado | Checks principales en estado OK. |

## Fase 9 — Cierre

| Tarea | Estado | Resultado |
|---|---|---|
| Guardar documento Word final | Completado | Memoria completa privada del LAB-01. |
| Crear snapshots finales | Completado | Baseline final de DC01, SQL01 y DBA01. |
| Convertir memoria a documentación GitHub | Completado | Markdown profesional por bloques. |
| Seleccionar evidencias | Completado | Capturas seleccionadas y enlazadas en la documentación pública. |
| Preparar LAB-01 para futuras fases | Completado v1 | Base lista para Always On y ampliaciones. |

