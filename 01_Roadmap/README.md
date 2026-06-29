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
3. **Especialización progresiva:** el portfolio parte de sistemas y SQL Server, y evoluciona hacia alta disponibilidad, hardening, auditoría, monitorización, SOC, cloud, automatización y datos.

La línea principal actual queda definida como:

```text
SQL Server DBA → Alta disponibilidad → Hardening/Auditoría → Monitorización → AD/SOC/Cloud
```

---

## Estado actual

| Laboratorio | Estado | Área principal | Descripción |
|---|---|---|---|
| [LAB-00 — AÉGIDA Case Study](../02_Laboratorios/LAB-00-AEGIDA-CASE-STUDY) | Completado v1 | Ciberseguridad defensiva / Blue Team | Arquitectura segmentada con pfSense, Active Directory, PAW, Wazuh, DMZ, OT simulado y RED-KALI. |
| [LAB-01 — SQL Server DBA](../02_Laboratorios/LAB-01-SQLSERVER-DBA-BACKUP-SECURITY) | Completado v1 | SQL Server / DBA / Seguridad / Monitorización | SQL Server 2025 en dominio con backup, restore, PITR, SQL Agent, Database Mail, alertas, mínimo privilegio, auditoría, Query Store, dashboard DBA y evidencias visuales. |
| [LAB-02 — SQL Server Always On Availability Groups](../02_Laboratorios/LAB-02-SQLSERVER-ALWAYS-ON-HADR) | Completado v1 | SQL Server / Alta disponibilidad / HA-DR | WSFC, File Share Witness, Availability Group, listener, failover, failback, lectura en secundaria, jobs AG-aware y validación final de continuidad. |
| [LAB-03 — SQL Server Hardening, Audit & Compliance](../02_Laboratorios/LAB-03-SQLSERVER-HARDENING-AUDIT-COMPLIANCE) | Completado v1 | SQL Server / Seguridad / Auditoría / Compliance | Hardening de SQL Server Always On, Windows-only, `sa` deshabilitado, auditoría de servidor y base de datos, trazabilidad y mínimo privilegio con usuarios reales. |

---

## Roadmap operativo

| Prioridad | Línea | Laboratorio / evolución prevista | Objetivo técnico |
|---|---|---|---|
| 1 | Monitorización y operación | LAB-04 — Monitoring Stack para SQL Server y Windows | Centralizar métricas, logs, alertas y dashboards sobre SQL Server, Windows, Always On y servicios críticos. |
| 2 | Active Directory defensivo | LAB-05 — AD Hardening & Tiering | Reforzar identidad, administración privilegiada, Tier 0, GPOs, auditoría de cambios y control de acceso. |
| 3 | SOC / Blue Team | LAB-06 — Wazuh Detection & Response | Correlación de eventos, reglas, alertas, FIM, casos de uso defensivos y respuesta básica ante incidentes. |
| 4 | Cloud / híbrido | LAB-07 — Azure Hybrid Foundations | Conectar fundamentos cloud con identidad, backup, monitorización, seguridad y servicios híbridos. |
| 5 | Automatización | LAB-08 — PowerShell Automation for Sysadmin / DBA | Crear scripts reutilizables para inventario, reporting, validaciones, mantenimiento y operación diaria. |
| 6 | Datos / IA | LAB-09 — Data Platform & AI Foundations | Construir base de datos, pipelines, análisis con Python/SQL y preparación para proyectos de IA aplicada. |

---

## Continuidad técnica prevista

La evolución del portfolio se plantea como una línea de trabajo progresiva, no como una lista cerrada de tareas. Los laboratorios completados hasta ahora consolidan una base de sistemas Windows, SQL Server DBA, seguridad defensiva, alta disponibilidad, hardening, auditoría, trazabilidad y mínimo privilegio.

La siguiente línea natural de evolución es reforzar la **monitorización y operación continua** sobre la plataforma ya construida. Esto permite cerrar una cadena profesional muy defendible:

```text
DBA base → Alta disponibilidad → Hardening/Auditoría → Monitorización/Operación
```

Después de LAB-04, el portfolio puede crecer hacia Active Directory defensivo, SOC/Blue Team, automatización, cloud híbrido y datos/IA sin perder coherencia técnica.

Criterios de continuidad:

- Mantener coherencia con los laboratorios ya publicados.
- Aprovechar el dominio `orion.lab`, los nodos SQL, el Availability Group `ORION_AG01` y la base `OrionLabDB` como entorno técnico reutilizable.
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
Garantizo alta disponibilidad.
Endurezco la plataforma.
Audito actividad.
Valido mínimo privilegio.
Monitorizo salud operativa.
Evoluciono hacia cloud, SOC, automatización y datos.
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
