# Validaciones LAB-04

## Estado actual

Se valida la instalación base de ORN-MON01 como servidor centralizado de monitorización con Zabbix Server 7.0 LTS.

## ORN-MON01

| Elemento | Resultado |
|---|---|
| Sistema operativo | Ubuntu Server 26.04 LTS |
| Hostname | orn-mon01 |
| Timezone | Europe/Madrid |
| NTP | Activo y sincronizado |
| SSH | Activo |
| open-vm-tools | Activo |
| Root filesystem | 48 GB |
| RAM | 2 GB asignados |
| Snapshot base Ubuntu | Creado |
| Snapshot Zabbix baseline | Creado |

## Red

| Interfaz | Uso | Estado |
|---|---|---|
| ens33 | NAT / Internet | DHCP activo |
| ens37 | Red ORION | 10.10.20.70/24 |

Validaciones realizadas:

- Ping a `10.10.20.10`: correcto.
- Resolución DNS de `ORN-DC01.orion.lab`: correcta.
- Ping a Internet `8.8.8.8`: correcto.
- Gateway por NAT mantenido en `ens33`.
- Red interna ORION configurada en `ens37`.

## Zabbix Server

| Componente | Resultado |
|---|---|
| Zabbix Server | active |
| Zabbix Agent | active |
| Apache | active |
| PostgreSQL | active |
| PHP-FPM | active |

Versiones validadas:

| Elemento | Versión |
|---|---|
| Zabbix Server | 7.0.27 |
| Zabbix Frontend | 7.0.27 |
| Zabbix Agent | 7.0.27 |
| Apache | 2.4.66 |

## Puertos

| Puerto | Servicio |
|---|---|
| 80 | Apache / Zabbix Frontend |
| 10050 | Zabbix Agent |
| 10051 | Zabbix Server |

## Frontend web

Acceso validado desde ORN-DBA01:

```text
http://10.10.20.70/zabbix/
```

## Monitorización completa del entorno Windows

| Host | IP | Rol | Estado Zabbix | Validación |
|---|---:|---|---|---|
| ORN-DC01 | 10.10.20.10 | Domain Controller / DNS | ZBX verde | OK |
| ORN-FSW01 | 10.10.20.40 | File Share Witness / Quorum | ZBX verde | OK |
| ORN-DBA01 | 10.10.20.30 | Estación administrativa DBA | ZBX verde | OK |
| ORN-SQL01 | 10.10.20.20 | SQL Server / Always On node | ZBX verde | OK |
| ORN-SQL02 | 10.10.20.21 | SQL Server / Always On node | ZBX verde | OK |
| ORN-MON01 | 10.10.20.70 | Zabbix Server | ZBX verde | OK |

Validaciones realizadas:

- Zabbix Agent 2 versión 7.0.27 instalado en nodos Windows.
- Servicio `Zabbix Agent 2` en estado `Running / Automatic`.
- Puerto TCP 10050 en escucha.
- Firewall Windows restringido a `10.10.20.70`.
- Conectividad hacia Zabbix Server `10.10.20.70:10051`.
- Validación desde ORN-MON01 mediante `nc` y `zabbix_get`.
- Hosts creados en Zabbix con plantilla `Windows by Zabbix agent`.
- Disponibilidad ZBX en verde para los nodos principales del laboratorio.

## Checks SQL custom

Validación desde ORN-MON01 contra los nodos SQL:

| Host | IP | agent.ping | agent.version | hostname | SQL ping | SQL service | SQL Agent | AG health | is_primary |
|---|---:|---:|---|---|---:|---:|---:|---:|---:|
| ORN-SQL01 | 10.10.20.20 | 1 | 7.0.27 | ORN-SQL01 | 1 | 1 | 1 | 1 | 1 |
| ORN-SQL02 | 10.10.20.21 | 1 | 7.0.27 | ORN-SQL02 | 1 | 1 | 1 | 1 | 0 |

Resultado:

- ORN-SQL01 devuelve métricas SQL custom correctamente.
- ORN-SQL02 devuelve métricas SQL custom correctamente.
- Always On queda healthy en ambos nodos.
- ORN-SQL01 queda validado como primary para `OrionLabDB`.
- ORN-SQL02 queda validado como secondary para `OrionLabDB`.

## Validación destacada ORN-FSW01

```bash
nc -vz 10.10.20.40 10050
zabbix_get -s 10.10.20.40 -p 10050 -k agent.ping
zabbix_get -s 10.10.20.40 -p 10050 -k agent.version
zabbix_get -s 10.10.20.40 -p 10050 -k system.hostname
```

Resultado:

```text
Connection to 10.10.20.40 10050 port [tcp/zabbix-agent] succeeded
1
7.0.27
ORN-FSW01
```

## Conclusión

El entorno de monitorización queda validado con Zabbix Server, Zabbix Frontend, agentes Windows y checks SQL custom operativos. Queda pendiente crear el template reutilizable, items, triggers y dashboard en Zabbix UI.
