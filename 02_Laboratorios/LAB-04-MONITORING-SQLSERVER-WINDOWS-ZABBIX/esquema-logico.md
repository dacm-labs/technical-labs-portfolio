# Esquema lógico — LAB-04 Monitoring Stack for SQL Server & Windows

## Objetivo

Añadir un esquema lógico renderizable directamente en GitHub mediante Mermaid, manteniendo la portada, el diagrama de arquitectura final y las evidencias existentes.

La imagen publicada se conserva en:

```text
diagramas/lab04_diagrama_de_arquitectura.png
```

## Esquema lógico Mermaid

```mermaid
flowchart LR
    DBA["ORN-DBA01\nDBA Workstation\nSSMS / Browser / PowerShell\n10.10.20.30"]
    MON["ORN-MON01\nUbuntu Server 26.04 LTS\nZabbix Server 7.0.27\n10.10.20.70"]
    DC["ORN-DC01\nAD DS / DNS\n10.10.20.10"]
    FSW["ORN-FSW01\nFile Share Witness\n10.10.20.40"]
    CL["ORN-SQLCL01\nWSFC Cluster\n10.10.20.50"]
    LST["ORN-SQLAG01\nAlways On Listener\n10.10.20.60:1433"]

    subgraph SQLAG["SQL Server Always On - ORION_AG01"]
        SQL01["ORN-SQL01\nPrimary final\nZabbix Agent 2\nSQL custom checks\n10.10.20.20"]
        SQL02["ORN-SQL02\nSecondary final\nZabbix Agent 2\nSQL custom checks\n10.10.20.21"]
        DB["OrionLabDB\nBackups / Jobs / HADR / Audit"]
    end

    subgraph ZBX["Capa Zabbix"]
        FRONT["Zabbix Frontend\nApache / PHP-FPM"]
        ZSERVER["Zabbix Server\nItems / Triggers / Problems"]
        PG["PostgreSQL\nBase zabbix"]
        TEMPLATE["Template\nORION SQL Server Custom Checks"]
    end

    subgraph CUSTOM["Checks custom SQL"]
        USERP["UserParameters\nzabbix_agent2.d"]
        PWSH["03-check-sql-dmv.ps1\nPowerShell wrapper"]
        DMVS["DMVs / msdb / HADR views\nWindows Authentication"]
    end

    DBA -->|HTTP 80| FRONT
    FRONT --> ZSERVER
    ZSERVER --> PG
    ZSERVER --> TEMPLATE

    MON -->|Agent TCP 10050| DC
    MON -->|Agent TCP 10050| FSW
    MON -->|Agent TCP 10050| DBA
    MON -->|Agent TCP 10050| SQL01
    MON -->|Agent TCP 10050| SQL02

    SQL01 --> USERP
    SQL02 --> USERP
    USERP --> PWSH
    PWSH --> DMVS
    DMVS --> DB

    DBA -->|SSMS / validación SQL| LST
    LST --> SQL01
    LST -. "Read-only / secundaria" .-> SQL02
    SQL01 <-->|HADR 5022| SQL02
    SQL01 --> DB
    SQL02 --> DB
    CL --> SQL01
    CL --> SQL02
    CL --> FSW
    DC -->|DNS / Kerberos| SQL01
    DC -->|DNS / Kerberos| SQL02

    TEMPLATE -->|10 items custom| ZSERVER
    ZSERVER -->|8 triggers custom| ALERT["Problems / Alertas\nLOG backup old detectado y recuperado"]
```

## Lectura rápida

- ORN-MON01 centraliza Zabbix Server, frontend, PostgreSQL e items/triggers.
- Los nodos SQL ejecutan Zabbix Agent 2 y UserParameters.
- Los checks SQL custom convierten DMVs y `msdb` en métricas Zabbix.
- La lógica primary-only evita falsos positivos de backups en la réplica secundaria.
- El lab valida un ciclo real: métrica → trigger → problema → backup correctivo → recuperación.
