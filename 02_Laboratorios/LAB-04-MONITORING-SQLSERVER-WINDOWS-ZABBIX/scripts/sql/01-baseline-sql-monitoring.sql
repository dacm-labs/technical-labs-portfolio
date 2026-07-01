/*
    LAB-04 - SQL Server native monitoring baseline

    Purpose:
    Collect basic SQL Server status, memory, sessions, waits and Always On state.

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
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
    SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus;

SELECT
    cpu_count,
    scheduler_count,
    physical_memory_kb / 1024 AS PhysicalMemoryMB,
    committed_kb / 1024 AS SqlCommittedMB,
    committed_target_kb / 1024 AS SqlTargetMB,
    sqlserver_start_time
FROM sys.dm_os_sys_info;

SELECT
    COUNT(*) AS UserSessions
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

SELECT TOP (10)
    wait_type,
    waiting_tasks_count,
    wait_time_ms,
    signal_wait_time_ms
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE N'SLEEP%'
  AND wait_type NOT LIKE N'BROKER%'
  AND wait_type NOT LIKE N'XE%'
  AND wait_type NOT LIKE N'LAZYWRITER%'
  AND wait_type NOT LIKE N'REQUEST_FOR_DEADLOCK_SEARCH%'
  AND wait_type NOT LIKE N'CHECKPOINT_QUEUE%'
ORDER BY wait_time_ms DESC;

SELECT
    ag.name AS AvailabilityGroup,
    ags.primary_replica,
    ags.primary_recovery_health_desc,
    ags.secondary_recovery_health_desc,
    ags.synchronization_health_desc
FROM sys.availability_groups ag
JOIN sys.dm_hadr_availability_group_states ags
    ON ag.group_id = ags.group_id;

SELECT
    ar.replica_server_name,
    ars.role_desc,
    ars.connected_state_desc,
    ars.synchronization_health_desc,
    ar.availability_mode_desc,
    ar.failover_mode_desc
FROM sys.availability_replicas ar
JOIN sys.dm_hadr_availability_replica_states ars
    ON ar.replica_id = ars.replica_id
ORDER BY ar.replica_server_name;
