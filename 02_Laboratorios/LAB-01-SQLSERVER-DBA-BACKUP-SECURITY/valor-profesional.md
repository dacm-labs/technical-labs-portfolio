# Valor profesional — LAB-01 SQL Server DBA

## Resumen

LAB-01 demuestra una base práctica de administración SQL Server en un entorno Windows con dominio, servidor dedicado, estación administrativa y documentación técnica.

El laboratorio no se limita a instalar una herramienta: recorre un ciclo operativo completo con preparación del entorno, base de datos de prueba, copias, recuperación, tareas programadas, permisos, auditoría, diagnóstico y evidencias visuales.

---

## Competencias demostradas

| Área | Competencias |
|---|---|
| Sistemas Windows | Dominio, DNS, servidor miembro y estación administrativa. |
| SQL Server DBA | Instalación, configuración, rutas, base de datos y mantenimiento. |
| Recuperación | Backups, restore completo, point-in-time recovery y reparación de datos. |
| Operación | SQL Server Agent, schedules, retención y tareas recurrentes. |
| Control de acceso | Grupos de Active Directory, roles SQL y mínimo privilegio. |
| Auditoría | Registro y revisión de eventos relevantes. |
| Diagnóstico | Query Store y dashboard DBA. |
| Documentación | Markdown, capturas seleccionadas y explicación técnica defendible. |

---

## Puntos fuertes del laboratorio

- Separación clara entre controlador de dominio, servidor SQL y estación DBA.
- Administración remota desde una estación dedicada.
- Estructura de almacenamiento diferenciada para datos, logs, backups, TempDB y auditoría.
- Validación real de recuperación, no solo creación de backups.
- Automatización mediante SQL Server Agent.
- Avisos de fallo para tareas críticas.
- Pruebas de permisos con usuarios de laboratorio.
- Auditoría, Query Store y dashboard para explicar el estado final.
- Evidencias visuales preparadas para revisión pública.

---

## Uso en entrevistas

Este laboratorio permite explicar de forma práctica:

- Cómo preparar una base SQL Server administrable.
- Por qué un backup debe probarse con restore.
- Cómo funciona una cadena FULL, DIFF y LOG.
- Cómo recuperar datos tras un error operativo.
- Cómo automatizar mantenimiento.
- Cómo organizar permisos por grupos.
- Cómo revisar eventos y estado del entorno.
- Cómo preparar una base para alta disponibilidad.

---

## Relación con el portfolio

LAB-01 es la base técnica para la línea SQL Server del portfolio.

Desde este laboratorio se evoluciona hacia:

- LAB-02 — SQL Server Always On Availability Groups.
- LAB-03 — SQL Server Hardening, Audit & Compliance.
- LAB-04 — Monitoring Stack para SQL Server y Windows.

---

## Conclusión

LAB-01 aporta valor profesional porque demuestra administración SQL Server realista, recuperación, automatización, control de acceso, auditoría, diagnóstico y documentación técnica con evidencias.
