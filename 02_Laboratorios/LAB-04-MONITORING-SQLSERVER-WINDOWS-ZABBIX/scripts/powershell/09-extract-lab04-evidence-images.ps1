#requires -Version 5.1
<#
.SYNOPSIS
    Extrae evidencias seleccionadas del documento Word del LAB-04.

.DESCRIPTION
    Trata el .docx como ZIP, extrae word/media/image*.png y copia las capturas seleccionadas
    a evidencias/images con nombres descriptivos.

    Revisar visualmente las capturas antes de hacer commit.

.PARAMETER DocxPath
    Ruta al documento Word LAB-04.

.PARAMETER LabPath
    Ruta raíz del LAB-04 dentro del repositorio.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$DocxPath,

    [string]$LabPath = (Resolve-Path "$PSScriptRoot\..\..").Path
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $DocxPath)) {
    throw "DOCX not found: $DocxPath"
}

$ImagesPath = Join-Path $LabPath 'evidencias\images'
$TempRoot = Join-Path $env:TEMP ('lab04-docx-images-' + [guid]::NewGuid().ToString('N'))
$ZipPath = Join-Path $TempRoot 'lab04.zip'
$ExtractPath = Join-Path $TempRoot 'extract'

New-Item -ItemType Directory -Path $ImagesPath -Force | Out-Null
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null
Copy-Item -Path $DocxPath -Destination $ZipPath -Force
Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force

$MediaPath = Join-Path $ExtractPath 'word\media'

$Map = [ordered]@{
    'image130.png' = '01-zabbix-dashboard-initial.png'
    'image217.png' = '02-zabbix-hosts-full-coverage-green.png'
    'image297.png' = '03-sql-custom-zabbix-get-sql01.png'
    'image296.png' = '04-sql-custom-zabbix-get-sql02.png'
    'image318.png' = '05-template-created.png'
    'image339.png' = '06-items-list-10-custom.png'
    'image365.png' = '07-latest-data-sql-items.png'
    'image369.png' = '08-latest-data-alwayson-items.png'
    'image388.png' = '09-triggers-list-final.png'
    'image390.png' = '10-problem-log-backup-detected.png'
    'image391.png' = '11-backup-log-executed-msdb.png'
    'image392.png' = '12-problem-log-backup-resolved.png'
    'image396.png' = '13-problems-sql-no-active.png'
    'image397.png' = '14-template-export-yaml-download.png'
}

foreach ($Item in $Map.GetEnumerator()) {
    $Source = Join-Path $MediaPath $Item.Key
    $Target = Join-Path $ImagesPath $Item.Value

    if (-not (Test-Path $Source)) {
        Write-Warning "Missing source image: $($Item.Key)"
        continue
    }

    Copy-Item -Path $Source -Destination $Target -Force
    Get-Item $Target | Select-Object Name, Length, LastWriteTime
}

Remove-Item -Path $TempRoot -Recurse -Force

Write-Host "LAB-04 evidence images extracted to: $ImagesPath" -ForegroundColor Green
Write-Host "Review images before commit. Do not publish captures with passwords, cookies or tokens." -ForegroundColor Yellow
