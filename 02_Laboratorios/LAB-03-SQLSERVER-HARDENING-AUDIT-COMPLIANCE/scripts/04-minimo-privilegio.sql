/*
LAB-03 — 04 Mínimo privilegio
Uso: ejecutar dentro de sesiones SSMS abiertas con los usuarios reales:
- ORION\usr_sql_readonly
- ORION\usr_sql_audit
- ORION\usr_sql_backupop
*/

USE OrionLabDB;
GO

SELECT
    @@SERVERNAME AS ConnectedServer,
    SUSER_SNAME() AS LoginName,
    USER_NAME() AS DatabaseUser,
    IS_MEMBER('db_datareader') AS IsDbDataReader,
    IS_MEMBER('db_backupoperator') AS IsBackupOperator,
    IS_MEMBER('ORION_AuditReaders') AS IsAuditReader,
    IS_MEMBER('db_datawriter') AS IsDbDataWriter,
    IS_MEMBER('db_owner') AS IsDbOwner;
GO

BEGIN TRY
    SELECT TOP (5) *
    FROM lab.Clientes;
END TRY
BEGIN CATCH
    SELECT
        'SELECT_CLIENTES' AS Operation,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

BEGIN TRY
    INSERT INTO lab.Clientes (Nombre, Email)
    VALUES ('Prueba Min Priv', 'minpriv-test@orion.lab');
END TRY
BEGIN CATCH
    SELECT
        'INSERT_CLIENTES' AS Operation,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

BEGIN TRY
    UPDATE lab.Clientes
    SET Nombre = Nombre
    WHERE ClienteID = -1;
END TRY
BEGIN CATCH
    SELECT
        'UPDATE_CLIENTES' AS Operation,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

BEGIN TRY
    DELETE FROM lab.Clientes
    WHERE ClienteID = -1;
END TRY
BEGIN CATCH
    SELECT
        'DELETE_CLIENTES' AS Operation,
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

/*
Prueba específica para backup operator:
BACKUP DATABASE OrionLabDB
TO DISK = N'B:\SQLBackups\ORION_PrivilegeTest_BackupOperator_COPYONLY.bak'
WITH COPY_ONLY, INIT, COMPRESSION, CHECKSUM, STATS = 5;
GO
*/
