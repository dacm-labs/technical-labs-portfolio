# Valor profesional — LAB-00 AÉGIDA Case Study

## Objetivo

Este documento resume el valor profesional del laboratorio **AÉGIDA** como caso de estudio dentro del portfolio técnico.

El objetivo es explicar qué competencias demuestra, qué áreas profesionales cubre y por qué puede ser relevante para perfiles de sistemas, redes, infraestructura, seguridad defensiva, SOC y cloud.

## Valor general

AÉGIDA demuestra capacidad para diseñar, desplegar, validar y documentar una arquitectura defensiva segmentada.

El valor principal no está en instalar herramientas aisladas, sino en integrarlas dentro de una arquitectura coherente:

- Segmentación de red.
- Seguridad perimetral.
- Identidad centralizada.
- Administración segura.
- Monitorización.
- Entorno OT simulado.
- Análisis de evidencias.
- Troubleshooting.
- Documentación técnica.

## Competencias técnicas demostradas

| Área | Competencias demostradas |
|---|---|
| Redes | Segmentación, subredes, gateways, rutas, NAT y control de tráfico. |
| Seguridad perimetral | pfSense, reglas, logs y aislamiento entre zonas. |
| Sistemas Microsoft | Windows Server, Active Directory, DNS y GPOs. |
| Administración segura | PAW, separación de privilegios y modelo Tier 0. |
| Linux | Ubuntu Server, SSH, Nginx, servicios y logs. |
| Monitorización | Wazuh, agentes, eventos y File Integrity Monitoring. |
| OT simulado | HMI, PLC, aislamiento de red y monitorización defensiva. |
| Troubleshooting | Diagnóstico por capas: IP, DNS, rutas, firewall, servicios y logs. |
| Documentación | Markdown, GitHub, evidencias, diagramas y explicación técnica. |

## Áreas profesionales relacionadas

| Área profesional | Relación con AÉGIDA |
|---|---|
| Administración de sistemas | Despliegue y gestión de Windows Server, Windows 11 y Ubuntu Server. |
| Redes | Diseño de subredes, gateways, rutas y segmentación. |
| Seguridad defensiva | Firewall, segmentación, monitorización y control de accesos. |
| SOC / Blue Team | Wazuh, eventos, FIM y análisis de evidencias. |
| Active Directory | Dominio, DNS, OUs, grupos, usuarios y GPOs. |
| Infraestructura | Integración de servicios, redes y máquinas virtuales. |
| Seguridad OT | Simulación de entorno HMI/PLC protegido y monitorizado. |
| Cloud / híbrido | Base conceptual para evolucionar hacia entornos híbridos. |

## Puntos fuertes

- Diseño completo de una arquitectura defensiva segmentada.
- Separación clara entre DMZ, MGMT, TIER0, SOC, OT y red de validación.
- pfSense como firewall central y punto de control del tráfico.
- Active Directory como núcleo de identidad.
- PAW como estación privilegiada de administración.
- GPOs para control de acceso y hardening básico.
- Wazuh como plataforma de monitorización.
- DMZ con servicio web Nginx.
- Entorno OT simulado con HMI y PLC.
- Documentación de incidencias, pruebas y mejoras futuras.
- Conversión de un proyecto académico en un caso de estudio profesional.

## Valor por componente

| Componente | Valor profesional |
|---|---|
| pfSense | Conocimientos de firewall, routing, segmentación y control de tráfico. |
| Active Directory | Administración de identidad, DNS, OUs, grupos y usuarios. |
| PAW | Enfoque de administración segura y protección del plano administrativo. |
| GPOs | Capacidad para aplicar restricciones y políticas de seguridad. |
| DMZ | Separación de servicios expuestos y control de acceso. |
| Wazuh | Monitorización, agentes, eventos y FIM. |
| OT simulado | Comprensión básica de segmentación IT/OT. |
| Documentación | Capacidad de explicar, evidenciar y defender técnicamente un proyecto. |

## Roles profesionales relacionados

AÉGIDA puede reforzar candidaturas orientadas a perfiles como:

- Administrador de sistemas.
- Técnico de infraestructura.
- Técnico de redes.
- Administrador Windows/Linux.
- Administrador Active Directory junior.
- Técnico de seguridad defensiva.
- SOC Analyst Junior.
- Blue Team Junior.
- Técnico de monitorización.
- Técnico de soporte avanzado.
- Técnico cloud/security en evolución.

## Relación con el portfolio técnico

AÉGIDA funciona como **LAB-00** y actúa como caso de estudio fundacional del portfolio.

Su papel es demostrar una base sólida de infraestructura defensiva sobre la que se apoyan otros laboratorios especializados:

| Laboratorio | Línea técnica |
|---|---|
| LAB-00 — AÉGIDA Case Study | Segmentación, AD, pfSense, Wazuh y OT simulado. |
| LAB-01 — SQL Server DBA | Administración SQL Server, backups, recovery, seguridad, auditoría y monitorización. |
| LAB-02 — SQL Server Always On | Alta disponibilidad, WSFC, Availability Groups, listener, failover y continuidad de servicio. |

De este modo, AÉGIDA no queda como un proyecto aislado, sino como la primera pieza de una línea de portfolio más amplia, orientada a sistemas, bases de datos, seguridad defensiva y operación IT.

## Limitaciones reconocidas

El laboratorio tiene limitaciones razonables al estar desarrollado en entorno virtualizado y con recursos propios:

- No dispone de alta disponibilidad real.
- No incluye segundo controlador de dominio.
- Wazuh está desplegado en modalidad all-in-one.
- El entorno OT es simulado.
- No se usan certificados públicos.
- La recuperación avanzada queda planteada como mejora futura.

Reconocer estas limitaciones aporta realismo y permite plantear una evolución técnica clara.

## Conclusión

AÉGIDA aporta valor profesional porque demuestra una visión completa de infraestructura defensiva.

El laboratorio combina sistemas, redes, identidad, firewall, administración segura, monitorización, OT simulado, validación técnica y documentación.

Dentro del portfolio técnico, AÉGIDA actúa como laboratorio base para demostrar competencias reales y como punto de partida para laboratorios más especializados.

