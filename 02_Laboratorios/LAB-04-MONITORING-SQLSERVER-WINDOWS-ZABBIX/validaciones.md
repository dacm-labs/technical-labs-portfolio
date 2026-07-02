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
