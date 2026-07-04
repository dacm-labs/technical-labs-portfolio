# Plan de trabajo LAB-04

## Objetivo

Definir la secuencia ejecutada para construir el laboratorio de monitorización centralizada sobre SQL Server, Windows Server y Always On Availability Groups.

El laboratorio se ejecuta de forma incremental: primero se valida el estado nativo del entorno, después se despliega Zabbix y finalmente se añaden checks SQL custom, items, triggers, evidencias y cierre documental.

## Secuencia de bloques

| Bloque | Estado | Objetivo | Resultado |
|---|---|---|---|
| BLOQUE 0 — Preflight del entorno | Completado | Validar memoria, SQL Server, Always On, DNS, puertos, jobs, backups, auditoría y hardening. | Entorno preparado y sin fallos bloqueantes. |
| BLOQUE 1 — Monitorización nativa Windows / SQL Server | Completado | Validar Get-Counter, PerfMon, logman, DMVs, SQL Error Log, Event Log y clúster. | Baseline nativo documentado. |
| BLOQUE 2 — Creación de ORN-MON01 | Completado | Desplegar VM Ubuntu Server para monitorización. | ORN-MON01 creada, actualizada, con SSH, open-vm-tools, NTP y red preparada. |
| BLOQUE 3 — Instalación de Zabbix Server | Completado | Instalar Zabbix Server 7.0 LTS con PostgreSQL, Apache, PHP-FPM y frontend. | Zabbix 7.0.27 operativo en `10.10.20.70`. |
| BLOQUE 4 — Agentes Zabbix Windows | Completado | Instalar Zabbix Agent 2 en nodos Windows. | Hosts principales en Zabbix con ZBX verde. |
| BLOQUE 5 — SQL Server custom monitoring | Completado | Diseñar checks SQL con UserParameters, wrapper PowerShell y Windows Authentication. | Checks SQL custom validados con `zabbix_get`. |
| BLOQUE 6 — Template, items y triggers | Completado | Crear template reutilizable, items SQL y triggers. | 10 items por nodo SQL y 8 triggers custom. |
| BLOQUE 7 — Validación operativa real | Completado | Generar y resolver una alerta SQL real. | LOG backup old detectado, corregido con backup LOG y resuelto. |
| BLOQUE 8 — Evidencias visuales | Completado | Seleccionar capturas técnicas representativas. | 15 imágenes publicadas y manifest documentado. |
| BLOQUE 9 — Export de template | Completado | Exportar el template Zabbix a YAML. | `template-orion-sqlserver-custom.yaml` versionado. |
| BLOQUE 10 — Documentación de triggers | Completado | Documentar lógica de items, triggers y recuperación. | `triggers-documentation.md` completado. |
| BLOQUE 11 — Cierre documental | Completado | Cerrar README, validaciones, troubleshooting, evidencias y conclusión. | LAB-04 cerrado como Completado v1. |

## Criterios de ejecución

- Trabajar paso a paso.
- Validar antes de avanzar.
- No romper el hardening del LAB-03.
- No reactivar Mixed Mode por comodidad.
- Mantener Windows Authentication.
- No publicar secretos, cookies, tokens ni credenciales.
- Documentar incidencias reales y decisiones operativas.
- Versionar scripts y configuración reutilizable.
- Revisar Git antes de cerrar cada bloque importante.

## Hitos técnicos alcanzados

### Preflight

- SQL01 y SQL02 redimensionados para ajustarse al host físico.
- `max server memory` ajustado para laboratorio.
- Always On validado tras cambios de RAM.
- DNS, puertos críticos y listener verificados.
- Jobs AG-aware revisados.
- Backups antiguos detectados como hallazgo operativo.
- Auditoría y hardening heredados del LAB-03 validados.

### Monitorización nativa

- Contadores SQL Server disponibles en SQL01 y SQL02.
- Lectura rápida de CPU, memoria, disco, sesiones, PLE, locks y deadlocks.
- Data Collector Sets creados con `logman`.
- CSV PerfMon generados.
- SQL Error Log validado.
- Eventos de clúster revisados.
- Hallazgo DNS/APIPA en ORN-SQL02 documentado y validado sin impacto operativo.

### Zabbix Server

- ORN-MON01 desplegado con Ubuntu Server.
- Zabbix Server 7.0 LTS instalado desde repositorio oficial.
- PostgreSQL inicializado con esquema Zabbix.
- Apache y PHP-FPM corregidos y validados.
- Frontend accesible desde ORN-DBA01.
- Password por defecto de Admin cambiada.

### Agentes Windows

- Zabbix Agent 2 7.0.27 instalado offline.
- Firewall inbound 10050 restringido a ORN-MON01.
- Validación con `nc` y `zabbix_get`.
- Hosts creados en Zabbix con plantilla Windows.
- Cobertura completa del entorno principal.

### Checks SQL custom

- Wrapper PowerShell `03-check-sql-dmv.ps1` implementado.
- UserParameters SQL custom configurados.
- Windows Authentication mantenida.
- Sin usuarios SQL ni contraseñas en Git.
- SQL01 y SQL02 devuelven métricas correctamente.
- Always On health e `is_primary` validados.

### Items, triggers y recuperación

- Template `ORION SQL Server Custom Checks` creado.
- 10 items por host SQL.
- 8 triggers custom.
- Lógica primary-only para backups.
- Alerta real por LOG backup antiguo en ORN-SQL01.
- Backup LOG manual ejecutado.
- Problema resuelto automáticamente.

## Mejoras futuras no bloqueantes

- Crear dashboard ejecutivo específico.
- Homogeneizar cuenta del servicio Zabbix Agent 2 en ORN-SQL01.
- Programar schedules para jobs AG-aware si el entorno queda encendido de forma recurrente.
- Ajustar ruido del template Windows genérico.

## Conclusión

El plan de trabajo queda completado. LAB-04 demuestra una implantación de monitorización operativa realista, desde baseline nativo hasta detección y recuperación de una alerta SQL en Zabbix.
