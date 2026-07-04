# Esquema lógico — LAB-03 SQL Server Hardening, Audit & Compliance

## Objetivo

Añadir un esquema lógico renderizable directamente en GitHub mediante Mermaid, manteniendo la portada, la topología visual y las evidencias existentes.

La imagen publicada se conserva en:

```text
diagramas/Lab003-Topologia_logica_global.png
```

## Esquema lógico Mermaid

```mermaid
flowchart LR
    DBA["ORN-DBA01\nEstación DBA\nSSMS / PowerShell\n10.10.20.30"]
    DC["ORN-DC01\nAD DS / DNS\n10.10.20.10"]
    FSW["ORN-FSW01\nFile Share Witness\n10.10.20.40"]
    CL["ORN-SQLCL01\nWSFC Cluster\n10.10.20.50"]
    LST["ORN-SQLAG01\nAlways On Listener\n10.10.20.60:1433"]

    subgraph AG["ORION_AG01 - SQL Server Always On"]
        SQL01["ORN-SQL01\nPrimary final\nWindows-only\nsa disabled\n10.10.20.20"]
        SQL02["ORN-SQL02\nSecondary final\nWindows-only\nsa disabled\n10.10.20.21"]
        DB["OrionLabDB\nlab.Clientes auditada"]
    end

    subgraph SECURITY["Controles LAB-03"]
        HARD["Hardening\nSurface area reduced"]
        AUDS["Server Audit\nORION_ServerAudit"]
        AUDB["Database Audit Spec\nSELECT / INSERT / UPDATE / DELETE"]
        PRIV["Mínimo privilegio\nreadonly / audit / backupop"]
    end

    DBA -->|SSMS / pruebas usuarios reales| LST
    LST --> SQL01
    LST -. "ReadOnly / validación secundaria" .-> SQL02
    SQL01 <-->|HADR 5022\nSYNCHRONOUS_COMMIT| SQL02
    SQL01 --> DB
    SQL02 --> DB

    DC -->|Kerberos / grupos AD| SQL01
    DC -->|Kerberos / grupos AD| SQL02
    CL --> SQL01
    CL --> SQL02
    CL --> FSW

    SQL01 --> HARD
    SQL02 --> HARD
    SQL01 --> AUDS
    SQL02 --> AUDS
    DB --> AUDB
    DBA --> PRIV
    PRIV --> SQL01
    PRIV --> SQL02
```

## Lectura rápida

- LAB-03 no reconstruye la plataforma: endurece el Always On creado en LAB-02.
- La autenticación queda en Windows-only y `sa` deshabilitado.
- La auditoría se aplica a nivel servidor y base de datos.
- El mínimo privilegio se valida con usuarios reales de dominio.
