# PowerShell commands — LAB-03

## Validación DNS

```powershell
$Names = @(
    "ORN-DC01.orion.lab",
    "ORN-SQL01.orion.lab",
    "ORN-SQL02.orion.lab",
    "ORN-SQLAG01.orion.lab",
    "ORN-SQLCL01.orion.lab",
    "ORN-FSW01.orion.lab"
)

foreach ($Name in $Names) {
    Resolve-DnsName $Name -Type A |
    Select-Object Name, IPAddress
}
```

## Reinicio controlado de SQL02

```powershell
hostname
Restart-Service SQLSERVERAGENT -Force
Restart-Service MSSQLSERVER -Force
Start-Service MSSQLSERVER
Start-Service SQLSERVERAGENT
```

## Preparar carpeta de auditoría

```powershell
hostname
New-Item -Path "D:\SQLAudit" -ItemType Directory -Force
Get-Item "D:\SQLAudit"
```

## Abrir SSMS con usuario auditor

```powershell
$Ssms = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Filter "ssms.exe" -Recurse -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

Write-Host "SSMS encontrado en: $Ssms" -ForegroundColor Green
runas /netonly /user:ORION\usr_sql_audit "`"$Ssms`""
```

## Abrir SSMS con usuario backup operator

```powershell
$Ssms = Get-ChildItem "C:\Program Files","C:\Program Files (x86)" -Filter "ssms.exe" -Recurse -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

Write-Host "SSMS encontrado en: $Ssms" -ForegroundColor Green
runas /netonly /user:ORION\usr_sql_backupop "`"$Ssms`""
```

## Preparar ruta de backups en SQL01

```powershell
hostname
Test-Path "B:\SQLBackups"
New-Item -Path "B:\SQLBackups" -ItemType Directory -Force
icacls "B:\SQLBackups" /grant "ORION\svc_sql_engine:(OI)(CI)M"
Get-Item "B:\SQLBackups"
```

## Validar fichero de backup generado

```powershell
hostname
Test-Path "B:\SQLBackups\ORION_PrivilegeTest_BackupOperator_COPYONLY.bak"
Get-Item "B:\SQLBackups\ORION_PrivilegeTest_BackupOperator_COPYONLY.bak" |
    Select-Object FullName, Length, LastWriteTime
```

## Nota

Estos comandos pertenecen al laboratorio y deben adaptarse antes de ejecutarse en otro entorno.