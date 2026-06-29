/*
LAB-03 — 05 Checklist final
Uso: ejecutar como ORION\adm-it en SQL01 y SQL02 para snapshot final.
*/

SELECT
    @@SERVERNAME AS ConnectedServer,
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS WindowsAuthOnly,
    SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
    SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus;
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
    name,
    type_desc,
    is_disabled,
    default_database_name
FROM sys.server_principals
WHERE name IN
(
    N'sa',
    N'ORION\GG_SQL_READONLY',
    N'ORION\GG_SQL_BACKUP_OPERATORS',
    N'ORION\GG_SQL_AUDIT_READERS',
    N'ORION\GG_SQL_DBA_ADMINS',
    N'ORION\adm-it',
    N'ORION\svc_sql_engine'
)
ORDER BY type_desc, name;
GO

SELECT
    pr.name AS PrincipalName,
    pe.permission_name,
    pe.state_desc
FROM sys.server_permissions pe
JOIN sys.server_principals pr
    ON pe.grantee_principal_id = pr.principal_id
WHERE pr.name IN
(
    N'ORION\GG_SQL_AUDIT_READERS',
    N'ORION\GG_SQL_READONLY',
    N'ORION\GG_SQL_BACKUP_OPERATORS',
    N'ORION\GG_SQL_DBA_ADMINS'
)
ORDER BY pr.name, pe.permission_name;
GO

SELECT
    a.name,
    a.audit_guid,
    a.is_state_enabled,
    a.type_desc,
    a.on_failure_desc,
    a.queue_delay,
    fa.log_file_path,
    fa.max_file_size,
    fa.max_rollover_files
FROM sys.server_audits a
LEFT JOIN sys.server_file_audits fa
    ON a.audit_guid = fa.audit_guid
WHERE a.name = N'ORION_ServerAudit';
GO

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
GO
