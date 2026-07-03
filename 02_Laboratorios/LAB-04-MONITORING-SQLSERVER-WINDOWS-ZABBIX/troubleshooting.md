# Troubleshooting LAB-04

## Objetivo

Recoger incidencias reales detectadas durante el LAB-04 y documentar la resolución aplicada o la decisión operacional tomada.

## Incidencias y resolución

| Incidencia | Causa | Resolución / decisión |
|---|---|---|
| Backups LOG/DIFF antiguos | Jobs AG-aware activos pero sin schedule asociado | Documentado; se valida alerta SQL y recuperación manual con backup LOG. |
| Eventos transitorios de Failover Clustering | Reinicios / redimensionamiento de VMs SQL | Estado actual del clúster validado como Online / Healthy. |
| Registro local APIPA en ORN-SQL02 | Microsoft Failover Cluster Virtual Adapter | Se desactiva registro DNS del adaptador; DNS autoritativo queda limpio. |
| Apache no arrancaba por `ProxyTimeout` | Módulo proxy no habilitado | Se habilitan `proxy`, `proxy_fcgi`, `setenvif` y `php8.5-fpm`. |
| Zabbix Agent 2 en SQL02 no arrancaba con cuenta de dominio | Falta de derecho `Log on as a service` y permisos locales | Se corrige derecho de servicio, credencial y permisos; SQL02 queda con `ORION\svc_zbx_sqlmon`. |
| ORN-SQL01 se recupera con LocalSystem | Prioridad: estabilidad del lab y continuidad de métricas SQL custom | Se documenta como excepción temporal; checks SQL siguen OK. |
| Problemas genéricos Windows AppXSvc / InventorySvc | Triggers del template `Windows by Zabbix agent` sobre servicios Windows no críticos | No se mezclan con la validación SQL custom; limpieza futura opcional. |

## Criterio aplicado

- Diagnóstico antes de cambiar configuración.
- No romper hardening SQL Server.
- No publicar credenciales.
- Mantener monitorización operativa.
- Documentar hallazgos reales en Git.

## Resultado

Ninguna incidencia bloquea el cierre del LAB-04 v1. Los hallazgos quedan documentados y las mejoras futuras quedan identificadas.
