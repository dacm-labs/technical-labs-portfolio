# Lecciones aprendidas — LAB-03 SQL Server Hardening, Audit & Compliance

## 1. Endurecer un entorno HADR requiere validar antes de tocar

Antes de aplicar hardening fue necesario confirmar DNS, puertos, listener, estado del Availability Group, sincronización de la base y jobs AG-aware.

La lección clave es que en un entorno Always On no se debe cambiar configuración de seguridad sin comprobar primero que la plataforma está sana.

---

## 2. Las réplicas pueden estar funcionales pero no alineadas en seguridad

SQL01 y SQL02 estaban sincronizados a nivel de base de datos, pero no tenían el mismo estado de seguridad a nivel de instancia.

Hallazgos importantes:

- SQL02 estaba en Mixed Mode.
- SQL02 tenía `sa` habilitado.
- SQL02 no tenía todos los grupos funcionales como logins.
- SQL02 no tenía auditoría de servidor inicial.

Una base puede estar sincronizada y, aun así, los nodos pueden tener diferencias importantes de seguridad.

---

## 3. Windows-only reduce exposición en entornos integrados con AD

Pasar SQL02 a Windows Authentication only permitió alinear la seguridad del entorno con Active Directory.

Esto reduce dependencia de SQL logins locales y favorece control centralizado, grupos, trazabilidad y baja de usuarios desde dominio.

---

## 4. `sa` deshabilitado debe validarse en todos los nodos

No basta con revisar el primario. En entornos Always On hay que validar también la secundaria, porque tras un failover esa instancia puede convertirse en primaria.

`sa` quedó deshabilitado en SQL01 y SQL02.

---

## 5. El audit_guid importa en Always On

Una de las lecciones más valiosas del laboratorio fue comprobar que el `audit_guid` debe alinearse entre réplicas si se quiere que la auditoría de base de datos funcione de forma coherente tras un posible failover.

Crear auditorías con el mismo nombre no garantiza que tengan el mismo GUID.

---

## 6. La auditoría debe probarse generando eventos reales

No basta con crear la especificación de auditoría. Se deben ejecutar acciones reales y comprobar que quedan registradas.

En este laboratorio se validaron eventos:

- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`
- `SUCCESSFUL_LOGIN_GROUP`
- Cambios de auditoría y permisos

---

## 7. Mínimo privilegio se valida mejor con usuarios reales

Las pruebas con `EXECUTE AS` pueden no representar bien la pertenencia a grupos AD. Por eso se usaron sesiones reales con:

- `ORION\usr_sql_readonly`
- `ORION\usr_sql_audit`
- `ORION\usr_sql_backupop`

Esto hizo que la validación fuese más cercana a producción.

---

## 8. Backup operator no significa lector de datos

La prueba del usuario `usr_sql_backupop` demostró una separación muy útil:

- Puede ejecutar backup.
- No puede hacer `SELECT` sobre `lab.Clientes`.
- No es `db_datareader`, `db_datawriter` ni `db_owner`.

Esto refuerza la separación de responsabilidades en administración DBA.

---

## 9. Las rutas de backup dependen del servidor SQL, no de la estación DBA

El backup ejecutado desde SSMS se realiza en el servidor SQL, no en `ORN-DBA01`.

Esto permitió detectar y corregir una ruta incorrecta, usando finalmente:

```text
B:\SQLBackups\ORION_PrivilegeTest_BackupOperator_COPYONLY.bak
```

---

## 10. Las capturas públicas deben revisarse por sensibilidad

El inventario de credenciales puede mostrar correos técnicos o identidades sensibles. Para GitHub se debe publicar solo contenido anonimizado o evitar capturas innecesarias.

La documentación pública debe demostrar el control sin exponer secretos.

---

## Conclusión

LAB-03 refuerza una idea clave: un entorno funcional no es necesariamente un entorno seguro.

El valor del laboratorio está en pasar de “funciona” a “funciona, está endurecido, está auditado, tiene permisos mínimos y puedo demostrarlo con evidencias”.