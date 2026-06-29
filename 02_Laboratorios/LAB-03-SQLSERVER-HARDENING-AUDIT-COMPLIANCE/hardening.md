# Hardening — LAB-03 SQL Server

## Objetivo

Documentar las medidas de endurecimiento aplicadas sobre las instancias `ORN-SQL01` y `ORN-SQL02` dentro del entorno Always On `ORION_AG01`.

El objetivo principal fue corregir asimetrías, reducir superficie de ataque y dejar ambos nodos en un estado coherente de seguridad.

---

## Hallazgos del baseline

| Área | SQL01 | SQL02 | Hallazgo |
|---|---|---|---|
| Autenticación | Windows-only | Mixed Mode | SQL02 debía alinearse con SQL01. |
| Login `sa` | Deshabilitado | Habilitado | SQL02 tenía `sa` activo. |
| Grupos AD | Completo | Parcial | SQL02 no tenía todos los grupos funcionales como logins. |
| Auditoría | Activa | No configurada | SQL02 debía recibir auditoría equivalente. |
| `show advanced options` | Habilitado | Deshabilitado | SQL01 debía quedar cerrado tras validaciones. |

---

## Controles aplicados

### 1. Deshabilitación de `sa`

Se validó que el login `sa` quedara deshabilitado en ambos nodos.

```sql
ALTER LOGIN [sa] DISABLE;
```

Resultado final:

| Nodo | Estado `sa` |
|---|---|
| `ORN-SQL01` | Deshabilitado |
| `ORN-SQL02` | Deshabilitado |

---

### 2. Windows Authentication only

SQL02 estaba en Mixed Mode y se cambió a Windows Authentication only para homogeneizar ambos nodos.

```sql
EXEC xp_instance_regwrite
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'LoginMode',
    REG_DWORD,
    1;
```

Después se realizó reinicio controlado del servicio SQL Server en SQL02.

Validación final:

```sql
SELECT SERVERPROPERTY('IsIntegratedSecurityOnly') AS WindowsAuthOnly;
```

| Nodo | WindowsAuthOnly |
|---|---:|
| `ORN-SQL01` | `1` |
| `ORN-SQL02` | `1` |

---

### 3. Grupos funcionales de Active Directory

Se validaron o crearon los logins de grupos AD necesarios en ambos nodos:

```sql
CREATE LOGIN [ORION\GG_SQL_READONLY] FROM WINDOWS;
CREATE LOGIN [ORION\GG_SQL_BACKUP_OPERATORS] FROM WINDOWS;
CREATE LOGIN [ORION\GG_SQL_AUDIT_READERS] FROM WINDOWS;
```

Grupos finales:

| Grupo | Uso |
|---|---|
| `ORION\GG_SQL_DBA_ADMINS` | Administración DBA. |
| `ORION\GG_SQL_READONLY` | Lectura controlada. |
| `ORION\GG_SQL_BACKUP_OPERATORS` | Backups sin lectura de datos. |
| `ORION\GG_SQL_AUDIT_READERS` | Consulta de auditoría. |

---

### 4. Reducción de superficie de ataque

Se validó que las opciones sensibles quedaran deshabilitadas:

| Opción | Valor final |
|---|---:|
| `xp_cmdshell` | `0` |
| `Ole Automation Procedures` | `0` |
| `Ad Hoc Distributed Queries` | `0` |
| `clr enabled` | `0` |
| `cross db ownership chaining` | `0` |
| `remote admin connections` | `0` |
| `contained database authentication` | `0` |
| `show advanced options` | `0` |

---

### 5. Validación Always On tras cambios

Después de aplicar hardening, se validó que el Availability Group siguiera operativo.

| Elemento | Estado |
|---|---|
| `ORION_AG01` | Healthy |
| `ORN-SQL01` | Primary / Connected / Healthy |
| `ORN-SQL02` | Secondary / Connected / Healthy |
| `OrionLabDB` | Synchronized / Healthy / Not suspended |

---

## Resultado final

| Control | Estado |
|---|---|
| `sa` deshabilitado | Completado |
| Windows-only | Completado |
| Grupos AD alineados | Completado |
| Superficie peligrosa deshabilitada | Completado |
| Always On tras hardening | Healthy |

---

## Conclusión

El hardening correctivo eliminó las principales diferencias de seguridad entre SQL01 y SQL02. Ambos nodos quedaron alineados en autenticación, estado del login `sa`, grupos funcionales y reducción de superficie de ataque.

La validación posterior confirmó que las medidas no afectaron negativamente a Always On ni a la sincronización de `OrionLabDB`.