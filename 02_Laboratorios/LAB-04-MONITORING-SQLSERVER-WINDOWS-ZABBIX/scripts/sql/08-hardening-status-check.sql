/*
    LAB-04 - SQL Server hardening status check

    Purpose:
    Validate SQL Server authentication mode, risky surface-area options and key logins.
    Useful for native monitoring baseline and future Zabbix custom checks.

    Execution:
    Run from SSMS on ORN-DBA01.
    Recommended connections:
      - tcp:ORN-SQL01.orion.lab,1433
      - tcp:ORN-SQL02.orion.lab,1433
*/

SET NOCOUNT ON;

SELECT
    @@SERVERNAME AS ConnectedServer,
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS WindowsAuthOnly,
    SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
    SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus;

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
    N'ORION\svc_sql_engine',
    N'ORION\svc_sql_agent'
)
ORDER BY type_desc, name;
