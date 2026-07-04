#requires -version 5.1
<#
.SYNOPSIS
Ejecuta checks SQL Server para Zabbix Agent 2.

.DESCRIPTION
Wrapper local para exponer métricas SQL Server / Always On a Zabbix mediante UserParameters.
El script devuelve un único valor por ejecución, compatible con zabbix_get e items numéricos.
Ejecuta checks SQL Server usando Windows Authentication con la cuenta ORION\svc_zbx_sqlmon cuando el agente corre con esa identidad.

No se almacenan credenciales SQL en Git.
Debe existir un fichero local en cada nodo SQL:

C:\ProgramData\ORION\ZabbixSql\orion_sql_monitor.env

Formato:
Server=tcp:localhost,1433

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet(
        "ping",
        "sql_service",
        "agent_service",
        "user_sessions",
        "blocking_sessions",
        "failed_jobs_24h",
        "backup_full_age_hours",
        "backup_log_age_hours",
        "ag_health",
        "is_primary"
    )]
    [string]$Check,

    [string]$DatabaseName = "OrionLabDB",

    [string]$ConfigPath = "C:\ProgramData\ORION\ZabbixSql\orion_sql_monitor.env"
)

$ErrorActionPreference = "Stop"

function Read-OrionSqlConfig {
    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Config file not found: $Path"
    }

    $Config = @{}

    Get-Content -Path $Path | ForEach-Object {
        $Line = $_.Trim()

        if ([string]::IsNullOrWhiteSpace($Line)) {
            return
        }

        if ($Line.StartsWith("#")) {
            return
        }

        $Parts = $Line -split "=", 2

        if ($Parts.Count -eq 2) {
            $Config[$Parts[0].Trim()] = $Parts[1].Trim()
        }
    }

    foreach ($RequiredKey in @("Server")) {
        if (-not $Config.ContainsKey($RequiredKey) -or [string]::IsNullOrWhiteSpace($Config[$RequiredKey])) {
            throw "Missing required key in config file: $RequiredKey"
        }
    }

    return $Config
}

function Invoke-SqlScalar {
    param(
        [string]$Query,
        [string]$Database = "master"
    )

    $Cfg = Read-OrionSqlConfig -Path $ConfigPath

    $ConnectionString = "Server=$($Cfg.Server);Database=$Database;Integrated Security=True;Encrypt=False;TrustServerCertificate=True;Connection Timeout=5;"

    $Connection = New-Object System.Data.SqlClient.SqlConnection
    $Connection.ConnectionString = $ConnectionString

    try {
        $Connection.Open()

        $Command = $Connection.CreateCommand()
        $Command.CommandText = $Query
        $Command.CommandTimeout = 10

        $Result = $Command.ExecuteScalar()

        if ($null -eq $Result -or $Result -is [System.DBNull]) {
            return 0
        }

        return $Result
    }
    finally {
        if ($Connection.State -ne "Closed") {
            $Connection.Close()
        }

        $Connection.Dispose()
    }
}

function Get-ServiceRunningValue {
    param(
        [string]$ServiceName
    )

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($null -eq $Service) {
        return 0
    }

    if ($Service.Status -eq "Running") {
        return 1
    }

    return 0
}

try {
    $SafeDatabaseName = $DatabaseName.Replace("'", "''")

    switch ($Check) {
        "ping" {
            $Value = Invoke-SqlScalar -Query "SELECT CAST(1 AS int);"
        }

        "sql_service" {
            $Value = Get-ServiceRunningValue -ServiceName "MSSQLSERVER"
        }

        "agent_service" {
            $Value = Get-ServiceRunningValue -ServiceName "SQLSERVERAGENT"
        }

        "user_sessions" {
            $Value = Invoke-SqlScalar -Query "
                SELECT COUNT(*)
                FROM sys.dm_exec_sessions
                WHERE is_user_process = 1;
            "
        }

        "blocking_sessions" {
            $Value = Invoke-SqlScalar -Query "
                SELECT COUNT(*)
                FROM sys.dm_exec_requests
                WHERE blocking_session_id <> 0;
            "
        }

        "failed_jobs_24h" {
            $Value = Invoke-SqlScalar -Database "msdb" -Query "
                SELECT COUNT(*)
                FROM msdb.dbo.sysjobhistory h
                WHERE h.step_id = 0
                  AND h.run_status <> 1
                  AND msdb.dbo.agent_datetime(h.run_date, h.run_time) >= DATEADD(HOUR, -24, GETDATE());
            "
        }

        "backup_full_age_hours" {
            $Value = Invoke-SqlScalar -Database "msdb" -Query "
                SELECT COALESCE(DATEDIFF(HOUR, MAX(backup_finish_date), GETDATE()), 999999)
                FROM msdb.dbo.backupset
                WHERE database_name = N'$SafeDatabaseName'
                  AND type = 'D';
            "
        }

        "backup_log_age_hours" {
            $Value = Invoke-SqlScalar -Database "msdb" -Query "
                SELECT COALESCE(DATEDIFF(HOUR, MAX(backup_finish_date), GETDATE()), 999999)
                FROM msdb.dbo.backupset
                WHERE database_name = N'$SafeDatabaseName'
                  AND type = 'L';
            "
        }

        "ag_health" {
            $Value = Invoke-SqlScalar -Query "
                IF CONVERT(int, SERVERPROPERTY('IsHadrEnabled')) <> 1
                    SELECT CAST(0 AS int);
                ELSE
                    SELECT
                        CASE
                            WHEN EXISTS (
                                SELECT 1
                                FROM sys.dm_hadr_database_replica_states
                                WHERE is_local = 1
                                  AND synchronization_health_desc <> N'HEALTHY'
                            )
                            THEN CAST(0 AS int)
                            ELSE CAST(1 AS int)
                        END;
            "
        }

        "is_primary" {
            $Value = Invoke-SqlScalar -Query "
                IF CONVERT(int, SERVERPROPERTY('IsHadrEnabled')) <> 1
                    SELECT CAST(0 AS int);
                ELSE
                    SELECT
                        CASE
                            WHEN EXISTS (
                                SELECT 1
                                FROM sys.dm_hadr_database_replica_states
                                WHERE is_local = 1
                                  AND database_id = DB_ID(N'$SafeDatabaseName')
                                  AND is_primary_replica = 1
                            )
                            THEN CAST(1 AS int)
                            ELSE CAST(0 AS int)
                        END;
            "
        }
    }

    Write-Output $Value
    exit 0
}
catch {
    Write-Output 0
    exit 0
}
