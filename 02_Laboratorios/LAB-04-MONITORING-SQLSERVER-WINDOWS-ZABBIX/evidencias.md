# Evidencias LAB-04

## Objetivo

Este archivo actúa como índice rápido de evidencias del LAB-04.

Las evidencias visuales publicadas se mantienen dentro de la carpeta:

```text
evidencias/
```

## Documentación de evidencias

| Recurso | Contenido |
|---|---|
| [evidencias/README.md](evidencias/README.md) | Descripción de las capturas seleccionadas y criterio de publicación. |
| [evidencias/manifest.md](evidencias/manifest.md) | Manifest con la relación completa de imágenes publicadas. |
| [evidencias/images/](evidencias/images/) | Carpeta con las 15 capturas JPG seleccionadas. |
| [scripts/powershell/09-extract-lab04-evidence-images.ps1](scripts/powershell/09-extract-lab04-evidence-images.ps1) | Script local de extracción de imágenes desde el documento técnico. |

## Capturas publicadas

| Nº | Fichero | Qué demuestra |
|---:|---|---|
| 0 | `00-lab04-evidence-overview.jpg` | Resumen visual del cierre de evidencias LAB-04. |
| 1 | `01-zabbix-dashboard-initial.jpg` | Zabbix Server y frontend operativos. |
| 2 | `02-zabbix-hosts-full-coverage-green.jpg` | Hosts principales monitorizados con ZBX verde. |
| 3 | `03-sql-custom-zabbix-get-sql01.jpg` | Checks SQL custom funcionando en ORN-SQL01. |
| 4 | `04-sql-custom-zabbix-get-sql02.jpg` | Checks SQL custom funcionando en ORN-SQL02. |
| 5 | `05-template-created.jpg` | Template SQL custom creado. |
| 6 | `06-items-list-10-custom.jpg` | 10 items SQL custom definidos. |
| 7 | `07-latest-data-sql-items.jpg` | Métricas SQL custom recolectadas. |
| 8 | `08-latest-data-alwayson-items.jpg` | Always On health e is_primary validados. |
| 9 | `09-triggers-list-final.jpg` | Triggers SQL custom creados. |
| 10 | `10-problem-log-backup-detected.jpg` | Problema LOG backup antiguo detectado. |
| 11 | `11-backup-log-executed-msdb.jpg` | Backup LOG manual registrado en msdb. |
| 12 | `12-problem-log-backup-resolved.jpg` | Problema SQL resuelto. |
| 13 | `13-problems-sql-no-active.jpg` | Sin problemas SQL custom activos al cierre. |
| 14 | `14-template-export-yaml-download.jpg` | Export YAML del template Zabbix. |

## Criterio de publicación

- No publicar contraseñas reales.
- No publicar cookies de sesión ni tokens.
- Excluir capturas con credenciales visibles.
- Publicar solo imágenes con valor técnico claro.
- Mantener trazabilidad entre documento técnico, manifest y repositorio.

## Conclusión

Las evidencias publicadas cubren el ciclo operativo completo del LAB-04: despliegue, monitorización, checks SQL custom, triggers, alerta real, corrección y recuperación.
