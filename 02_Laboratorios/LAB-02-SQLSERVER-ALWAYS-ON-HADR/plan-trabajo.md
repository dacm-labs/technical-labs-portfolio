# Plan de trabajo — LAB-02 SQL Server Always On

## Fase 0 — Diseño

- Definir arquitectura final.
- Definir nombres de máquinas.
- Definir IPs.
- Definir recursos de RAM, CPU y disco.
- Definir nombre del clúster.
- Definir nombre del Availability Group.
- Definir listener.

**Estado:** completado.

## Fase 1 — Preparación de infraestructura

- Crear `ORN-SQL02`.
- Crear `ORN-FSW01`.
- Unir máquinas al dominio `orion.lab`.
- Mover objetos de equipo a sus OUs correspondientes.
- Validar DNS, conectividad y canal seguro.
- Deshabilitar interfaces no necesarias para evitar registros DNS incorrectos.

**Estado:** completado.

## Fase 2 — Preparación SQL Server

- Instalar SQL Server 2025 en `ORN-SQL02`.
- Configurar cuentas de servicio.
- Configurar rutas de datos, logs, backups y TempDB.
- Activar TCP/IP.
- Configurar firewall para `1433` y `5022`.
- Validar conexión desde `ORN-DBA01`.

**Estado:** completado.

## Fase 3 — Windows Server Failover Cluster

- Instalar la característica Failover Clustering.
- Ejecutar `Test-Cluster`.
- Crear el clúster `ORN-SQLCL01`.
- Configurar quorum con File Share Witness.
- Validar nodos, recursos, redes y DNS.

**Estado:** completado.

## Fase 4 — Always On Availability Groups

- Activar Always On en ambos nodos SQL.
- Crear endpoint HADR en el puerto `5022`.
- Inicializar `OrionLabDB` en la réplica secundaria con backups `FULL + LOG` y `NORECOVERY`.
- Crear el Availability Group `ORION_AG01`.
- Incorporar `ORN-SQL02` como réplica secundaria.
- Crear el listener `ORN-SQLAG01`.
- Validar sincronización.

**Estado:** completado.

## Fase 5 — Pruebas de disponibilidad

- Validar conexión mediante listener.
- Realizar failover manual.
- Validar cambio de réplica primaria.
- Validar escritura por listener tras failover.
- Validar lectura en secundaria con `ApplicationIntent=ReadOnly`.
- Simular parada controlada de servicios SQL Server.
- Validar continuidad de servicio por listener.
- Recuperar nodo detenido y validar resincronización.
- Realizar failback final.

**Estado:** completado.

## Fase 6 — Jobs AG-aware

- Deshabilitar jobs tradicionales del LAB-01 para `OrionLabDB`.
- Crear jobs AG-aware en ambos nodos.
- Validar ejecución según rol de réplica.
- Confirmar preferencia de backup en secundaria.

**Estado:** completado.

## Fase 7 — Evidencias y cierre

- Capturas de arquitectura y configuración.
- Capturas del clúster WSFC.
- Capturas del Availability Group.
- Capturas del listener.
- Capturas de failover, failback y recuperación.
- Capturas de jobs AG-aware.
- Capturas de validación final DNS y puertos.
- Redacción de conclusiones técnicas y lecciones aprendidas.

**Estado:** completado.

