# Arquitectura LAB-04

## Objetivo

Definir la arquitectura lógica del stack de monitorización desplegado para supervisar Windows Server, SQL Server y Always On Availability Groups dentro del laboratorio.

LAB-04 reutiliza la plataforma construida en LAB-01, LAB-02 y LAB-03, incorporando una capa centralizada de operación con Zabbix Server y checks SQL custom.

## Vista lógica en imagen

La siguiente imagen muestra la arquitectura lógica final del LAB-04, incluyendo Zabbix Server, Zabbix Agent 2, nodos Windows, SQL Server Always On, listener, File Share Witness, WSFC, métricas, alertas y dashboards.

![Diagrama de arquitectura LAB-04](diagramas/lab04_diagrama_de_arquitectura.png)

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

## Componentes principales

| Componente | Rol |
|---|---|
| ORN-MON01 | Servidor central de monitorización con Zabbix Server, frontend, PostgreSQL, Apache y agente local. |
| ORN-DC01 | Controlador de dominio y DNS interno del laboratorio. |
| ORN-SQL01 | Nodo SQL Server principal habitual del Availability Group. |
| ORN-SQL02 | Nodo SQL Server secundario habitual del Availability Group. |
| ORN-SQLAG01 | Listener Always On utilizado para acceso lógico a la base protegida. |
| ORN-SQLCL01 | Nombre del Windows Server Failover Cluster. |
| ORN-FSW01 | File Share Witness para quorum. |
| ORN-DBA01 | Estación de administración, SSMS, navegador y validaciones operativas. |

## Red

| Elemento | Valor |
|---|---|
| Dominio | `orion.lab` |
| Red interna | `10.10.20.0/24` |
| DNS interno | `10.10.20.10` |
| Zabbix Server | `10.10.20.70` |
| Frontend Zabbix | `http://10.10.20.70/zabbix/` |
| Puerto Zabbix Agent | `10050/TCP` |
| Puerto Zabbix Server | `10051/TCP` |
| Puerto SQL Server | `1433/TCP` |
| Puerto HADR | `5022/TCP` |
| Puerto WSFC | `3343/TCP` |

## Flujo de monitorización

1. Zabbix Server consulta agentes Windows mediante TCP 10050.
2. Zabbix Agent 2 recoge métricas base de sistema operativo mediante la plantilla `Windows by Zabbix agent`.
3. En los nodos SQL, Zabbix Agent 2 ejecuta UserParameters SQL custom.
4. Los UserParameters llaman al wrapper PowerShell `03-check-sql-dmv.ps1`.
5. El wrapper ejecuta consultas T-SQL con Windows Authentication y devuelve un único valor numérico por check.
6. Zabbix guarda los valores como items, aplica triggers y genera problemas cuando se supera una condición.
7. La recuperación se valida cuando el item vuelve a un valor correcto y el problema pasa a `RESOLVED`.

## Diseño de autenticación

Los checks SQL custom se diseñan para evitar usuarios SQL y secretos en Git.

| Elemento | Decisión |
|---|---|
| Modo SQL Server | Windows Authentication Only, heredado del LAB-03. |
| Credenciales SQL | No se versionan usuarios ni contraseñas SQL. |
| Config local | `Server=tcp:localhost,1433`. |
| Cuenta técnica | `ORION\svc_zbx_sqlmon` donde es viable. |
| Excepción documentada | ORN-SQL01 queda temporalmente con Zabbix Agent 2 en LocalSystem, con checks validados. |

## Diseño anti-falsos positivos

En Always On no todos los checks deben alertar igual en primario y secundario.

Por ese motivo, los triggers de backup usan lógica `primary-only` con el item:

```text
orion.sql.ag.is_primary[OrionLabDB]
```

Esto evita que ORN-SQL02 genere alertas de backup cuando actúa como réplica secundaria.

## Capas de monitorización

| Capa | Herramientas | Objetivo |
|---|---|---|
| Nativa | Get-Counter, PerfMon, logman, SQL DMVs, SQL Error Log, Windows Event Log | Validar baseline antes de centralizar. |
| Centralizada | Zabbix Server, Zabbix Agent 2, template Windows | Supervisar hosts, servicios, disponibilidad y recursos. |
| SQL custom | UserParameters, PowerShell, DMVs, msdb, HADR views | Monitorizar salud SQL Server, jobs, backups, bloqueos y Always On. |
| Operativa | Items, triggers, Problems, Latest data, evidencias | Detectar, corregir y demostrar recuperación real. |

## Conclusión

La arquitectura final integra monitorización clásica y centralizada sin romper el hardening del LAB-03, manteniendo Windows Authentication y añadiendo checks DBA específicos sobre SQL Server Always On.
