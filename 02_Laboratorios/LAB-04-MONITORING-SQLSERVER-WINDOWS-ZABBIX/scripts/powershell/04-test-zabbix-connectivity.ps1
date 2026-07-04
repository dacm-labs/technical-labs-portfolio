# LAB-04 - Zabbix connectivity test

param(
    [string]$ZabbixServer = "10.10.20.70",
    [int[]]$Ports = @(80, 10051)
)

Write-Host "=== LAB-04 - Zabbix connectivity test ===" -ForegroundColor Cyan
Write-Host "Local host    : $env:COMPUTERNAME"
Write-Host "Zabbix Server : $ZabbixServer"
Write-Host ""

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
