# Manifest de evidencias LAB-04

Este manifest recoge las capturas seleccionadas desde el documento técnico del LAB-04 para publicación en Git.

Las imágenes con credenciales visibles se excluyen. Las capturas seleccionadas son evidencias de estado, validación o recuperación operativa.

| Nº | Imagen origen DOCX | Fichero destino sugerido | Evidencia |
|---:|---|---|---|
| 1 | image130.png | 01-zabbix-dashboard-initial.png | Dashboard inicial Zabbix. |
| 2 | image217.png | 02-zabbix-hosts-full-coverage-green.png | Cobertura completa hosts en verde. |
| 3 | image297.png | 03-sql-custom-zabbix-get-sql01.png | Checks SQL custom contra ORN-SQL01. |
| 4 | image296.png | 04-sql-custom-zabbix-get-sql02.png | Checks SQL custom contra ORN-SQL02. |
| 5 | image318.png | 05-template-created.png | Template SQL custom creado. |
| 6 | image339.png | 06-items-list-10-custom.png | 10 items SQL custom. |
| 7 | image365.png | 07-latest-data-sql-items.png | Latest data SQL custom. |
| 8 | image369.png | 08-latest-data-alwayson-items.png | Latest data Always On. |
| 9 | image388.png | 09-triggers-list-final.png | Triggers SQL custom finales. |
| 10 | image390.png | 10-problem-log-backup-detected.png | Problema LOG backup detectado. |
| 11 | image391.png | 11-backup-log-executed-msdb.png | Backup LOG ejecutado y registrado. |
| 12 | image392.png | 12-problem-log-backup-resolved.png | Problema SQL resuelto. |
| 13 | image396.png | 13-problems-sql-no-active.png | Sin problemas SQL activos. |
| 14 | image397.png | 14-template-export-yaml-download.png | Export YAML del template. |

## Capturas complementarias identificadas

- Preflight RAM / DNS / puertos.
- Contadores SQL Server nativos.
- PerfMon CSV.
- Clúster y DNS.
- Instalación Zabbix Server.
- Agentes Windows.
- Validaciones SQL scripts.
- Enlace de template a hosts.

## Uso

Para materializar las imágenes en el repo local, ejecutar:

```powershell
.\scripts\powershell\09-extract-lab04-evidence-images.ps1 -DocxPath "D:\ruta\LAB-04-Monitoring Stack for SQL Server & Windows.docx"
```

Después revisar visualmente las capturas antes de commitearlas.
