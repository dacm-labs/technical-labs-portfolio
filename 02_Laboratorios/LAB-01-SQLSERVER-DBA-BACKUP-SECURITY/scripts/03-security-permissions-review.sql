USE master;
GO

/* LAB-01 - Revision de logins de laboratorio */

SELECT
    name,
    type_desc,
    is_disabled,
    create_date,
    modify_date
FROM sys.server_principals
WHERE name LIKE N'ORION\\GG_SQL%'
   OR name LIKE N'ORION\\usr_sql%'
ORDER BY name;
GO

USE OrionLabDB;
GO

SELECT
    dp.name AS database_principal,
    dp.type_desc,
    rp.name AS database_role
FROM sys.database_role_members drm
JOIN sys.database_principals rp
    ON drm.role_principal_id = rp.principal_id
JOIN sys.database_principals dp
    ON drm.member_principal_id = dp.principal_id
WHERE dp.name LIKE N'ORION\\GG_SQL%'
   OR dp.name LIKE N'ORION\\usr_sql%'
ORDER BY database_principal, database_role;
GO
