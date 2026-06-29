/*
LAB-03 — 02 Hardening checks
Uso: inventario y validación de controles finales.
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
    type_desc,
    is_disabled,
    create_date,
    modify_date,
    default_database_name
FROM sys.server_principals
WHERE type IN ('S','U','G')
  AND name NOT LIKE '##%'
ORDER BY type_desc, name;
GO

SELECT
    roles.name AS ServerRole,
    members.name AS MemberName,
    members.type_desc AS MemberType,
    members.is_disabled
FROM sys.server_role_members srm
JOIN sys.server_principals roles
    ON srm.role_principal_id = roles.principal_id
JOIN sys.server_principals members
    ON srm.member_principal_id = members.principal_id
ORDER BY roles.name, members.name;
GO

SELECT
    sp.name,
    sp.is_disabled,
    sl.is_policy_checked,
    sl.is_expiration_checked,
    sp.create_date,
    sp.modify_date
FROM sys.server_principals sp
JOIN sys.sql_logins sl
    ON sp.principal_id = sl.principal_id
WHERE sp.type_desc = 'SQL_LOGIN'
  AND sp.name NOT LIKE '##%'
ORDER BY sp.name;
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
    e.name,
    e.type_desc,
    e.state_desc,
    t.port,
    d.role_desc,
    d.connection_auth_desc,
    d.encryption_algorithm_desc
FROM sys.endpoints e
LEFT JOIN sys.tcp_endpoints t
    ON e.endpoint_id = t.endpoint_id
LEFT JOIN sys.database_mirroring_endpoints d
    ON e.endpoint_id = d.endpoint_id
ORDER BY e.type_desc, e.name;
GO

SELECT
    name,
    product,
    provider,
    data_source,
    is_linked,
    is_remote_login_enabled,
    is_rpc_out_enabled,
    is_data_access_enabled
FROM sys.servers
ORDER BY name;
GO
