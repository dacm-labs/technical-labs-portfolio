#requires -Version 5.1
<#
.SYNOPSIS
    Extrae evidencias seleccionadas del documento Word del LAB-04.

.DESCRIPTION
    Trata el .docx como ZIP, extrae word/media/image*.png y genera las capturas JPG
    publicables en evidencias/images con nombres descriptivos.

    La selección se revisó visualmente contra el documento técnico para evitar capturas
    que no se correspondían con su nombre publicado.

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

Add-Type -AssemblyName System.Drawing

function Convert-PngToJpeg {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Target
    )

    $Image = [System.Drawing.Image]::FromFile($Source)
    $Canvas = New-Object System.Drawing.Bitmap($Image.Width, $Image.Height)
    $Graphics = [System.Drawing.Graphics]::FromImage($Canvas)

    try {
        $Graphics.Clear([System.Drawing.Color]::White)
        $Graphics.DrawImage($Image, 0, 0, $Image.Width, $Image.Height)
        $Canvas.Save($Target, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    }
    finally {
        $Graphics.Dispose()
        $Canvas.Dispose()
        $Image.Dispose()
    }
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
    'image130.png' = '01-zabbix-dashboard-initial.jpg'
    'image361.png' = '02-zabbix-hosts-full-coverage-green.jpg'
    'image293.png' = '03-sql-custom-zabbix-get-sql01.jpg'
    'image292.png' = '04-sql-custom-zabbix-get-sql02.jpg'
    'image315.png' = '05-template-created.jpg'
    'image337.png' = '06-items-list-10-custom.jpg'
    'image368.png' = '07-latest-data-sql-items.jpg'
    'image369.png' = '08-latest-data-alwayson-items.jpg'
    'image384.png' = '09-triggers-list-final.jpg'
    'image386.png' = '10-problem-log-backup-detected.jpg'
    'image387.png' = '11-backup-log-executed-msdb.jpg'
    'image389.png' = '12-problem-log-backup-resolved.jpg'
    'image392.png' = '13-problems-sql-no-active.jpg'
    'image393.png' = '14-template-export-yaml-download.jpg'
}

foreach ($Item in $Map.GetEnumerator()) {
    $Source = Join-Path $MediaPath $Item.Key
    $Target = Join-Path $ImagesPath $Item.Value

    if (-not (Test-Path $Source)) {
        Write-Warning "Missing source image: $($Item.Key)"
        continue
    }

    Convert-PngToJpeg -Source $Source -Target $Target
    Get-Item $Target | Select-Object Name, Length, LastWriteTime
}

Remove-Item -Path $TempRoot -Recurse -Force

Write-Host "LAB-04 evidence images extracted to: $ImagesPath" -ForegroundColor Green
Write-Host "Review images before commit. Do not publish captures with passwords, cookies or tokens." -ForegroundColor Yellow
