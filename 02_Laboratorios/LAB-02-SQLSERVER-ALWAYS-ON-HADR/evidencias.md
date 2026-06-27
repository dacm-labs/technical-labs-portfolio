# Evidencias — LAB-02 SQL Server Always On

## Objetivo

Este documento relaciona las evidencias visuales y técnicas seleccionadas para documentar el LAB-02.

Las capturas incluidas demuestran la arquitectura lógica, la configuración del clúster, el Availability Group, el listener, las pruebas de failover, la recuperación y el estado final del entorno.

---

## Diagramas publicados

| Nº | Diagrama | Evidencia |
|---:|---|---|
| 00 | [portada-lab02-sqlserver-alwayson](diagramas/01-lab02-sqlserver-alwayson-cover.png) | Portada visual del LAB-02. |
| 01 | [topologia-logica-global-lab02](diagramas/01-topologia-logica-global-lab02.png) | Topología lógica global del entorno LAB-02. |

---

## Capturas publicadas

| Nº | Captura | Evidencia |
|---:|---|---|
| 04 | [test-cluster-validacion](capturas/02-cluster-wsfc/04-test-cluster-validacion.jpg) | Validación del clúster WSFC. |
| 06 | [quorum-file-share-witness](capturas/02-cluster-wsfc/06-quorum-file-share-witness.jpg) | Quorum mediante File Share Witness. |
| 07 | [dashboard-final-wsfc](capturas/02-cluster-wsfc/07-dashboard-final-wsfc.jpg) | Estado final del clúster WSFC, nodos, recursos y red. |
| 10 | [ag-orion-ag01-synchronized](capturas/03-alwayson-ag/10-ag-orion-ag01-synchronized.jpg) | Availability Group `ORION_AG01` sincronizado y saludable. |
| 11 | [listener-orn-sqlag01-online](capturas/03-alwayson-ag/11-listener-orn-sqlag01-online.jpg) | Listener `ORN-SQLAG01` online con IP `10.10.20.60`. |
| 12 | [dashboard-final-alwayson](capturas/03-alwayson-ag/12-dashboard-final-alwayson.jpg) | Dashboard final de Always On con `ORN-SQL01` como primario. |
| 14 | [insercion-listener-tras-failover](capturas/04-failover-recuperacion/14-insercion-listener-tras-failover.jpg) | Escritura por listener tras failover controlado. |
| 16 | [caida-antiguo-primario-listener-operativo](capturas/04-failover-recuperacion/16-caida-antiguo-primario-listener-operativo.jpg) | Servicio disponible por listener con antiguo primario detenido. |
| 18 | [failback-final-sql01-primary](capturas/04-failover-recuperacion/18-failback-final-sql01-primary.jpg) | Failback final hacia `ORN-SQL01` y estado saludable. |
| 20 | [validacion-final-dns-puertos](capturas/05-jobs-validaciones-finales/20-validacion-final-dns-puertos.jpg) | DNS limpio y puertos `1433`, `5022` y `3343` validados. |

---

## Evidencias candidatas para versión posterior

Estas capturas no son imprescindibles para v1, pero reforzarían todavía más la explicación pública del laboratorio:

| Evidencia candidata | Valor técnico |
|---|---|
| Lectura en secundaria con `ApplicationIntent=ReadOnly` | Demuestra uso correcto de réplica secundaria legible. |
| Validación visual de jobs AG-aware en ambos nodos | Refuerza la adaptación operativa de SQL Server Agent a Always On. |
| Objeto del listener o permisos del clúster en Active Directory | Ayuda a explicar la incidencia del listener y su resolución. |

---

## Criterio de publicación

- No se publica la memoria Word completa.
- Se publica solo una selección de capturas representativas.
- No se incluyen credenciales ni datos sensibles.
- Se priorizan evidencias que demuestran arquitectura, configuración, validación y recuperación.
- GitHub se mantiene como resumen técnico navegable; el documento Word queda como memoria completa privada.

---

## Estado

Diagramas y capturas seleccionadas publicadas en las carpetas `diagramas/` y `capturas/` del LAB-02.
