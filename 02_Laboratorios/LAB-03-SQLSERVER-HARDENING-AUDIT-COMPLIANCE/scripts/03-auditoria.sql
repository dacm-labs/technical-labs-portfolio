/*
LAB-03 — 03 Auditoría y trazabilidad
Uso: validar Server Audit, Database Audit Specification y eventos .sqlaudit.
*/

SELECT
    @@SERVERNAME AS ConnectedServer,
    SERVERPROPERTY('MachineName') AS MachineName;
GO

SELECT
    a.name,
    a.audit_guid,
    a.is_state_enabled,
    a.type_desc,
    a.on_failure_desc,
    a.queue_delay,
    fa.log_file_path,
    fa.max_file_size,
    fa.max_rollover_files
FROM sys.server_audits a
LEFT JOIN sys.server_file_audits fa
    ON a.audit_guid = fa.audit_guid
WHERE a.name = N'ORION_ServerAudit';
GO

SELECT
    sas.name AS AuditSpecificationName,
    sas.is_state_enabled,
    sad.audit_action_name,
    sad.audited_result,
    sad.class_desc,
    sad.is_group
FROM sys.server_audit_specifications sas
JOIN sys.server_audit_specification_details sad
    ON sas.server_specification_id = sad.server_specification_id
WHERE sas.name = N'ORION_ServerAuditSpec'
ORDER BY sad.audit_action_name;
GO

USE OrionLabDB;
GO

SELECT
    DB_NAME() AS DatabaseName;
GO

SELECT
    das.name AS DatabaseAuditSpecificationName,
    das.is_state_enabled,
    dad.audit_action_name,
    dad.audited_result,
    dad.class_desc,
    OBJECT_SCHEMA_NAME(dad.major_id) AS SchemaName,
    OBJECT_NAME(dad.major_id) AS ObjectName,
    USER_NAME(dad.audited_principal_id) AS AuditedPrincipal
FROM sys.database_audit_specifications das
JOIN sys.database_audit_specification_details dad
    ON das.database_specification_id = dad.database_specification_id
WHERE das.name = N'ORION_OrionLabDB_AuditSpec'
ORDER BY dad.audit_action_name;
GO

SELECT TOP (100)
    event_time,
    action_id,
    succeeded,
    server_principal_name,
    database_name,
    schema_name,
    object_name,
    statement
FROM sys.fn_get_audit_file('D:\SQLAudit\*.sqlaudit', DEFAULT, DEFAULT)
WHERE database_name = N'OrionLabDB'
   OR object_name = N'Clientes'
   OR statement LIKE N'%lab.Clientes%'
ORDER BY event_time DESC;
GO
