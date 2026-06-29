USE master;
GO

/* LAB-01 - Dashboard basico DBA */

SELECT
    @@SERVERNAME AS server_name,
    SERVERPROPERTY('ProductVersion') AS product_version,
    SERVERPROPERTY('Edition') AS edition,
    SERVERPROPERTY('MachineName') AS machine_name;
GO

SELECT
    name AS database_name,
    state_desc,
    recovery_model_desc,
    compatibility_level,
    create_date
FROM sys.databases
WHERE name = N'OrionLabDB';
GO

USE OrionLabDB;
GO

SELECT
    DB_NAME() AS database_name,
    name AS file_name,
    type_desc,
    physical_name,
    CAST(size * 8.0 / 1024 AS decimal(18,2)) AS size_mb
FROM sys.database_files;
GO

DBCC CHECKDB (N'OrionLabDB') WITH NO_INFOMSGS;
GO
