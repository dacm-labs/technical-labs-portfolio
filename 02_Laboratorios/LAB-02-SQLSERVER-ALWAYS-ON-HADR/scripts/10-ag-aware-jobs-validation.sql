USE msdb;
GO

/*
LAB-02 - Validacion de jobs AG-aware
Ejecutar en ORN-SQL01 y ORN-SQL02 desde SSMS.
*/

SELECT
    @@SERVERNAME AS NodoSQL,
    name AS JobName,
    enabled AS JobEnabled
FROM msdb.dbo.sysjobs
WHERE name LIKE N'ORION AG -%'
ORDER BY name;
GO

USE master;
GO

SELECT
    @@SERVERNAME AS NodoSQL,
    sys.fn_hadr_is_primary_replica(N'OrionLabDB') AS IsPrimaryReplica,
    sys.fn_hadr_backup_is_preferred_replica(N'OrionLabDB') AS IsPreferredBackupReplica;
GO

USE msdb;
GO

SELECT TOP 30
    @@SERVERNAME AS NodoSQL,
    j.name AS JobName,
    h.step_id,
    h.step_name,
    h.run_date,
    h.run_time,
    h.run_status,
    CASE h.run_status
        WHEN 0 THEN 'Failed'
        WHEN 1 THEN 'Succeeded'
        WHEN 2 THEN 'Retry'
        WHEN 3 THEN 'Canceled'
        WHEN 4 THEN 'In progress'
    END AS RunStatusText,
    h.message
FROM msdb.dbo.sysjobhistory h
JOIN msdb.dbo.sysjobs j
    ON h.job_id = j.job_id
WHERE j.name LIKE N'ORION AG -%'
ORDER BY h.instance_id DESC;
GO
