# Esquema lógico — LAB-01 SQL Server DBA

## Objetivo

Añadir un esquema lógico renderizable directamente en GitHub mediante Mermaid, manteniendo la imagen existente del flujo de administración.

La imagen publicada se conserva en:

```text
diagramas/lab01_flujo_de_administracion.png
```

## Esquema lógico Mermaid

```mermaid
flowchart LR
    subgraph DOMAIN["Dominio orion.lab - 10.10.20.0/24"]
        DC["ORN-DC01\nDomain Controller / DNS\n10.10.20.10"]
        SQL["ORN-SQL01\nSQL Server 2025 Developer\n10.10.20.20"]
        DBA["ORN-DBA01\nDBA Workstation\nSSMS / PowerShell\n10.10.20.30"]
    end

    subgraph SQLDATA["Almacenamiento SQL Server"]
        DATA["D:\\SQLData\nData files"]
        LOGS["E:\\SQLLogs\nTransaction logs"]
        BCK["F:\\SQLBackups\nBackups"]
        TEMP["TempDB dedicada\n4 data files"]
    end

    subgraph OPS["Operación DBA"]
        AGENT["SQL Server Agent\nJobs / schedules"]
        MAIL["Database Mail\nOperador DBA"]
        AUDIT["SQL Server Audit\nEventos auditados"]
        QS["Query Store\nDiagnóstico de consultas"]
        DASH["Dashboard DBA\nEstado operativo"]
    end

    DBA -->|SSMS / T-SQL / PowerShell| SQL
    DBA -->|RSAT / DNS / AD| DC
    SQL -->|Kerberos / grupos AD| DC

    SQL --> DATA
    SQL --> LOGS
    SQL --> TEMP
    SQL -->|FULL / DIFF / LOG| BCK

    SQL --> AGENT
    AGENT -->|Backups / CHECKDB / cleanup| BCK
    AGENT --> MAIL
    SQL --> AUDIT
    SQL --> QS
    DBA --> DASH
    DASH --> SQL
```

## Lectura rápida

- ORN-DC01 aporta identidad, DNS, usuarios y grupos.
- ORN-SQL01 centraliza motor SQL, bases, backups, jobs, auditoría y mantenimiento.
- ORN-DBA01 concentra la administración remota mediante SSMS y PowerShell.
- El almacenamiento queda separado por función para representar una base DBA ordenada.
