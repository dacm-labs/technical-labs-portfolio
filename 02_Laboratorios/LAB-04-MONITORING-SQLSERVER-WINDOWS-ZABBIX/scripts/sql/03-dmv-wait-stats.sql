/*
    LAB-04 - SQL Server wait stats check

    Purpose:
    Review top SQL Server wait statistics excluding common idle/background waits.
    Useful for native monitoring baseline and future Zabbix custom checks.

    Execution:
    Run from SSMS on ORN-DBA01.
    Recommended connections:
      - tcp:ORN-SQLAG01.orion.lab,1433
      - tcp:ORN-SQL01.orion.lab,1433
      - tcp:ORN-SQL02.orion.lab,1433
*/

SET NOCOUNT ON;

SELECT
    @@SERVERNAME AS ConnectedServer,
    SERVERPROPERTY('MachineName') AS MachineName;

SELECT TOP (20)
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    signal_wait_time_ms,
    wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms,
    CASE
        WHEN waiting_tasks_count = 0 THEN 0
        ELSE wait_time_ms / waiting_tasks_count
    END AS avg_wait_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE N'SLEEP%'
  AND wait_type NOT LIKE N'BROKER%'
  AND wait_type NOT LIKE N'XE%'
  AND wait_type NOT LIKE N'LAZYWRITER%'
  AND wait_type NOT LIKE N'REQUEST_FOR_DEADLOCK_SEARCH%'
  AND wait_type NOT LIKE N'CHECKPOINT_QUEUE%'
  AND wait_type NOT LIKE N'SQLTRACE_BUFFER_FLUSH%'
  AND wait_type NOT LIKE N'CLR_AUTO_EVENT%'
  AND wait_type NOT LIKE N'CLR_MANUAL_EVENT%'
  AND wait_type NOT LIKE N'FT_IFTS%'
ORDER BY wait_time_ms DESC;
