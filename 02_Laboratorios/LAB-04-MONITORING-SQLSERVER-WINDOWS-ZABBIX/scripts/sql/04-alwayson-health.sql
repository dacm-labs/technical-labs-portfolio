/*
    LAB-04 - Always On Availability Group health check

    Purpose:
    Validate Availability Group, replicas, database synchronization state and listener status.
    Useful for native monitoring and future Zabbix custom checks.

    Execution:
    Run from SSMS on ORN-DBA01.
    Recommended connection:
      - tcp:ORN-SQLAG01.orion.lab,1433
*/

SET NOCOUNT ON;

SELECT
    @@SERVERNAME AS ConnectedServer,
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
    SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus;

SELECT
    ag.name AS AvailabilityGroup,
    ags.primary_replica,
    ags.primary_recovery_health_desc,
    ags.secondary_recovery_health_desc,
    ags.synchronization_health_desc
FROM sys.availability_groups ag
JOIN sys.dm_hadr_availability_group_states ags
    ON ag.group_id = ags.group_id;

SELECT
    ar.replica_server_name,
    ars.role_desc,
    ars.connected_state_desc,
    ars.synchronization_health_desc,
    ar.availability_mode_desc,
    ar.failover_mode_desc
FROM sys.availability_replicas ar
JOIN sys.dm_hadr_availability_replica_states ars
    ON ar.replica_id = ars.replica_id
ORDER BY ar.replica_server_name;

SELECT
    DB_NAME(drs.database_id) AS DatabaseName,
    ar.replica_server_name,
    drs.database_state_desc,
    drs.synchronization_state_desc,
    drs.synchronization_health_desc,
    drs.is_suspended
FROM sys.dm_hadr_database_replica_states drs
JOIN sys.availability_replicas ar
    ON drs.replica_id = ar.replica_id
WHERE DB_NAME(drs.database_id) = N'OrionLabDB'
ORDER BY ar.replica_server_name;

SELECT
    ag.name AS AvailabilityGroup,
    l.dns_name AS ListenerName,
    l.port AS ListenerPort,
    lip.ip_address AS ListenerIPAddress,
    lip.state_desc AS ListenerIPState
FROM sys.availability_groups ag
JOIN sys.availability_group_listeners l
    ON ag.group_id = l.group_id
JOIN sys.availability_group_listener_ip_addresses lip
    ON l.listener_id = lip.listener_id
ORDER BY ag.name, l.dns_name;
