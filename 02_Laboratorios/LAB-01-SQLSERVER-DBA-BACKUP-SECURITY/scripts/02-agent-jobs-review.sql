USE msdb;
GO

/* LAB-01 - Revision de jobs */

SELECT
    name AS job_name,
    enabled,
    date_created,
    date_modified
FROM dbo.sysjobs
WHERE name LIKE N'ORION%'
ORDER BY name;
GO

SELECT TOP 50
    j.name AS job_name,
    h.step_id,
    h.step_name,
    h.run_date,
    h.run_time,
    h.run_status
FROM dbo.sysjobhistory h
JOIN dbo.sysjobs j
    ON h.job_id = j.job_id
WHERE j.name LIKE N'ORION%'
ORDER BY h.instance_id DESC;
GO
