# Zabbix Server



## Objetivo



Desplegar un servidor centralizado de monitorización para el laboratorio ORION, orientado a supervisar infraestructura Windows Server, SQL Server, Always On Availability Groups y servicios críticos del entorno.



El servidor de monitorización se implementa sobre Ubuntu Server y utiliza Zabbix como plataforma principal de observabilidad.



## Decisión técnica: Zabbix 7.0 LTS



Para este laboratorio se selecciona Zabbix 7.0 LTS en lugar de una versión más reciente no LTS, priorizando estabilidad, soporte extendido y compatibilidad en un entorno técnico orientado a producción.



La elección de una rama LTS reduce riesgos durante la implantación, facilita la documentación, mejora la mantenibilidad del laboratorio y permite construir una base sólida antes de añadir agentes, plantillas, triggers y dashboards personalizados.



## Máquina desplegada



| Parámetro | Valor |

|---|---|

| Nombre VM | ORN-MON01 |

| Sistema operativo | Ubuntu Server 26.04 LTS |

| Usuario administrativo | adm-it |

| Rol | Servidor Zabbix |

| Plataforma | VMware Workstation |

| CPU | 2 vCPU |

| RAM | 2 GB |

| Disco | 50 GB |

| Root filesystem | 48 GB tras ampliación LVM |



## Red



ORN-MON01 queda configurado con doble interfaz de red:



| Interfaz | Uso | Configuración |

|---|---|---|

| ens33 | NAT / Internet / actualizaciones | DHCP |

| ens37 | Red ORION / monitorización interna | 10.10.20.70/24 |



Configuración final de red:



| Parámetro | Valor |

|---|---|

| IP Zabbix Server | 10.10.20.70 |

| Red ORION | 10.10.20.0/24 |

| DNS interno | 10.10.20.10 |

| Dominio búsqueda | orion.lab |

| Gateway | NAT por ens33 |



Validaciones realizadas:



- Comunicación con ORN-DC01 mediante IP `10.10.20.10`.

- Resolución DNS de `ORN-DC01.orion.lab`.

- Salida a Internet mediante NAT.

- Acceso web interno desde ORN-DBA01 a `http://10.10.20.70/zabbix/`.



## Stack instalado



| Componente | Estado |

|---|---|

| Zabbix Server | Instalado y activo |

| Zabbix Frontend | Instalado y operativo |

| Zabbix Agent local | Instalado y activo |

| PostgreSQL | Instalado y activo |

| Apache | Instalado y activo |

| PHP-FPM | Instalado y activo |

| open-vm-tools | Instalado y activo |

| SSH | Instalado y activo |



## Base de datos



Se crea una base de datos PostgreSQL dedicada para Zabbix.



| Parámetro | Valor |

|---|---|

| Motor | PostgreSQL |

| Base de datos | zabbix |

| Usuario | zabbix |

| Esquema | public |

| Tablas importadas | 203 |

| TLS DB | No habilitado, conexión local por localhost |



La contraseña de base de datos no se documenta ni se publica.



## Instalación del frontend



El asistente web de Zabbix se completa desde ORN-DBA01 usando la IP definitiva del laboratorio:



```text

http://10.10.20.70/zabbix/
