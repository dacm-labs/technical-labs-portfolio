USE msdb;
GO

/*
LAB-01 - Revision de historico de backups
Ejecutar desde SSMS conectado a ORN-SQL01.
*/

SELECT
    bs.database_name,
    CASE bs.type
        WHEN 'D' THEN 'FULL'
        WHEN 'I' THEN 'DIFF'
        WHEN 'L' THEN 'LOG'
        ELSE bs.type
    END AS backup_type,
    bs.backup_start_date,
    bs.backup_finish_date,
    DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date) AS duration_seconds,
    CAST(bs.backup_size / 1024.0 / 1024.0 AS decimal(18,2)) AS backup_size_mb,
    bmf.physical_device_name
FROM dbo.backupset bs
JOIN dbo.backupmediafamily bmf
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = N'OrionLabDB'
ORDER BY bs.backup_finish_date DESC;
GO
