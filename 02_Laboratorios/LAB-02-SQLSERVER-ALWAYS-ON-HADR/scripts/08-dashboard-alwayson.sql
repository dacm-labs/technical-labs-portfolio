USE master;
GO

/*
LAB-02 - Dashboard final Always On
Ejecutar desde ORN-DBA01 en SSMS conectado al listener:
tcp:ORN-SQLAG01.orion.lab,1433
*/

SELECT
    @@SERVERNAME AS NodoActualPorListener,
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
    SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus;
GO

SELECT
    ag.name AS AvailabilityGroup,
    ag.automated_backup_preference_desc AS BackupPreference,
    ar.replica_server_name AS ReplicaServer,
    ars.role_desc AS RoleDesc,
    ars.connected_state_desc AS ConnectedState,
    ars.synchronization_health_desc AS SynchronizationHealth,
    ar.availability_mode_desc AS AvailabilityMode,
    ar.failover_mode_desc AS FailoverMode,
    ar.secondary_role_allow_connections_desc AS SecondaryConnections
FROM sys.availability_groups ag
JOIN sys.availability_replicas ar
    ON ag.group_id = ar.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states ars
    ON ar.replica_id = ars.replica_id
WHERE ag.name = N'ORION_AG01'
ORDER BY ar.replica_server_name;
GO

SELECT
    ag.name AS AvailabilityGroup,
    ar.replica_server_name AS ReplicaServer,
    DB_NAME(drs.database_id) AS DatabaseName,
    drs.database_state_desc AS DatabaseState,
    drs.synchronization_state_desc AS SynchronizationState,
    drs.synchronization_health_desc AS SynchronizationHealth,
    drs.is_suspended AS IsSuspended,
    drs.suspend_reason_desc AS SuspendReason
FROM sys.dm_hadr_database_replica_states drs
JOIN sys.availability_replicas ar
    ON drs.replica_id = ar.replica_id
JOIN sys.availability_groups ag
    ON ar.group_id = ag.group_id
WHERE ag.name = N'ORION_AG01'
  AND DB_NAME(drs.database_id) = N'OrionLabDB'
ORDER BY ar.replica_server_name;
GO

SELECT
    ag.name AS AvailabilityGroup,
    agl.dns_name AS ListenerName,
    agl.port AS ListenerPort,
    aglip.ip_address AS ListenerIP,
    aglip.ip_subnet_mask AS SubnetMask,
    aglip.state_desc AS ListenerIPState
FROM sys.availability_groups ag
JOIN sys.availability_group_listeners agl
    ON ag.group_id = agl.group_id
JOIN sys.availability_group_listener_ip_addresses aglip
    ON agl.listener_id = aglip.listener_id
WHERE ag.name = N'ORION_AG01';
GO

SELECT
    @@SERVERNAME AS NodoSQL,
    sys.fn_hadr_is_primary_replica(N'OrionLabDB') AS IsPrimaryReplica,
    sys.fn_hadr_backup_is_preferred_replica(N'OrionLabDB') AS IsPreferredBackupReplica;
GO
