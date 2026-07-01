/*
    LAB-04 - SQL Server Agent jobs monitoring check

    Purpose:
    Validate ORION SQL Agent jobs, enabled state, last execution status and schedules.

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
    j.name AS JobName,
    j.enabled,
    SUSER_SNAME(j.owner_sid) AS OwnerName,
    j.date_created,
    j.date_modified
FROM msdb.dbo.sysjobs j
WHERE j.name LIKE N'%ORION%'
   OR j.name LIKE N'%OrionLabDB%'
ORDER BY j.enabled DESC, j.name;

WITH JobHistory AS
(
    SELECT
        j.name AS JobName,
        j.enabled,
        h.run_status,
        CASE h.run_status
            WHEN 0 THEN 'FAILED'
            WHEN 1 THEN 'SUCCEEDED'
            WHEN 2 THEN 'RETRY'
            WHEN 3 THEN 'CANCELED'
            WHEN 4 THEN 'IN PROGRESS'
            ELSE 'UNKNOWN'
        END AS RunStatusDesc,
        msdb.dbo.agent_datetime(h.run_date, h.run_time) AS RunDateTime,
        h.run_duration,
        h.message,
        ROW_NUMBER() OVER
        (
            PARTITION BY j.job_id
            ORDER BY h.run_date DESC, h.run_time DESC
        ) AS rn
    FROM msdb.dbo.sysjobs j
    LEFT JOIN msdb.dbo.sysjobhistory h
        ON j.job_id = h.job_id
       AND h.step_id = 0
    WHERE j.name LIKE N'%ORION%'
       OR j.name LIKE N'%OrionLabDB%'
)
SELECT
    JobName,
    enabled,
    RunStatusDesc,
    RunDateTime,
    run_duration,
    message
FROM JobHistory
WHERE rn = 1
ORDER BY enabled DESC, JobName;

SELECT
    j.name AS JobName,
    j.enabled AS JobEnabled,
    s.name AS ScheduleName,
    s.enabled AS ScheduleEnabled,
    s.freq_type,
    CASE s.freq_type
        WHEN 1 THEN 'Once'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly relative'
        WHEN 64 THEN 'When SQL Agent starts'
        WHEN 128 THEN 'When idle'
        ELSE 'Other'
    END AS FrequencyTypeDesc,
    s.freq_interval,
    s.freq_subday_type,
    CASE s.freq_subday_type
        WHEN 1 THEN 'At specified time'
        WHEN 2 THEN 'Seconds'
        WHEN 4 THEN 'Minutes'
        WHEN 8 THEN 'Hours'
        ELSE 'Other'
    END AS SubdayTypeDesc,
    s.freq_subday_interval,
    s.active_start_time,
    s.active_end_time
FROM msdb.dbo.sysjobs j
LEFT JOIN msdb.dbo.sysjobschedules js
    ON j.job_id = js.job_id
LEFT JOIN msdb.dbo.sysschedules s
    ON js.schedule_id = s.schedule_id
WHERE j.name LIKE N'ORION AG%'
ORDER BY j.name, s.name;
