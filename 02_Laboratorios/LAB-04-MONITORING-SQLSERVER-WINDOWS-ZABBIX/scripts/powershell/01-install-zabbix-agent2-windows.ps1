#requires -RunAsAdministrator
<#
.SYNOPSIS
Instala y configura Zabbix Agent 2 en servidores Windows del laboratorio ORION.

.DESCRIPTION
Script preparado para ORN-SQL01 y ORN-SQL02.
Configura Zabbix Agent 2 apuntando al servidor Zabbix ORN-MON01 / 10.10.20.70.
Crea regla de firewall restrictiva para permitir TCP 10050 solo desde ORN-MON01.

.PARAMETER ZabbixServer
IP o FQDN del servidor Zabbix.

.PARAMETER Hostname
Nombre del host tal como aparecerá en Zabbix.

.PARAMETER AgentVersion
Versión del agente Zabbix Agent 2.

.EXAMPLE
.\01-install-zabbix-agent2-windows.ps1 -Hostname "ORN-SQL01"

.EXAMPLE
.\01-install-zabbix-agent2-windows.ps1 -Hostname "ORN-SQL02"
#>

param(
    [string]$ZabbixServer = "10.10.20.70",
    [string]$Hostname = $env:COMPUTERNAME,
    [string]$AgentVersion = "7.0.27"
)

$ErrorActionPreference = "Stop"

$InstallerName = "zabbix_agent2-$AgentVersion-windows-amd64-openssl.msi"
$DownloadUrl = "https://cdn.zabbix.com/zabbix/binaries/stable/7.0/$AgentVersion/$InstallerName"
$TempPath = Join-Path $env:TEMP $InstallerName
$InstallFolder = "C:\Program Files\Zabbix Agent 2"
$ConfigFile = Join-Path $InstallFolder "zabbix_agent2.conf"
$LogFile = Join-Path $env:TEMP "zabbix_agent2_install.log"

Write-Host "=== ORION LAB-04 - Zabbix Agent 2 install ===" -ForegroundColor Cyan
Write-Host "Zabbix Server : $ZabbixServer"
Write-Host "Hostname      : $Hostname"
Write-Host "Agent version : $AgentVersion"
Write-Host "Download URL  : $DownloadUrl"
Write-Host ""

Write-Host "1. Descargando instalador..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempPath

Write-Host "2. Instalando Zabbix Agent 2..." -ForegroundColor Yellow
$MsiArgs = @(
    "/i", "`"$TempPath`"",
    "/qn",
    "/l*v", "`"$LogFile`"",
    "SERVER=$ZabbixServer",
    "SERVERACTIVE=$ZabbixServer",
    "HOSTNAME=$Hostname",
    "LISTENPORT=10050",
    "TLSCONNECT=unencrypted",
    "TLSACCEPT=unencrypted",
    "ENABLEPATH=1"
)

$Process = Start-Process -FilePath "msiexec.exe" -ArgumentList $MsiArgs -Wait -PassThru

if ($Process.ExitCode -ne 0) {
    throw "Error instalando Zabbix Agent 2. ExitCode: $($Process.ExitCode). Revisar log: $LogFile"
}

Write-Host "3. Validando configuración..." -ForegroundColor Yellow

if (-not (Test-Path $ConfigFile)) {
    throw "No se encontró el archivo de configuración: $ConfigFile"
}

Get-Content $ConfigFile |
    Where-Object { $_ -match "^(Server|ServerActive|Hostname|ListenPort)=" } |
    ForEach-Object { Write-Host $_ }

Write-Host "4. Configurando firewall Windows..." -ForegroundColor Yellow

$RuleName = "ORION - Zabbix Agent 2 TCP 10050 from ORN-MON01"

Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue |
    Remove-NetFirewallRule

New-NetFirewallRule `
    -DisplayName $RuleName `
    -Direction Inbound `
    -Action Allow `
    -Protocol TCP `
    -LocalPort 10050 `
    -RemoteAddress $ZabbixServer `
    -Profile Domain `
    | Out-Null

Write-Host "5. Reiniciando servicio..." -ForegroundColor Yellow

Restart-Service "Zabbix Agent 2" -Force

Start-Sleep -Seconds 3

Write-Host "6. Validación final..." -ForegroundColor Yellow

Get-Service "Zabbix Agent 2" |
    Select-Object Name,DisplayName,Status,StartType |
    Format-Table -AutoSize

Get-NetTCPConnection -LocalPort 10050 -State Listen -ErrorAction SilentlyContinue |
    Select-Object LocalAddress,LocalPort,State,OwningProcess |
    Format-Table -AutoSize

Get-NetFirewallRule -DisplayName $RuleName |
    Get-NetFirewallPortFilter |
    Select-Object Protocol,LocalPort |
    Format-Table -AutoSize

Get-NetFirewallRule -DisplayName $RuleName |
    Get-NetFirewallAddressFilter |
    Select-Object RemoteAddress |
    Format-Table -AutoSize

Write-Host ""
Write-Host "Zabbix Agent 2 instalado y configurado correctamente." -ForegroundColor Green