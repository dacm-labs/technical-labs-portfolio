# Evidencias LAB-04

## Objetivo

Recoger evidencias visuales seleccionadas del LAB-04 para demostrar la implantación completa del stack de monitorización con Zabbix, agentes Windows, checks SQL custom, items, triggers y recuperación real de una alerta.

Las capturas se seleccionan desde el documento técnico del laboratorio y deben revisarse antes de publicarse para evitar contraseñas, cookies, tokens o información sensible.

## Estado

- Manifest de capturas seleccionadas: `manifest.md`.
- Script de extracción desde DOCX: `../scripts/powershell/09-extract-lab04-evidence-images.ps1`.
- Carpeta destino de imágenes: `images/`.
- Paquete de evidencias generado fuera del repo durante el cierre documental para copia local.

## Evidencias principales seleccionadas

| Nº | Fichero previsto | Qué demuestra |
|---:|---|---|
| 1 | `images/01-zabbix-dashboard-initial.png` | Frontend Zabbix accesible y servidor operativo. |
| 2 | `images/02-zabbix-hosts-full-coverage-green.png` | Hosts Windows y Zabbix server con disponibilidad ZBX verde. |
| 3 | `images/03-sql-custom-zabbix-get-sql01.png` | Checks SQL custom funcionando en el nodo primario. |
| 4 | `images/04-sql-custom-zabbix-get-sql02.png` | Checks SQL custom funcionando en el nodo secundario. |
| 5 | `images/05-template-created.png` | Template `ORION SQL Server Custom Checks` creado en Zabbix. |
| 6 | `images/06-items-list-10-custom.png` | Items custom disponibles en el template. |
| 7 | `images/07-latest-data-sql-items.png` | Zabbix recolecta métricas SQL custom reales. |
| 8 | `images/08-latest-data-alwayson-items.png` | Always On health e is_primary validados en ambos nodos. |
| 9 | `images/09-triggers-list-final.png` | Triggers SQL custom creados con severidades. |
| 10 | `images/10-problem-log-backup-detected.png` | Zabbix detecta LOG backup antiguo en el primario. |
| 11 | `images/11-backup-log-executed-msdb.png` | Backup LOG manual registrado en msdb. |
| 12 | `images/12-problem-log-backup-resolved.png` | El problema SQL queda `RESOLVED`. |
| 13 | `images/13-problems-sql-no-active.png` | El filtro de problemas SQL queda limpio. |
| 14 | `images/14-template-export-yaml-download.png` | El template se exporta para dejarlo versionado en Git. |

## Criterio de publicación

- No publicar contraseñas reales.
- No publicar cookies de sesión ni tokens.
- Excluir capturas con credenciales visibles.
- Reducir tamaño de imágenes para uso en portfolio.
- Mantener trazabilidad entre documento técnico, manifest y Git.

## Resultado

Las evidencias seleccionadas cubren el cierre de LAB-04 v1:

- Zabbix Server operativo.
- Hosts Windows monitorizados.
- Checks SQL custom funcionando.
- Template SQL custom enlazado.
- Items y triggers creados.
- Alerta real detectada y recuperada.
- Export YAML versionado.
