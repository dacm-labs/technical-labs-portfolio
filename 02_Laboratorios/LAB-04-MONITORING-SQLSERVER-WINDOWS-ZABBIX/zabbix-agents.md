# Zabbix Agents Windows / SQL Server

## Objetivo

Integrar los nodos Windows/SQL Server del laboratorio en Zabbix mediante Zabbix Agent 2, permitiendo monitorización base de sistema operativo, servicios, red, discos, CPU, memoria y disponibilidad.

## Nodos integrados

| Nodo | IP | Rol | Agente |
|---|---:|---|---|
| ORN-DC01 | 10.10.20.10 | Domain Controller / DNS | Zabbix Agent 2 |
| ORN-FSW01 | 10.10.20.40 | File Share Witness / Quorum | Zabbix Agent 2 |
| ORN-DBA01 | 10.10.20.30 | Estación administrativa DBA | Zabbix Agent 2 |
| ORN-SQL01 | 10.10.20.20 | SQL Server / Always On node | Zabbix Agent 2 |
| ORN-SQL02 | 10.10.20.21 | SQL Server / Always On node | Zabbix Agent 2 |

## Versión instalada

| Componente | Versión |
|---|---|
| Zabbix Agent 2 | 7.0.27 |
| Zabbix Server | 7.0.27 |

## Método de instalación

Los nodos SQL no disponen de salida directa a Internet, por lo que se utiliza instalación offline.

El instalador MSI se descarga desde el host físico y se copia manualmente a cada servidor en:

```text
C:\Temp\zabbix_agent2-7.0.27-windows-amd64-openssl.msi
```

## Alta en Zabbix

| Host | Grupo | Plantilla | Interfaz | Estado |
|---|---|---|---|---|
| ORN-DC01 | Windows servers | Windows by Zabbix agent | 10.10.20.10:10050 | ZBX verde |
| ORN-FSW01 | Windows servers | Windows by Zabbix agent | 10.10.20.40:10050 | ZBX verde |
| ORN-DBA01 | Windows servers | Windows by Zabbix agent | 10.10.20.30:10050 | ZBX verde |
| ORN-SQL01 | Windows servers | Windows by Zabbix agent | 10.10.20.20:10050 | ZBX verde |
| ORN-SQL02 | Windows servers | Windows by Zabbix agent | 10.10.20.21:10050 | ZBX verde |

## Validación desde ORN-MON01

Servidor Zabbix utilizado:

```text
10.10.20.70
```

Validación ORN-SQL01:

```bash
nc -vz 10.10.20.20 10050
zabbix_get -s 10.10.20.20 -p 10050 -k agent.ping
zabbix_get -s 10.10.20.20 -p 10050 -k agent.version
zabbix_get -s 10.10.20.20 -p 10050 -k system.hostname
```

Resultado:

```text
Connection succeeded
1
7.0.27
ORN-SQL01
```

Validación ORN-SQL02:

```bash
nc -vz 10.10.20.21 10050
zabbix_get -s 10.10.20.21 -p 10050 -k agent.ping
zabbix_get -s 10.10.20.21 -p 10050 -k agent.version
zabbix_get -s 10.10.20.21 -p 10050 -k system.hostname
```

Resultado:

```text
Connection succeeded
1
7.0.27
ORN-SQL02
```

## Estado operacional de servicio

| Host | Servicio | Cuenta de ejecución | Estado |
|---|---|---|---|
| ORN-SQL01 | Zabbix Agent 2 | LocalSystem | Running / Auto |
| ORN-SQL02 | Zabbix Agent 2 | ORION\svc_zbx_sqlmon | Running / Auto |

ORN-SQL01 se mantiene temporalmente en LocalSystem para priorizar estabilidad, ya que los checks SQL custom han sido validados correctamente desde ORN-MON01.

ORN-SQL02 queda ejecutando Zabbix Agent 2 con la cuenta de dominio dedicada `ORION\svc_zbx_sqlmon`.

## Snapshots

| Máquina | Snapshot |
|---|---|
| ORN-SQL01 | ORN-SQL01_ZABBIX_AGENT2_INSTALLED_BASELINE |
| ORN-SQL02 | ORN-SQL02_ZABBIX_AGENT2_INSTALLED_BASELINE |
| ORN-MON01 | ORN-MON01_ZABBIX_WINDOWS_HOSTS_ADDED_BASELINE |

## Conclusión

La monitorización base de Windows queda operativa en los nodos principales del laboratorio. Los nodos SQL quedan preparados para la monitorización SQL custom mediante UserParameters y scripts PowerShell.
