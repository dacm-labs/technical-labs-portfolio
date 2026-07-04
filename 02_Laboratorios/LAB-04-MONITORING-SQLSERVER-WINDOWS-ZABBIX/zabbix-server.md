# Zabbix Server

## Objetivo

Desplegar un servidor centralizado de monitorización para el laboratorio, orientado a supervisar infraestructura Windows Server, SQL Server, Always On Availability Groups y servicios críticos del entorno.

## Decisión técnica: Zabbix 7.0 LTS

Para este laboratorio se selecciona Zabbix 7.0 LTS priorizando estabilidad, soporte extendido y compatibilidad con un entorno técnico orientado a producción.

## Máquina desplegada

| Parámetro | Valor |
|---|---|
| Nombre VM | ORN-MON01 |
| Sistema operativo | Ubuntu Server 26.04 LTS |
| Usuario administrativo | adm-it |
| Rol | Servidor Zabbix |
| CPU | 2 vCPU |
| RAM | 2 GB |
| Disco | 50 GB |
| Root filesystem | 48 GB tras ampliación LVM |

## Red

| Interfaz | Uso | Configuración |
|---|---|---|
| ens33 | NAT / Internet / actualizaciones | DHCP |
| ens37 | Red interna / monitorización | 10.10.20.70/24 |

Configuración final:

| Parámetro | Valor |
|---|---|
| IP Zabbix Server | 10.10.20.70 |
| Red interna | 10.10.20.0/24 |
| DNS interno | 10.10.20.10 |
| Dominio de búsqueda | orion.lab |
| Gateway | NAT por ens33 |

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

| Parámetro | Valor |
|---|---|
| Motor | PostgreSQL |
| Base de datos | zabbix |
| Usuario | zabbix |
| Esquema | public |
| Tablas importadas | 203 |
| TLS DB | No habilitado, conexión local por localhost |

La contraseña de base de datos no se documenta ni se publica.

## Frontend web

El asistente web de Zabbix se completa desde ORN-DBA01 usando la IP definitiva del laboratorio:

```text
http://10.10.20.70/zabbix/
```

Parámetros principales del asistente:

| Parámetro | Valor |
|---|---|
| Database type | PostgreSQL |
| Database server | localhost |
| Database port | default |
| Database name | zabbix |
| Database user | zabbix |
| Database TLS encryption | false |
| Zabbix server name | ORION Zabbix LAB-04 |

## Validación final

La instalación queda validada con:

- Dashboard inicial cargado correctamente.
- Zabbix Server en estado `running`.
- Zabbix Server version `7.0.27`.
- Zabbix Frontend version `7.0.27`.
- Zabbix Agent version `7.0.27`.
- Contraseña por defecto del usuario `Admin` cambiada tras el primer inicio de sesión.

Servicios validados como activos:

- `zabbix-server`
- `zabbix-agent`
- `apache2`
- `postgresql`
- `php-fpm`

Puertos validados:

| Puerto | Uso |
|---:|---|
| 80 | Frontend web Apache/Zabbix |
| 10051 | Zabbix Server |
| 10050 | Zabbix Agent |

## Seguridad

- No se documentan contraseñas reales.
- Las capturas con cookies, tokens, sesiones o credenciales se excluyen o se recortan antes de publicarse.
- El servidor queda accesible en red interna de laboratorio.

## Conclusión

ORN-MON01 queda como servidor de monitorización centralizado del LAB-04, preparado para recolectar métricas Windows, checks SQL custom, items, triggers y evidencias operativas.
