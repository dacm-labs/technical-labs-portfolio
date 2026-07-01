<#
.SYNOPSIS
    LAB-04 - Windows critical and warning events validation.

.DESCRIPTION
    Reads recent System log events with Critical, Error and Warning levels.
    Used to detect OS, DNS, cluster, storage and platform issues before deploying Zabbix.

.EXECUTION
    Run locally on ORN-SQL01 or ORN-SQL02 using PowerShell 7 as Administrator.

.PARAMETER Days
    Number of days to look back. Default: 1.
#>

param(
    [int]$Days = 1
)

Write-Host "=== Windows System events: Critical / Error / Warning ===" -ForegroundColor Cyan

Get-WinEvent -FilterHashtable @{
    LogName   = 'System'
    Level     = 1,2,3
    StartTime = (Get-Date).AddDays(-$Days)
} |
Select-Object TimeCreated,ProviderName,Id,LevelDisplayName,Message |
Select-Object -First 20 |
Format-Table TimeCreated,ProviderName,Id,LevelDisplayName -AutoSize

Write-Host "`n=== Failover Clustering events ===" -ForegroundColor Cyan

Get-WinEvent -FilterHashtable @{
    LogName      = 'System'
    ProviderName = 'Microsoft-Windows-FailoverClustering'
    StartTime    = (Get-Date).AddDays(-$Days)
} |
Select-Object -First 10 TimeCreated,ProviderName,Id,LevelDisplayName,Message |
Format-List
