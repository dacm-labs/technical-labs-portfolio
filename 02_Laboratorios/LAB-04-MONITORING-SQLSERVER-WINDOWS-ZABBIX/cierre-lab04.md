# Cierre documental LAB-04

## Estado

LAB-04 queda cerrado como **Completado v1**.

## Entregables cerrados

| Entregable | Estado |
|---|---|
| Baseline nativo Windows / SQL Server | Cerrado |
| ORN-MON01 Ubuntu Server | Cerrado |
| Zabbix Server 7.0 LTS | Cerrado |
| Zabbix Agent 2 en nodos Windows | Cerrado |
| Monitorización base Windows | Cerrado |
| Wrapper PowerShell para checks SQL | Cerrado |
| UserParameters SQL custom | Cerrado |
| Template `ORION SQL Server Custom Checks` | Cerrado |
| Items SQL custom | Cerrado |
| Triggers SQL custom | Cerrado |
| Export YAML del template | Cerrado |
| Manifest y script de evidencias visuales | Cerrado |
| Documentación Git | Cerrado |

## Validación funcional clave

El laboratorio no se limita a mostrar métricas. También valida un ciclo operativo completo:

1. Zabbix recolecta métricas SQL custom desde ORN-SQL01 y ORN-SQL02.
2. El template detecta LOG backup antiguo.
3. La alerta aparece solo en ORN-SQL01 porque es el primario.
4. ORN-SQL02 no genera falso positivo por ser secundario.
5. Se ejecuta backup LOG manual.
6. Zabbix actualiza el item.
7. El problema queda resuelto automáticamente.
8. El filtro de problemas SQL queda limpio.

## Hallazgos documentados

| Hallazgo | Decisión |
|---|---|
| Jobs AG-aware sin schedule activo | Se documenta como causa de backups antiguos; no bloquea el lab. |
| Alertas genéricas Windows por servicios AppXSvc / InventorySvc | No afectan a validación SQL custom. |
| ORN-SQL01 validado temporalmente con Agent 2 en LocalSystem | Se mantiene estable; homogeneización futura opcional. |
| Dashboard dedicado no creado en v1 | Se deja como mejora futura; Latest data, Problems y evidencias cubren la validación operativa. |

## Resultado profesional

LAB-04 demuestra operación realista de monitorización sobre un entorno SQL Server Always On:

- Observabilidad centralizada con Zabbix.
- Integración Windows/Linux.
- Monitorización SQL custom con PowerShell y Windows Authentication.
- Diseño de triggers con criterio DBA.
- Reducción de falsos positivos en entornos Always On.
- Troubleshooting y documentación de incidencias reales.
- Evidencias reproducibles para portfolio.

## Próximo paso natural

```text
LAB-05 — Active Directory Hardening & Tiering
```
