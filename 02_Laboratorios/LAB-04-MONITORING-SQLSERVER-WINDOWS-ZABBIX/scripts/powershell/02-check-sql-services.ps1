<#
.SYNOPSIS
    LAB-04 - Native SQL Server services validation.

.DESCRIPTION
    Validates SQL Server Engine and SQL Server Agent service status on a local SQL Server node.
    Used as part of LAB-04 native monitoring baseline before deploying Zabbix.

.EXECUTION
    Run locally on ORN-SQL01 or ORN-SQL02 using PowerShell 7 as Administrator.
#>

$Services = @(
    "MSSQLSERVER",
    "SQLSERVERAGENT"
)

Write-Host "=== SQL Server service status ===" -ForegroundColor Cyan

Get-Service $Services |
Select-Object Name,DisplayName,Status,StartType |
Format-Table -AutoSize

Write-Host "`n=== SQL Server service accounts ===" -ForegroundColor Cyan

Get-CimInstance Win32_Service |
Where-Object { $_.Name -in $Services } |
Select-Object Name,State,StartMode,StartName |
Format-Table -AutoSize
