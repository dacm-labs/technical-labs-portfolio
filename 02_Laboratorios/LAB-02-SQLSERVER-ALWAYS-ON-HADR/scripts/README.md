# Scripts — LAB-02 SQL Server Always On

Directorio reservado para scripts SQL y PowerShell del laboratorio.

## Scripts incorporados

| Script | Uso | Ejecución |
|---|---|---|
| `08-dashboard-alwayson.sql` | Dashboard final Always On. | SSMS conectado al listener desde `ORN-DBA01`. |
| `09-dashboard-wsfc.ps1` | Dashboard final WSFC. | PowerShell admin desde `ORN-SQL01`. |
| `10-ag-aware-jobs-validation.sql` | Validación de jobs AG-aware. | SSMS en `ORN-SQL01` y `ORN-SQL02`. |
| `11-connectivity-validation.ps1` | Validación final de DNS y puertos. | PowerShell desde `ORN-DBA01`. |

## Scripts pendientes opcionales

| Script | Uso |
|---|---|
| `01-install-failover-clustering.ps1` | Instalar Failover Clustering. |
| `02-create-wsfc-cluster.ps1` | Crear `ORN-SQLCL01`. |
| `03-configure-file-share-witness.ps1` | Configurar File Share Witness. |
| `04-hadr-endpoints.sql` | Revisar Always On y endpoints. |
| `05-seed-orionlabdb.sql` | Inicializar `OrionLabDB` en secundaria. |
| `06-create-availability-group.sql` | Crear `ORION_AG01`. |
| `07-create-listener.sql` | Crear `ORN-SQLAG01`. |

## Criterios

- Indicar desde qué máquina se ejecuta cada script.
- Separar scripts SQL y PowerShell.
- Mantener rutas y nombres coherentes con `orion.lab`.
- No incluir contraseñas, secretos ni datos personales.

