# Plan de trabajo — LAB-03 SQL Server Hardening, Audit & Compliance

## Enfoque

LAB-03 se ejecutó como una continuación directa de LAB-02. El objetivo fue partir de un entorno Always On operativo y aplicar una capa de seguridad, auditoría y cumplimiento sin romper la disponibilidad del Availability Group.

La ejecución se dividió en bloques para mantener control operativo y trazabilidad documental.

---

## Bloque 0 — Preflight inicial y baseline del entorno

Objetivo: confirmar que el entorno HADR estaba sano antes de aplicar cambios.

Validaciones realizadas:

- Resolución DNS de nodos, clúster y listener.
- Puertos críticos `1433`, `5022` y `3343`.
- Conexión al listener `ORN-SQLAG01`.
- Estado general de `ORION_AG01`.
- Rol de réplicas primary/secondary.
- Estado de `OrionLabDB` dentro del Availability Group.
- Configuración base SQL01 y SQL02.
- Jobs AG-aware en ambos nodos.

Resultado: entorno Always On operativo, con `ORN-SQL01` como primary y `ORN-SQL02` como secondary.

---

## Bloque 1 — Baseline de seguridad SQL Server

Objetivo: inventariar el estado de seguridad antes del hardening correctivo.

Inventario realizado:

- Logins en SQL01 y SQL02.
- Roles de servidor.
- Usuarios y roles de `OrionLabDB`.
- Permisos explícitos.
- SQL logins y políticas.
- Modo de autenticación.
- Endpoints HADR.
- Linked servers.
- Credenciales SQL.
- SQL Agent proxies.
- Auditorías existentes.

Hallazgos principales:

| Área | Hallazgo |
|---|---|
| SQL02 | Estaba en Mixed Mode. |
| SQL02 | `sa` estaba habilitado. |
| SQL02 | Faltaban algunos grupos AD funcionales a nivel de instancia. |
| SQL01 | `show advanced options` quedaba habilitado. |
| Auditoría | SQL01 tenía auditoría activa, SQL02 no. |

---

## Bloque 2 — Hardening correctivo

Objetivo: corregir asimetrías entre SQL01 y SQL02.

Acciones aplicadas en SQL02:

- Deshabilitación de `sa`.
- Creación/validación de grupos AD funcionales.
- Cambio de modo de autenticación a Windows-only.
- Reinicio controlado de servicios `MSSQLSERVER` y `SQLSERVERAGENT`.
- Validación posterior de Always On.

Acciones aplicadas en SQL01:

- Confirmación de `sa` deshabilitado.
- Confirmación de Windows-only.
- Validación de grupos AD funcionales.
- Cierre de `show advanced options`.
- Validación de superficie de ataque.

Resultado: ambos nodos quedaron alineados y el Availability Group continuó healthy.

---

## Bloque 3 — Auditoría y trazabilidad

Objetivo: implementar y validar auditoría coherente en el entorno Always On.

Acciones realizadas:

- Revisión de auditoría existente en SQL01.
- Creación de auditoría equivalente en SQL02.
- Validación de lectura de eventos `.sqlaudit`.
- Detección de diferencia de `audit_guid` entre nodos.
- Recreación controlada de la auditoría en SQL02 con el GUID de SQL01.
- Creación de auditoría de base de datos sobre `OrionLabDB.lab.Clientes`.
- Generación de eventos `SELECT`, `INSERT`, `UPDATE`, `DELETE`.
- Lectura de eventos auditados desde SQL01 y SQL02.

Resultado: auditoría activa y validada en primario y secundario, con `audit_guid` alineado.

---

## Bloque 4 — Validaciones de mínimo privilegio

Objetivo: demostrar que cada usuario funcional solo puede realizar su tarea.

Usuarios probados:

| Usuario | Resultado |
|---|---|
| `ORION\usr_sql_readonly` | Puede leer `lab.Clientes`, no puede insertar, actualizar ni borrar. |
| `ORION\usr_sql_audit` | Puede leer auditoría, no puede leer datos de negocio. |
| `ORION\usr_sql_backupop` | Puede ejecutar backup, no puede leer datos. |

Las pruebas se realizaron con SSMS abierto mediante usuarios reales de dominio, evitando simulaciones con `EXECUTE AS` para grupos AD.

---

## Bloque 5 — Checklist de cumplimiento y validación final

Objetivo: obtener una evidencia final consolidada del estado de cumplimiento.

Validaciones finales:

- Windows-only en SQL01 y SQL02.
- `sa` deshabilitado en ambos nodos.
- Superficie peligrosa deshabilitada.
- Grupos AD presentes.
- Permiso `VIEW SERVER SECURITY AUDIT` para el grupo auditor.
- Auditoría servidor activa.
- Database Audit Specification activa.
- Always On healthy.
- Roles de base de datos separados por función.

Resultado: entorno técnicamente validado y listo para cierre documental.

---

## Bloque 6 — Cierre documental

Objetivo: resumir el laboratorio en términos de arquitectura, controles, evidencias y valor profesional.

Contenido generado:

- Resumen ejecutivo.
- Objetivos alcanzados.
- Hardening aplicado.
- Auditoría de servidor y base de datos.
- Validación de mínimo privilegio.
- Estado final de Always On.
- Evidencias obtenidas.
- Valor profesional del laboratorio.

---

## Estado

Plan de trabajo completado. LAB-03 queda cerrado como **completado v1**.