# Manifest de evidencias LAB-04

Este manifest recoge las capturas seleccionadas para publicación en Git dentro del LAB-04.

Las imágenes con credenciales visibles, cookies, tokens o información sensible quedan excluidas.

| Nº | Fichero publicado | Evidencia |
|---:|---|---|
| 0 | `images/00-lab04-evidence-overview.jpg` | Resumen visual del cierre de evidencias LAB-04. |
| 1 | `images/01-zabbix-dashboard-initial.jpg` | Dashboard inicial de Zabbix. |
| 2 | `images/02-zabbix-hosts-full-coverage-green.jpg` | Cobertura completa de hosts con disponibilidad ZBX verde. |
| 3 | `images/03-sql-custom-zabbix-get-sql01.jpg` | Checks SQL custom contra ORN-SQL01. |
| 4 | `images/04-sql-custom-zabbix-get-sql02.jpg` | Checks SQL custom contra ORN-SQL02. |
| 5 | `images/05-template-created.jpg` | Template SQL custom creado. |
| 6 | `images/06-items-list-10-custom.jpg` | 10 items SQL custom en el template. |
| 7 | `images/07-latest-data-sql-items.jpg` | Latest data SQL custom. |
| 8 | `images/08-latest-data-alwayson-items.jpg` | Latest data Always On. |
| 9 | `images/09-triggers-list-final.jpg` | Triggers SQL custom finales. |
| 10 | `images/10-problem-log-backup-detected.jpg` | Problema LOG backup detectado. |
| 11 | `images/11-backup-log-executed-msdb.jpg` | Backup LOG ejecutado y registrado en msdb. |
| 12 | `images/12-problem-log-backup-resolved.jpg` | Problema SQL resuelto. |
| 13 | `images/13-problems-sql-no-active.jpg` | Sin problemas SQL custom activos. |
| 14 | `images/14-template-export-yaml-download.jpg` | Export YAML del template Zabbix. |

## Uso

Estas imágenes complementan la documentación Markdown del LAB-04 y sirven como evidencia visual del cierre operativo del laboratorio.

## Validación representada

- Zabbix Server 7.0 LTS operativo.
- Zabbix Agent 2 operativo en nodos Windows.
- Hosts principales con disponibilidad ZBX verde.
- Checks SQL custom validados con zabbix_get.
- Template ORION SQL Server Custom Checks creado y enlazado.
- Items SQL custom recolectando datos reales.
- Triggers SQL custom creados.
- Alerta real de LOG backup antiguo generada en ORN-SQL01.
- Recuperación real tras backup LOG manual.
- Estado final sin problemas SQL custom activos.
