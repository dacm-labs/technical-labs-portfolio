# Evidencias — LAB-03 SQL Server Hardening, Audit & Compliance

## Objetivo

Este documento relaciona las evidencias visuales y técnicas seleccionadas para documentar LAB-03.

La memoria Word completa contiene el detalle paso a paso y capturas completas. En GitHub se publica una selección representativa, sin credenciales ni datos sensibles.

---

## Criterio de publicación

- No publicar contraseñas ni secretos.
- No publicar correos completos ni credenciales de Database Mail sin censura.
- No publicar la memoria Word completa como documento público.
- Priorizar capturas que demuestren resultados finales y controles aplicados.
- Evitar capturas repetitivas de pruebas intermedias.
- Documentar hallazgos y correcciones sin exponer datos sensibles.

---

## Evidencias recomendadas

| ID | Bloque | Evidencia | Valor técnico |
|---|---|---|---|
| PF-01 | Preflight | Validación DNS del laboratorio | Confirma resolución de nodos, clúster y listener. |
| PF-02 | Preflight | Puertos críticos `1433`, `5022`, `3343` | Confirma conectividad SQL, HADR y WSFC. |
| AG-01 | Preflight | Estado `ORION_AG01` healthy | Confirma estado sano antes del hardening. |
| AG-02 | Preflight | `OrionLabDB` synchronized / healthy | Evidencia de base protegida sincronizada. |
| JOB-01 | Preflight | Jobs AG-aware en SQL01 | Valida mantenimiento adaptado al rol. |
| JOB-02 | Preflight | Jobs AG-aware en SQL02 | Valida coherencia en secundaria. |
| SEC-01 | Baseline | SQL02 en Mixed Mode y `sa` habilitado | Hallazgo inicial de hardening. |
| SEC-02 | Baseline | Logins y roles SQL01 | Inventario de seguridad inicial. |
| SEC-03 | Baseline | Logins y roles SQL02 | Identificación de asimetrías. |
| HRD-01 | Hardening | `sa` deshabilitado en SQL02 | Corrección de exposición SQL login. |
| HRD-02 | Hardening | SQL02 Windows-only tras reinicio | Homogeneización de autenticación. |
| HRD-03 | Hardening | Superficie de ataque a `0` | Reducción de opciones peligrosas. |
| AUD-01 | Auditoría | `ORION_ServerAudit` activo en SQL01 | Auditoría de servidor operativa. |
| AUD-02 | Auditoría | `ORION_ServerAudit` activo en SQL02 | Auditoría replicada en secundaria. |
| AUD-03 | Auditoría | `audit_guid` alineado | Control crítico en Always On. |
| AUD-04 | Auditoría | `ORION_OrionLabDB_AuditSpec` activa | Auditoría de base sobre `lab.Clientes`. |
| AUD-05 | Auditoría | Eventos `SELECT/INSERT/UPDATE/DELETE` leídos | Trazabilidad sobre datos. |
| AUD-06 | Auditoría | Evento `SELECT` en secundaria read-only | Auditoría funcional en SQL02. |
| PRIV-01 | Mínimo privilegio | `usr_sql_readonly` lee y no modifica | Separación lectura/escritura. |
| PRIV-02 | Mínimo privilegio | `usr_sql_audit` lee auditoría y no datos | Separación auditoría/datos. |
| PRIV-03 | Mínimo privilegio | `usr_sql_backupop` hace backup y no lee datos | Separación backup/datos. |
| FIN-01 | Cierre | Snapshot final SQL01 | Cumplimiento final del primario. |
| FIN-02 | Cierre | Snapshot final SQL02 | Cumplimiento final del secundario. |

---

## Estructura sugerida de capturas

```text
capturas/
├── 01-preflight-baseline/
├── 02-security-baseline/
├── 03-surface-area/
├── 04-logins-roles-permissions/
├── 05-auditoria/
└── 06-validacion-final/
```

---

## Evidencias clave ya validadas en memoria

| Bloque | Evidencia técnica |
|---|---|
| Bloque 0 | DNS, puertos, listener, Always On, jobs AG-aware. |
| Bloque 1 | Baseline de logins, roles, permisos, endpoints, linked servers, credenciales, proxies y auditorías. |
| Bloque 2 | Corrección de Mixed Mode, `sa`, grupos AD y superficie de ataque. |
| Bloque 3 | Auditoría de servidor, audit GUID, auditoría de base y lectura de eventos. |
| Bloque 4 | Pruebas reales de mínimo privilegio con usuarios de dominio. |
| Bloque 5 | Checklist final de cumplimiento en SQL01 y SQL02. |

---

## Capturas sensibles

La evidencia de credenciales SQL / Database Mail puede contener correo técnico. Antes de publicar capturas de ese apartado, debe aplicarse censura visual sobre:

- Correos electrónicos.
- Identidades de credenciales.
- Cualquier ruta, token, secreto o dato no necesario para la explicación pública.

---

## Estado

Evidencias documentadas y criterios de publicación definidos.

Las capturas finales deben añadirse únicamente tras revisar que no contienen datos sensibles.