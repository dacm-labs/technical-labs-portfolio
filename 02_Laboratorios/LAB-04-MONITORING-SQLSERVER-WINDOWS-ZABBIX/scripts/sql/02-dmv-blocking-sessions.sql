/*
    LAB-04 - SQL Server blocking sessions check

    Purpose:
    Detect active blocking sessions, blocked sessions, wait type, wait time and running statement.
    Useful for native monitoring and future Zabbix custom checks.

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

SELECT
    r.session_id,
    r.blocking_session_id,
    r.status,
    r.command,
    r.wait_type,
    r.wait_time,
    r.wait_resource,
    DB_NAME(r.database_id) AS DatabaseName,
    s.login_name,
    s.host_name,
    s.program_name,
    SUBSTRING(
        t.text,
        (r.statement_start_offset / 2) + 1,
        (
            (
                CASE r.statement_end_offset
                    WHEN -1 THEN DATALENGTH(t.text)
                    ELSE r.statement_end_offset
                END - r.statement_start_offset
            ) / 2
        ) + 1
    ) AS RunningStatement
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s
    ON r.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.blocking_session_id <> 0
   OR r.session_id IN
   (
       SELECT DISTINCT blocking_session_id
       FROM sys.dm_exec_requests
       WHERE blocking_session_id <> 0
   )
ORDER BY r.blocking_session_id DESC, r.session_id;
