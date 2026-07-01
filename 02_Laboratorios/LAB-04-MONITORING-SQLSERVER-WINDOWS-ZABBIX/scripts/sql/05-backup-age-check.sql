/*
    LAB-04 - SQL Server backup age monitoring check

    Purpose:
    Validate latest FULL, DIFF and LOG backups for OrionLabDB.
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

;WITH LastBackups AS
(
    SELECT
        bs.database_name,
        CASE bs.type
            WHEN 'D' THEN 'FULL'
            WHEN 'I' THEN 'DIFF'
            WHEN 'L' THEN 'LOG'
            ELSE bs.type
        END AS BackupType,
        bs.backup_start_date,
        bs.backup_finish_date,
        DATEDIFF(MINUTE, bs.backup_finish_date, GETDATE()) AS MinutesSinceBackup,
        CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS BackupSizeMB,
        bmf.physical_device_name,
        ROW_NUMBER() OVER
        (
            PARTITION BY bs.database_name, bs.type
            ORDER BY bs.backup_finish_date DESC
        ) AS rn
    FROM msdb.dbo.backupset bs
    JOIN msdb.dbo.backupmediafamily bmf
        ON bs.media_set_id = bmf.media_set_id
    WHERE bs.database_name = N'OrionLabDB'
)
SELECT
    database_name,
    BackupType,
    backup_start_date,
    backup_finish_date,
    MinutesSinceBackup,
    BackupSizeMB,
    physical_device_name
FROM LastBackups
WHERE rn = 1
ORDER BY
    CASE BackupType
        WHEN 'FULL' THEN 1
        WHEN 'DIFF' THEN 2
        WHEN 'LOG' THEN 3
        ELSE 4
    END;

SELECT TOP (20)
    bs.database_name,
    CASE bs.type
        WHEN 'D' THEN 'FULL'
        WHEN 'I' THEN 'DIFF'
        WHEN 'L' THEN 'LOG'
        ELSE bs.type
    END AS BackupType,
    bs.backup_start_date,
    bs.backup_finish_date,
    DATEDIFF(MINUTE, bs.backup_finish_date, GETDATE()) AS MinutesSinceBackup,
    CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(10,2)) AS BackupSizeMB,
    bmf.physical_device_name
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = N'OrionLabDB'
ORDER BY bs.backup_finish_date DESC;
