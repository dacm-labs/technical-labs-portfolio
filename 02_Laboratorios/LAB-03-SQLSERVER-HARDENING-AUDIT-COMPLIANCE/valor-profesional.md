# Competencias técnicas — LAB-03 SQL Server Hardening, Audit & Compliance

## Valor profesional

LAB-03 demuestra competencias directamente aplicables a roles junior de DBA SQL Server, administración de sistemas, infraestructura Windows, operación IT y seguridad defensiva.

El laboratorio no se limita a instalar servicios: valida un entorno ya desplegado, detecta desviaciones de seguridad, aplica hardening, configura auditoría, prueba mínimo privilegio y documenta evidencias.

---

## Competencias DBA

| Competencia | Evidencia en LAB-03 |
|---|---|
| Administración SQL Server | Inventario de instancias, logins, roles, permisos y configuración. |
| Always On Availability Groups | Validación de primary/secondary, listener, sincronización y salud. |
| Seguridad SQL Server | Hardening de autenticación, `sa`, grupos AD y permisos. |
| Auditoría | Server Audit, Database Audit Specification y lectura de `.sqlaudit`. |
| Operación segura | Cambios aplicados sin romper el Availability Group. |
| Troubleshooting | Detección y resolución de errores reales. |

---

## Competencias de seguridad defensiva

| Competencia | Evidencia |
|---|---|
| Reducción de superficie de ataque | Deshabilitación de opciones peligrosas. |
| Mínimo privilegio | Usuarios readonly, auditor y backup operator probados. |
| Separación de funciones | Grupos AD y roles específicos. |
| Trazabilidad | Registro de accesos, cambios y operaciones sobre datos. |
| Cumplimiento | Checklist final de controles y evidencias. |
| Gestión de secretos | Criterio de no publicar credenciales ni correos completos. |

---

## Competencias de sistemas Windows

| Competencia | Evidencia |
|---|---|
| Active Directory | Uso de dominio, grupos y usuarios funcionales. |
| DNS | Validación de resolución de nodos y listener. |
| Servicios Windows | Reinicio controlado de SQL Server y SQL Agent. |
| Permisos NTFS | Ajuste de carpeta de backups para cuenta de servicio SQL. |
| WSFC | Validación de clúster y estado HADR. |

---

## Competencias de automatización y validación

| Herramienta | Uso |
|---|---|
| PowerShell | DNS, puertos, rutas, servicios, ficheros y ejecución con `runas /netonly`. |
| T-SQL | Inventario, hardening, auditoría, validación y pruebas de permisos. |
| SSMS | Administración y evidencias visuales. |
| Markdown | Documentación pública estructurada. |

---

## Escenarios profesionales cubiertos

Este laboratorio es defendible en entrevista para explicar:

- Cómo revisar una instancia SQL Server antes de endurecerla.
- Cómo detectar diferencias de configuración entre nodos.
- Cómo pasar una instancia a Windows Authentication only.
- Por qué `sa` debe estar deshabilitado si no se usa.
- Qué opciones de superficie de ataque conviene revisar.
- Cómo configurar auditoría de servidor.
- Por qué el `audit_guid` importa en Always On.
- Cómo auditar operaciones sobre tablas concretas.
- Cómo validar mínimo privilegio con usuarios reales.
- Cómo separar lectura, auditoría y backup sin conceder `db_owner`.

---

## Relación con roles objetivo

| Rol | Encaje del laboratorio |
|---|---|
| DBA SQL Server junior | Seguridad, auditoría, roles, backups y Always On. |
| Administrador de sistemas junior | AD, DNS, servicios, permisos y validación de infraestructura. |
| Técnico de operación IT | Checklist, troubleshooting y continuidad de servicio. |
| Blue Team / SOC junior | Trazabilidad, auditoría, control de accesos y evidencias. |
| Técnico cloud junior | Base sólida para seguridad de datos en entornos híbridos. |

---

## Mensaje profesional resumido

LAB-03 demuestra capacidad para tomar un entorno SQL Server Always On funcional y convertirlo en una plataforma más segura, auditable y controlada, aplicando principios de hardening, mínimo privilegio y cumplimiento sin perder disponibilidad.