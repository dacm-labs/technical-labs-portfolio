\# Zabbix Agents Windows / SQL Server



\## Objetivo



Integrar los nodos Windows/SQL Server del laboratorio en Zabbix mediante Zabbix Agent 2, permitiendo monitorización base de sistema operativo, servicios, red, discos, CPU, memoria y disponibilidad.



\## Nodos integrados



| Nodo | IP | Rol | Agente |

|---|---|---|---|

| ORN-SQL01 | 10.10.20.20 | SQL Server principal | Zabbix Agent 2 |

| ORN-SQL02 | 10.10.20.21 | SQL Server secundario | Zabbix Agent 2 |



\## Versión instalada



| Componente | Versión |

|---|---|

| Zabbix Agent 2 | 7.0.27 |

| Zabbix Server | 7.0.27 |



\## Método de instalación



Los nodos SQL no disponen de salida directa a Internet, por lo que se utiliza instalación offline.



El instalador MSI se descarga desde el host físico y se copia manualmente a cada servidor en:



```text

C:\\Temp\\zabbix\_agent2-7.0.27-windows-amd64-openssl.msi


## Alta en Zabbix

| Host | Grupo | Plantilla | Interfaz | Estado | Latest data |
|---|---|---|---|---|---|
| ORN-SQL01 | Windows servers | Windows by Zabbix agent | 10.10.20.20:10050 | ZBX verde | 180 métricas |
| ORN-SQL02 | Windows servers | Windows by Zabbix agent | 10.10.20.21:10050 | ZBX verde | 180 métricas |

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

## Snapshots

| Máquina | Snapshot |
|---|---|
| ORN-SQL01 | ORN-SQL01_ZABBIX_AGENT2_INSTALLED_BASELINE |
| ORN-SQL02 | ORN-SQL02_ZABBIX_AGENT2_INSTALLED_BASELINE |
| ORN-MON01 | ORN-MON01_ZABBIX_WINDOWS_HOSTS_ADDED_BASELINE |
