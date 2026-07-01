/*
    LAB-04 - SQL Server Audit status monitoring check

    Purpose:
    Validate SQL Server Audit, Server Audit Specifications and Database Audit Specifications.
    Useful for native monitoring and future Zabbix custom checks.

    Execution:
    Run from SSMS on ORN-DBA01.
    Recommended connection:
      - tcp:ORN-SQLAG01.orion.lab,1433
*/

SET NOCOUNT ON;

SELECT
    @@SERVERNAME AS ConnectedServer,
    SERVERPROPERTY('MachineName') AS MachineName;

SELECT
    name,
    is_state_enabled,
    type_desc,
    on_failure_desc,
    queue_delay,
    create_date,
    modify_date
FROM sys.server_audits
ORDER BY name;

SELECT
    name,
    is_state_enabled,
    create_date,
    modify_date
FROM sys.server_audit_specifications
ORDER BY name;

USE OrionLabDB;
GO

SELECT
    DB_NAME() AS DatabaseName,
    name,
    is_state_enabled,
    create_date,
    modify_date
FROM sys.database_audit_specifications
ORDER BY name;
GO
