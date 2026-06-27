# Checklist — LAB-02 SQL Server Always On

## Diseño

- [x] Arquitectura definida.
- [x] IPs definidas.
- [x] Recursos de VMs definidos.
- [x] Nombres de clúster, Availability Group y listener definidos.

## Infraestructura

- [x] `ORN-SQL02` creada.
- [x] `ORN-FSW01` creada.
- [x] Máquinas unidas a `orion.lab`.
- [x] Objetos movidos a OUs correctas.
- [x] DNS validado.
- [x] Conectividad validada.

## SQL Server

- [x] SQL Server instalado en `ORN-SQL02`.
- [x] Servicios configurados.
- [x] Cuentas de servicio validadas.
- [x] TCP/IP activado.
- [x] Firewall configurado para `1433` y `5022`.
- [x] Conexión desde `ORN-DBA01` validada.

## Clúster

- [x] Failover Clustering instalado.
- [x] Validación de clúster ejecutada.
- [x] Clúster `ORN-SQLCL01` creado.
- [x] Quorum configurado con File Share Witness.
- [x] Recursos principales online.

## Always On

- [x] Always On activado en ambos nodos.
- [x] Endpoint HADR `5022` creado y validado.
- [x] Availability Group `ORION_AG01` creado.
- [x] Réplica primaria configurada.
- [x] Réplica secundaria configurada.
- [x] Listener `ORN-SQLAG01` configurado.
- [x] Sincronización validada.

## Pruebas

- [x] Conexión vía listener validada.
- [x] Escritura por listener validada.
- [x] Failover manual realizado.
- [x] Estado posterior al failover validado.
- [x] Failback manual realizado.
- [x] Lectura en secundaria validada con `ApplicationIntent=ReadOnly`.
- [x] Pruebas de parada y recuperación de réplicas realizadas.
- [x] Jobs AG-aware creados y validados.
- [x] Incidencias documentadas.

## Cierre

- [x] README actualizado.
- [x] Arquitectura final documentada.
- [x] Evidencias relacionadas.
- [x] Lecciones aprendidas documentadas.
- [x] Documento de memoria corregido.

