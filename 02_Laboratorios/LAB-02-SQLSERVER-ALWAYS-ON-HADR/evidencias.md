# Evidencias — LAB-02 SQL Server Always On

## Objetivo

Este documento relaciona las evidencias visuales y técnicas seleccionadas para documentar el LAB-02.

Las capturas incluidas demuestran la arquitectura lógica, la configuración del clúster, el Availability Group, el listener, las pruebas de failover, la recuperación, la lectura en secundaria, los jobs AG-aware, la preferencia de backup y el estado final del entorno.

---

## Diagramas publicados

| ID | Diagrama | Evidencia |
|---:|---|---|
| D00 | [portada-lab02-sqlserver-alwayson](diagramas/01-lab02-sqlserver-alwayson-cover.png) | Portada visual del LAB-02. |
| D01 | [topologia-logica-global-lab02](diagramas/01-topologia-logica-global-lab02.png) | Topología lógica global del entorno LAB-02. |

---

## Capturas publicadas

| ID | Captura | Evidencia |
|---|---|---|
| WSFC-04 | [test-cluster-validacion](capturas/02-cluster-wsfc/04-test-cluster-validacion.jpg) | Validación del clúster WSFC. |
| WSFC-06 | [quorum-file-share-witness](capturas/02-cluster-wsfc/06-quorum-file-share-witness.jpg) | Quorum mediante File Share Witness. |
| WSFC-07 | [dashboard-final-wsfc](capturas/02-cluster-wsfc/07-dashboard-final-wsfc.jpg) | Estado final del clúster WSFC, nodos, recursos y red. |
| AG-10 | [ag-orion-ag01-synchronized](capturas/03-alwayson-ag/10-ag-orion-ag01-synchronized.jpg) | Availability Group `ORION_AG01` sincronizado y saludable. |
| AG-11 | [listener-orn-sqlag01-online](capturas/03-alwayson-ag/11-listener-orn-sqlag01-online.jpg) | Listener `ORN-SQLAG01` online con IP `10.10.20.60`. |
| AG-12 | [dashboard-final-alwayson](capturas/03-alwayson-ag/12-dashboard-final-alwayson.jpg) | Dashboard final de Always On con `ORN-SQL01` como primario. |
| AG-13 | [lectura-secundaria-applicationintent-readonly](capturas/03-alwayson-ag/13-lectura-secundaria-applicationintent-readonly.png) | Lectura validada en la réplica secundaria usando `ApplicationIntent=ReadOnly`. |
| AG-14 | [listener-ad-dns-validado](capturas/03-alwayson-ag/14-listener-ad-dns-validado.png) | Validación del listener, resolución DNS y objeto asociado en el entorno de dominio. |
| FO-14 | [insercion-listener-tras-failover](capturas/04-failover-recuperacion/14-insercion-listener-tras-failover.jpg) | Escritura por listener tras failover controlado. |
| FO-16 | [caida-antiguo-primario-listener-operativo](capturas/04-failover-recuperacion/16-caida-antiguo-primario-listener-operativo.jpg) | Servicio disponible por listener con antiguo primario detenido. |
| FO-18 | [failback-final-sql01-primary](capturas/04-failover-recuperacion/18-failback-final-sql01-primary.jpg) | Failback final hacia `ORN-SQL01` y estado saludable. |
| VAL-20 | [validacion-final-dns-puertos](capturas/05-jobs-validaciones-finales/20-validacion-final-dns-puertos.jpg) | DNS limpio y puertos `1433`, `5022` y `3343` validados. |
| JOB-21 | [jobs-antiguos-lab01-deshabilitados](capturas/05-jobs-validaciones-finales/21-jobs-antiguos-lab01-deshabilitados.png) | Jobs clásicos del LAB-01 deshabilitados para evitar ejecución no controlada sobre la base protegida. |
| JOB-22 | [jobs-ag-aware-sql01](capturas/05-jobs-validaciones-finales/22-jobs-ag-aware-sql01.png) | Jobs AG-aware presentes y validados en `ORN-SQL01`. |
| JOB-23 | [jobs-ag-aware-sql02](capturas/05-jobs-validaciones-finales/23-jobs-ag-aware-sql02.png) | Jobs AG-aware presentes y validados en `ORN-SQL02`. |
| JOB-24 | [backup-preference-secondary](capturas/05-jobs-validaciones-finales/24-backup-preference-secondary.png) | Preferencia de backup del Availability Group configurada hacia réplica secundaria. |
| JOB-25 | [preferred-backup-sql01](capturas/05-jobs-validaciones-finales/25-preferred-backup-sql01.png) | Validación de preferencia de backup desde `ORN-SQL01`. |
| JOB-26 | [preferred-backup-sql02](capturas/05-jobs-validaciones-finales/26-preferred-backup-sql02.png) | Validación de preferencia de backup desde `ORN-SQL02`. |
| JOB-27 | [backup-log-sql02-generado](capturas/05-jobs-validaciones-finales/27-backup-log-sql02-generado.png) | Evidencia de backup de log generado desde la réplica secundaria. |

---

## Evidencias clave incorporadas en la versión final

| Bloque | Valor técnico añadido |
|---|---|
| Lectura en secundaria | Confirma que la réplica secundaria es legible cuando se usa `ApplicationIntent=ReadOnly`. |
| Listener / AD / DNS | Refuerza la explicación del listener y la resolución del problema de objeto/permisos en dominio. |
| Jobs AG-aware | Demuestra que el mantenimiento se adapta al rol real de cada réplica. |
| Backup preference | Evidencia que la preferencia de backup está orientada a secundaria. |
| Backup de log en secundaria | Valida operación real de backup sobre la réplica preferida. |

---

## Criterio de publicación

- No se publica la memoria Word completa.
- Se publica solo una selección de capturas representativas.
- No se incluyen credenciales ni datos sensibles.
- Se priorizan evidencias que demuestran arquitectura, configuración, validación, recuperación y operación.
- GitHub se mantiene como resumen técnico navegable; el documento Word queda como memoria completa privada.

---

## Estado

Diagramas y capturas seleccionadas publicadas en las carpetas `diagramas/` y `capturas/` del LAB-02.
