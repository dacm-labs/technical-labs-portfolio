/*
LAB-03 — 01 Preflight baseline
Uso: ejecutar desde SSMS como ORION\adm-it.
Revisar conexión actual antes de ejecutar cada bloque.
*/

SELECT
    @@SERVERNAME AS ConnectedServer,
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('ServerName') AS ServerName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS WindowsAuthOnly,
    SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
    SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus;
GO

SELECT
    ag.name AS AvailabilityGroup,
    ags.primary_replica,
    ags.primary_recovery_health_desc,
    ags.secondary_recovery_health_desc,
    ags.synchronization_health_desc
FROM sys.availability_groups ag
JOIN sys.dm_hadr_availability_group_states ags
    ON ag.group_id = ags.group_id;
GO

SELECT
    ar.replica_server_name,
    ars.role_desc,
    ars.connected_state_desc,
    ars.synchronization_health_desc,
    ar.availability_mode_desc,
    ar.failover_mode_desc,
    ar.secondary_role_allow_connections_desc
FROM sys.availability_replicas ar
JOIN sys.dm_hadr_availability_replica_states ars
    ON ar.replica_id = ars.replica_id
ORDER BY ar.replica_server_name;
GO

SELECT
    DB_NAME(drs.database_id) AS DatabaseName,
    ar.replica_server_name,
    drs.database_state_desc,
    drs.synchronization_state_desc,
    drs.synchronization_health_desc,
    drs.is_suspended,
    drs.suspend_reason_desc
FROM sys.dm_hadr_database_replica_states drs
JOIN sys.availability_replicas ar
    ON drs.replica_id = ar.replica_id
WHERE DB_NAME(drs.database_id) = N'OrionLabDB'
ORDER BY ar.replica_server_name;
GO

SELECT
    name,
    value,
    value_in_use
FROM sys.configurations
WHERE name IN
(
    'show advanced options',
    'xp_cmdshell',
    'Ole Automation Procedures',
    'Ad Hoc Distributed Queries',
    'clr enabled',
    'cross db ownership chaining',
    'remote admin connections',
    'contained database authentication'
)
ORDER BY name;
GO

SELECT
    j.name,
    j.enabled,
    SUSER_SNAME(j.owner_sid) AS OwnerName,
    j.date_created,
    j.date_modified
FROM msdb.dbo.sysjobs j
WHERE j.name LIKE N'%ORION%'
   OR j.name LIKE N'%OrionLabDB%'
ORDER BY j.enabled DESC, j.name;
GO
