# Roadmap — Portfolio técnico

## Objetivo

Este directorio recoge la planificación estratégica del **portfolio técnico**.

El objetivo no es acumular laboratorios sueltos, sino construir una progresión coherente y defendible en sistemas, infraestructura, SQL Server, alta disponibilidad, seguridad defensiva, monitorización, cloud, automatización, datos y administración de bases de datos.

**Nota sobre nomenclatura interna:** nombres como `orion.lab`, `ORN-*`, `ORION_AG01` o similares se usan únicamente como convención técnica de laboratorio para ordenar máquinas, dominio, recursos y evidencias. No representan una marca pública ni una infraestructura real de producción.

---

## Criterio de priorización

El roadmap se ordena siguiendo tres criterios:

1. **Continuidad técnica:** cada laboratorio debe aprovechar lo aprendido o desplegado en los anteriores.
2. **Evidencia práctica:** cada bloque debe poder validarse con pruebas, capturas, scripts y documentación.
3. **Especialización progresiva:** el portfolio parte de sistemas y SQL Server, y evoluciona hacia alta disponibilidad, hardening, monitorización, SOC, cloud, automatización y datos.

La línea principal actual queda definida como:

```text
SQL Server DBA → Alta disponibilidad → Seguridad SQL → Monitorización → AD/SOC/Cloud
```

---

## Estado actual

| Laboratorio | Estado | Área principal | Descripción |
|---|---|---|---|
| [LAB-00 — AÉGIDA Case Study](../02_Laboratorios/LAB-00-AEGIDA-CASE-STUDY) | Completado v1 | Ciberseguridad defensiva / Blue Team | Arquitectura segmentada con pfSense, Active Directory, PAW, Wazuh, DMZ, OT simulado y RED-KALI. |
| [LAB-01 — SQL Server DBA](../02_Laboratorios/LAB-01-SQLSERVER-DBA-BACKUP-SECURITY) | Completado v1 | SQL Server / DBA / Seguridad / Monitorización | SQL Server 2025 en dominio con backup, restore, PITR, SQL Agent, Database Mail, alertas, mínimo privilegio, auditoría, Query Store, dashboard DBA y evidencias visuales. |
| [LAB-02 — SQL Server Always On Availability Groups](../02_Laboratorios/LAB-02-SQLSERVER-ALWAYS-ON-HADR) | Completado v1 | SQL Server / Alta disponibilidad / HA-DR | WSFC, File Share Witness, Availability Group, listener, failover, failback, lectura en secundaria, jobs AG-aware y validación final de continuidad. |

---

## Roadmap operativo

| Prioridad | Línea | Laboratorio / evolución prevista | Objetivo técnico |
|---|---|---|---|
| 1 | SQL Server Security & Hardening | LAB-03 — SQL Server Hardening, Audit & Compliance | Endurecimiento, auditoría extendida, permisos, trazabilidad y seguridad defensiva de datos. |
| 2 | Monitorización y operación | LAB-04 — Monitoring Stack para SQL Server y Windows | Métricas, alertas, logs, dashboards y operación continua del entorno. |
| 3 | Active Directory defensivo | LAB-05 — AD Hardening & Tiering | Protección de identidad, Tier 0, GPOs, auditoría y administración privilegiada. |
| 4 | SOC / Blue Team | LAB-06 — Wazuh Detection & Response | Reglas, alertas, FIM, playbooks y respuesta básica ante incidentes. |
| 5 | Cloud / híbrido | LAB-07 — Azure Hybrid Foundations | Identidad híbrida, backup, monitorización y servicios cloud conectados al laboratorio. |
| 6 | Automatización | LAB-08 — PowerShell Automation for Sysadmin / DBA | Scripts reproducibles para administración, reporting, validaciones y despliegues. |
| 7 | Datos / IA | LAB-09 — Data Platform & AI Foundations | Pipelines, análisis de datos, Python, SQL y base futura para IA aplicada. |

---

## Continuidad técnica prevista

La evolución del portfolio se plantea como una línea de trabajo progresiva, no como una lista cerrada de tareas. Los laboratorios completados hasta ahora consolidan una base de sistemas Windows, SQL Server DBA, seguridad defensiva y alta disponibilidad.

La siguiente línea natural de evolución es reforzar la **seguridad, auditoría, hardening y operación continua** sobre la plataforma ya construida. Esto permite profundizar en configuración segura, control de permisos, trazabilidad, monitorización y respuesta operativa sin perder continuidad con LAB-01 y LAB-02.

Criterios de continuidad:

- Mantener coherencia con los laboratorios ya publicados.
- Aprovechar el dominio `orion.lab`, los nodos SQL y la base `OrionLabDB` como entorno técnico reutilizable.
- Priorizar laboratorios que aporten valor demostrable para sistemas, DBA, seguridad defensiva y operación IT.
- Documentar decisiones, validaciones, incidencias y limitaciones de forma clara.
- Evitar publicar ejercicios aislados que no aporten una progresión técnica defendible.

---

## Narrativa técnica del portfolio

La historia técnica que debe transmitir el portfolio es:

```text
Diseño una infraestructura defensiva.
Administro servicios críticos.
Protejo datos.
Automatizo mantenimiento.
Audito actividad.
Valido alta disponibilidad.
Monitorizo salud operativa.
Evoluciono hacia cloud, SOC y datos.
```

Esta narrativa ayuda a que el portfolio no parezca una colección de prácticas, sino una progresión técnica ordenada hacia roles de sistemas, DBA/Data Platform, seguridad defensiva, cloud y automatización.

---

## Metodología común para nuevos laboratorios

Cada nuevo laboratorio debe mantener una estructura mínima similar:

```text
README.md
arquitectura.md
tecnologias.md
plan-trabajo.md
evidencias.md
checklist.md
capturas/
diagramas/
scripts/
docs/
```

---

## Reglas de calidad del portfolio

- No publicar capturas sin valor técnico.
- No publicar secretos ni credenciales.
- Mantener nombres de archivos claros.
- Usar commits frecuentes y descriptivos.
- Separar documentación pública de notas internas.
- Explicar siempre qué se ha construido, cómo se ha validado y qué incidencias se han resuelto.
- Incluir evidencias cuando el laboratorio esté validado.
- Reconocer limitaciones y mejoras futuras.
- Mantener el roadmap alineado con el estado real del repositorio.
