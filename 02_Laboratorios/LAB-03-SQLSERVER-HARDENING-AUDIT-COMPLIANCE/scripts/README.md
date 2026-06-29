# Scripts — LAB-03 SQL Server Hardening, Audit & Compliance

## Objetivo

Este directorio recoge scripts públicos de referencia utilizados durante LAB-03.

Los scripts están pensados como documentación técnica y guía reproducible. Antes de ejecutarlos en otro entorno deben revisarse nombres de servidor, rutas, dominio, base de datos y permisos.

---

## Scripts incluidos

| Script | Uso |
|---|---|
| `01-preflight-baseline.sql` | Validación inicial de listener, Always On, configuración base y jobs AG-aware. |
| `02-hardening-checks.sql` | Inventario y validación de controles de hardening. |
| `03-auditoria.sql` | Revisión de auditoría, audit GUID, Database Audit Specification y lectura de eventos. |
| `04-minimo-privilegio.sql` | Pruebas de roles y permisos para usuarios funcionales. |
| `05-checklist-final.sql` | Snapshot final de cumplimiento. |
| `powershell-commands.md` | Comandos PowerShell usados para servicios, rutas, backups y ejecución con `runas /netonly`. |

---

## Advertencias

- Los scripts contienen nombres internos del laboratorio (`ORION`, `ORN-*`, `orion.lab`) usados únicamente como nomenclatura técnica.
- No contienen contraseñas.
- Las rutas deben revisarse antes de usarse en otro entorno.
- La ejecución de hardening debe realizarse con privilegios administrativos y ventana de mantenimiento si se aplica a producción.
- Cambios como Windows Authentication only pueden requerir reinicio del servicio SQL Server.

---

## Estado

Scripts documentados como soporte del laboratorio.