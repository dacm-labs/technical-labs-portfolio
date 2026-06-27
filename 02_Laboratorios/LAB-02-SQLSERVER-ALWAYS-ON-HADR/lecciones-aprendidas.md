# Lecciones aprendidas — LAB-02 SQL Server Always On

## Preparación de infraestructura

La configuración de red, DNS, Active Directory, firewall, cuentas de servicio y permisos del clúster es crítica antes de crear un Availability Group. Un error en cualquiera de estos puntos puede impedir la creación del listener, la comunicación entre réplicas o la sincronización de la base de datos.

## Cadena de backups y LSN

Para inicializar manualmente una base de datos en Always On no basta con restaurar cualquier backup FULL y cualquier backup LOG. La cadena debe ser coherente y cubrir el punto exacto necesario para que la réplica secundaria pueda incorporarse al Availability Group.

La resolución correcta fue rehacer la inicialización con una cadena limpia `FULL + LOG` y restaurarla en la secundaria con `NORECOVERY`.

## Listener como punto lógico de conexión

El listener no es una instancia SQL independiente. Es un nombre de red gestionado por el clúster que apunta dinámicamente a la réplica primaria activa.

Las pruebas de failover y failback demostraron que las aplicaciones o herramientas deben conectarse al listener para no depender del nodo físico que actúa como primario en cada momento.

## Failover manual

En un Availability Group con failover manual, el cambio de rol debe ejecutarse conectado directamente a la réplica secundaria que se desea promocionar a primaria.

Esto refuerza la importancia de comprobar siempre:

- Nodo al que se está conectado.
- Rol actual de cada réplica.
- Estado de sincronización.
- Salud del Availability Group.

## Réplicas secundarias legibles

Al configurar la réplica secundaria con conexiones `READ_ONLY`, SQL Server exige que la conexión indique intención de solo lectura.

La validación con `ApplicationIntent=ReadOnly` confirmó que la réplica secundaria puede utilizarse para consultas de lectura sin permitir escrituras indebidas.

## Jobs SQL Agent en Always On

Los jobs tradicionales de SQL Server Agent no deben ejecutarse sin adaptación en un entorno Always On.

Las tareas de backup, CHECKDB o mantenimiento deben conocer el rol de la réplica y la preferencia de backup configurada en el Availability Group.

Por este motivo se crearon jobs AG-aware que comprueban el rol antes de ejecutar cada tarea.

## Pruebas de caída y recuperación

Las pruebas de parada controlada, recuperación y resincronización demostraron la importancia de validar no solo la configuración inicial, sino también el comportamiento del entorno ante incidencias.

El laboratorio confirmó que, tras un failover controlado, el servicio puede mantenerse disponible por listener mientras el antiguo nodo primario queda fuera de servicio.

## Limpieza DNS

La detección de una IP APIPA en `ORN-SQL01` mostró la importancia de revisar el estado final de DNS.

Aunque el entorno funcionaba, impedir que una interfaz no válida registrase DNS ayudó a dejar una resolución de nombres más limpia y coherente con la arquitectura.

## Conclusión técnica

LAB-02 deja construido y validado un entorno Always On funcional, con clúster WSFC, File Share Witness, Availability Group, listener, réplicas sincronizadas, pruebas de failover, recuperación y jobs adaptados a alta disponibilidad.

