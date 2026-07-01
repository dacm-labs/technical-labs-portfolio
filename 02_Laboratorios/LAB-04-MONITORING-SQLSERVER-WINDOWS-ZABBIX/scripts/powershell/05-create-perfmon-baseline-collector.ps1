<#
.SYNOPSIS
    LAB-04 - Create native PerfMon baseline collector for SQL Server nodes.

.DESCRIPTION
    Creates a Windows Performance Monitor Data Collector Set using logman.
    Intended for ORN-SQL01 and ORN-SQL02 before deploying Zabbix.

.EXECUTION
    Run locally on ORN-SQL01 or ORN-SQL02 using PowerShell 7 as Administrator.

.PARAMETER CollectorName
    Name of the Data Collector Set.

.EXAMPLE
    .\05-create-perfmon-baseline-collector.ps1 -CollectorName ORION_SQL01_BASELINE
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$CollectorName
)

$BasePath = "D:\Monitoring\PerfMon"
$LogPath = "$BasePath\$CollectorName"
$CounterFile = "$BasePath\$CollectorName-counters.txt"

New-Item -Path $LogPath -ItemType Directory -Force | Out-Null

$Counters = @(
    "\Processor(_Total)\% Processor Time",
    "\Memory\Available MBytes",
    "\LogicalDisk(_Total)\% Free Space",
    "\SQLServer:SQL Statistics\Batch Requests/sec",
    "\SQLServer:General Statistics\User Connections",
    "\SQLServer:Buffer Manager\Page life expectancy",
    "\SQLServer:Locks(_Total)\Lock Waits/sec",
    "\SQLServer:Locks(_Total)\Number of Deadlocks/sec",
    "\SQLServer:Availability Replica(*)\Bytes Sent to Replica/sec",
    "\SQLServer:Availability Replica(*)\Bytes Received from Replica/sec",
    "\SQLServer:Database Replica(*)\Log Send Queue",
    "\SQLServer:Database Replica(*)\Redo Queue"
)

$Counters | Set-Content -Path $CounterFile -Encoding ASCII

logman query $CollectorName 2>$null

if ($LASTEXITCODE -eq 0) {
    logman stop $CollectorName 2>$null
    logman delete $CollectorName
}

logman create counter $CollectorName `
    -cf $CounterFile `
    -si 00:00:15 `
    -o "$LogPath\$CollectorName" `
    -f csv `
    -v mmddhhmm

logman query $CollectorName
