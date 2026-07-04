# Esquema lógico — LAB-02 SQL Server Always On HADR

## Objetivo

Añadir un esquema lógico renderizable directamente en GitHub mediante Mermaid, manteniendo la topología visual existente.

La imagen publicada se conserva en:

```text
diagramas/01-topologia-logica-global-lab02.png
```

## Esquema lógico Mermaid

```mermaid
flowchart LR
    DBA["ORN-DBA01\nDBA Workstation\nSSMS / PowerShell\n10.10.20.30"]
    DC["ORN-DC01\nAD DS / DNS\n10.10.20.10"]
    FSW["ORN-FSW01\nFile Share Witness\n10.10.20.40"]
    CL["ORN-SQLCL01\nWSFC Cluster Name\n10.10.20.50"]
    LST["ORN-SQLAG01\nAlways On Listener\n10.10.20.60:1433"]

    subgraph AG["ORION_AG01 - Availability Group"]
        SQL01["ORN-SQL01\nSQL Server replica\nPrimary final\n10.10.20.20"]
        SQL02["ORN-SQL02\nSQL Server replica\nSecondary final\n10.10.20.21"]
        DB["OrionLabDB\nSynchronized / Healthy"]
    end

    DBA -->|Conexión normal 1433| LST
    LST -->|Dirige escritura al primario| SQL01
    LST -. "Read-only routing / ApplicationIntent" .-> SQL02

    SQL01 <-->|HADR endpoint 5022\nSYNCHRONOUS_COMMIT| SQL02
    SQL01 --> DB
    SQL02 --> DB

    DC -->|DNS / Kerberos / AD groups| SQL01
    DC -->|DNS / Kerberos / AD groups| SQL02
    DC -->|DNS listener / cluster objects| CL
    CL --> SQL01
    CL --> SQL02
    CL --> FSW
    FSW -->|Quorum vote| CL

    SQL01 -->|SQL Agent AG-aware jobs| JOB1["Jobs activos si rol primario/secundario corresponde"]
    SQL02 -->|Backup preference SECONDARY| JOB2["Backups preferidos en secundaria"]
```

## Lectura rápida

- El listener `ORN-SQLAG01` abstrae el nodo primario activo.
- `ORN-SQL01` queda como réplica primaria final y `ORN-SQL02` como secundaria final.
- WSFC y File Share Witness sostienen el clúster y quorum.
- Los jobs se adaptan al rol de la réplica para evitar tareas incorrectas tras failover.
