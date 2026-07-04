#requires -Version 5.1
<#!
.SYNOPSIS
    LAB-04 - Test connectivity from a Windows node to ORN-MON01 / Zabbix Server.

.DESCRIPTION
    Validates basic DNS/IP reachability and TCP connectivity to Zabbix Server ports.
    Intended to be executed on Windows nodes before or after installing Zabbix Agent 2.

.EXECUTION
    Run from PowerShell as Administrator on ORN-DC01, ORN-SQL01, ORN-SQL02, ORN-FSW01 or ORN-DBA01.

.EXAMPLE
    .\04-test-zabbix-connectivity.ps1

.EXAMPLE
    .\04-test-zabbix-connectivity.ps1 -ZabbixServer 10.10.20.70
#>

param(
    [string]$ZabbixServer = "10.10.20.70",
    [int[]]$Ports = @(80, 10051)
)

$ErrorActionPreference = "Continue"

Write-Host "=== LAB-04 - Zabbix connectivity test ===" -ForegroundColor Cyan
Write-Host "Local host    : $env:COMPUTERNAME"
Write-Host "Zabbix Server : $ZabbixServer"
Write-Host ""

Write-Host "=== IP configuration ===" -ForegroundColor Cyan
Get-NetIPConfiguration |
    Select-Object InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer |
    Format-List

Write-Host "=== ICMP test ===" -ForegroundColor Cyan
Test-Connection -ComputerName $ZabbixServer -Count 4 -ErrorAction SilentlyContinue |
    Select-Object Address, IPv4Address, ResponseTime |
    Format-Table -AutoSize

Write-Host "=== TCP tests ===" -ForegroundColor Cyan
foreach ($Port in $Ports) {
    $Result = Test-NetConnection -ComputerName $ZabbixServer -Port $Port -WarningAction SilentlyContinue

    [PSCustomObject]@{
        ComputerName = $Result.ComputerName
        RemoteAddress = $Result.RemoteAddress
        Port = $Port
        TcpTestSucceeded = $Result.TcpTestSucceeded
    }
} | Format-Table -AutoSize

Write-Host "=== Local Zabbix Agent service, if installed ===" -ForegroundColor Cyan
Get-Service "Zabbix Agent 2" -ErrorAction SilentlyContinue |
    Select-Object Name, DisplayName, Status, StartType |
    Format-Table -AutoSize

Write-Host "=== Local listener TCP 10050, if installed ===" -ForegroundColor Cyan
Get-NetTCPConnection -LocalPort 10050 -State Listen -ErrorAction SilentlyContinue |
    Select-Object LocalAddress, LocalPort, State, OwningProcess |
    Format-Table -AutoSize
