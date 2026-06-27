# Explicación técnica — LAB-00 AÉGIDA Case Study

## 1. Objetivo del documento

Este documento resume la explicación técnica del laboratorio **AÉGIDA**, orientada a presentar el proyecto como un caso de estudio profesional de ciberseguridad defensiva.

Su finalidad es explicar de forma clara:

- Qué problema aborda el laboratorio.
- Qué arquitectura se diseñó.
- Qué componentes se desplegaron.
- Qué decisiones técnicas se tomaron.
- Cómo se validó el funcionamiento.
- Qué limitaciones existen.
- Qué mejoras futuras se plantean.

No sustituye a la memoria técnica original, sino que resume sus puntos más relevantes en un formato adecuado para GitHub y portfolio profesional.

---

## 2. Resumen técnico del proyecto

AÉGIDA es un laboratorio virtualizado de ciberseguridad defensiva diseñado para simular una infraestructura segmentada, monitorizada y administrada bajo criterios de seguridad.

El entorno integra:

- pfSense como firewall central.
- Active Directory como sistema de identidad.
- DNS interno.
- PAW como estación privilegiada de administración.
- GPOs de control y hardening básico.
- DMZ con servicio web Nginx.
- SOC/SIEM basado en Wazuh.
- Entorno OT simulado con HMI/PLC.
- RED-KALI como red no confiable para pruebas controladas.
- TRANSIT-LAB como enlace hacia el host secundario.

El laboratorio se diseñó para comprobar que los flujos autorizados funcionaban correctamente y que los intentos no autorizados quedaban bloqueados, filtrados o contenidos.

---

## 3. Problema que aborda

El punto de partida del laboratorio es una necesidad habitual en infraestructuras modernas: evitar redes planas, accesos administrativos poco controlados y falta de visibilidad sobre eventos de seguridad.

Una arquitectura sin segmentación clara puede facilitar:

- Movimiento lateral.
- Exposición de servicios críticos.
- Uso indebido de credenciales privilegiadas.
- Falta de trazabilidad.
- Dificultad para investigar incidentes.
- Mezcla de servicios expuestos, administración e identidad.

AÉGIDA aborda este problema mediante una arquitectura defensiva por zonas, donde cada segmento tiene una función concreta y cada comunicación debe estar justificada.

---

## 4. Objetivo técnico principal

El objetivo técnico principal fue diseñar, desplegar y validar un laboratorio de ciberdefensa segmentada que integrase:

- Seguridad perimetral.
- Identidad centralizada.
- Administración segura.
- Monitorización SOC.
- Entorno OT simulado.
- Pruebas ofensivo-defensivas controladas.
- Documentación técnica y evidencias.

La arquitectura debía demostrar que los servicios autorizados podían operar y que los accesos no autorizados quedaban contenidos.

---

## 5. Diseño de arquitectura

La arquitectura se organiza por zonas de seguridad.

| Zona | Subred | Función |
|---|---:|---|
| WAN | 192.168.139.0/24 | Salida exterior mediante NAT de VMware |
| DMZ | 192.168.10.0/24 | Servicios expuestos o semi-expuestos |
| MGMT | 192.168.20.0/24 | Administración segura |
| TIER0 | 192.168.30.0/24 | Identidad, dominio y DNS |
| SOC | 192.168.40.0/24 | Monitorización y análisis |
| OT | 192.168.50.0/24 | Entorno industrial simulado |
| TRANSIT-LAB | 192.168.60.0/24 | Enlace hacia host secundario |
| RED-KALI | 192.168.70.0/24 | Red no confiable para pruebas controladas |

El diseño evita una red plana y obliga a que el tráfico entre zonas pase por el firewall central.

---

## 6. Firewall y segmentación

El firewall principal del laboratorio es:

```text
AEGIDA-PF-FW
```

Basado en:

```text
pfSense CE
```

Sus funciones principales son:

- Actuar como gateway de los segmentos internos.
- Filtrar tráfico entre zonas.
- Controlar accesos por origen, destino y puerto.
- Gestionar salida hacia WAN.
- Aplicar rutas estáticas.
- Registrar tráfico permitido y bloqueado.
- Contener tráfico procedente de RED-KALI.
- Mantener separadas DMZ, MGMT, TIER0, SOC, OT y RED-KALI.

La segmentación se apoya en reglas específicas. No se permite comunicación libre entre zonas; cada flujo debe tener una necesidad funcional.

---

## 7. Identidad y TIER0

El dominio del laboratorio es:

```text
aegida.local
```

El controlador de dominio es:

```text
AEGIDA-DC01 — 192.168.30.10
```

Funciones principales:

- Active Directory Domain Services.
- DNS interno.
- Resolución directa e inversa.
- Organización lógica mediante OUs.
- Grupos de seguridad.
- Cuentas administrativas separadas.
- Base para aplicar GPOs.
- Protección del ámbito Tier 0.

El segmento TIER0 se reserva para los activos críticos de identidad. Dentro del modelo lógico, AEGIDA-DC01 se considera un activo crítico y la administración privilegiada se separa del uso ordinario.

---

## 8. Administración segura mediante PAW

La estación privilegiada de administración es:

```text
AEGIDA-PAW01 — 192.168.20.10
```

Su función es actuar como punto autorizado de administración del laboratorio.

Desde la PAW se realizan tareas como:

- Administración de Active Directory.
- Gestión de DNS.
- Gestión de GPOs.
- Acceso a pfSense.
- Acceso a Wazuh.
- Administración SSH de sistemas Linux.
- Validaciones de red.
- Análisis de tráfico.
- Diagnóstico técnico.

Este diseño evita administrar activos críticos desde equipos no controlados y separa el plano de administración de redes no confiables como RED-KALI.

---

## 9. GPOs y hardening básico

Las GPOs aplicadas permiten convertir el diseño lógico de seguridad en controles efectivos dentro del dominio.

| GPO | Función |
|---|---|
| GPO-T0-LocalAdmins-PAW | Control de administración local en PAW |
| GPO-T0-Logon-PAW | Control de inicio de sesión en PAW |
| GPO-T0-Restriccion-Logon-Clientes | Restricción de cuentas Tier 0 en clientes no autorizados |
| GPO-T0-Logon-DC | Control de acceso al controlador de dominio |
| GPO-T0-Hardening-PAW | Endurecimiento básico de la estación administrativa |
| GPO-Baseline-Domain | Auditoría mínima del dominio |

Estas políticas refuerzan el modelo de administración segura, separan privilegios y limitan el uso de cuentas críticas.

---

## 10. DMZ

El servidor DMZ es:

```text
AEGIDA-SRV-DMZ01 — 192.168.10.10
```

Características:

- Ubuntu Server.
- Nginx.
- Servicio web controlado.
- Administración desde PAW.
- Monitorización mediante Wazuh.
- Uso como objetivo de pruebas controladas desde RED-KALI.

La DMZ representa una zona semi-expuesta, separada de TIER0, SOC, MGMT y OT. Sus comunicaciones se limitan mediante reglas de pfSense.

---

## 11. SOC con Wazuh

El nodo SOC del laboratorio es:

```text
AEGIDA-SOC-WAZUH01 — 192.168.40.10
```

Wazuh se utiliza como plataforma central de monitorización.

Funciones principales:

- Gestión de agentes.
- Monitorización de endpoints.
- Revisión de eventos.
- File Integrity Monitoring.
- Revisión de vulnerabilidades.
- Apoyo a respuesta ante incidentes.
- Generación de evidencias defensivas.

Agentes integrados:

| Agente | Segmento | Función |
|---|---|---|
| AEGIDA-SRV-DMZ01 | DMZ | Servidor web |
| AEGIDA-DC01 | TIER0 | Controlador de dominio |
| AEGIDA-PAW01 | MGMT | Estación administrativa |
| AEGIDA-OT-PLC01 | OT | PLC simulado |
| AEGIDA-OT-HMI01 | OT | HMI simulada |

Wazuh complementa a pfSense: el firewall contiene tráfico entre zonas y Wazuh aporta visibilidad sobre los endpoints monitorizados.

---

## 12. Entorno OT simulado

El entorno OT está compuesto por:

| Máquina | IP | Rol |
|---|---:|---|
| AEGIDA-OT-PLC01 | 192.168.50.20 | PLC simulado |
| AEGIDA-OT-HMI01 | 192.168.50.30 | HMI simulada |

Características:

- Red OT separada.
- Alojamiento en host secundario.
- Integración mediante TRANSIT-LAB.
- Ruta estática en pfSense.
- Administración controlada desde PAW.
- Monitorización mediante Wazuh.
- Servicios web Nginx para simular paneles de estado.
- Relación funcional HMI → PLC.

La red OT se alcanza mediante:

```text
192.168.50.0/24 vía 192.168.60.2
```

Esta decisión permite mantener el entorno OT separado físicamente, pero integrado lógicamente en la arquitectura de seguridad.

---

## 13. RED-KALI

La red atacante controlada es:

```text
RED-KALI — 192.168.70.0/24
```

Máquina principal:

```text
AEGIDA-RED-KALI01 — 192.168.70.50
```

Su función es validar controles defensivos desde una red no confiable.

Desde RED-KALI se comprueban:

- Bloqueos hacia TIER0/DC01.
- Bloqueos hacia SOC/Wazuh.
- Bloqueos hacia MGMT/PAW01.
- Bloqueos hacia OT/PLC-HMI.
- Acceso controlado a DMZ cuando existe una regla temporal de prueba.

RED-KALI no es una red administrativa ni una red interna confiable. Todo su tráfico debe atravesar pfSense.

---

## 14. Validaciones realizadas

Durante el proyecto se validaron distintos aspectos funcionales y defensivos.

| Área | Validación |
|---|---|
| Conectividad | Comunicación con gateways y flujos permitidos |
| DNS | Resolución interna y externa |
| pfSense | Reglas de permiso y bloqueo |
| Active Directory | Dominio, OUs, grupos y usuarios |
| PAW | Administración centralizada |
| GPOs | Restricciones y hardening básico |
| DMZ | Servicio web Nginx |
| Wazuh | Agentes activos y eventos |
| FIM | Detección de cambios en activos OT |
| OT | Comunicación HMI/PLC simulada |
| RED-KALI | Bloqueos hacia segmentos críticos |
| SOC | Procedimiento básico de respuesta |

---

## 15. Escenarios ofensivo-defensivos

Se definieron cinco escenarios principales de validación:

| Escenario | Objetivo |
|---|---|
| Reconocimiento web contra DMZ | Comprobar acceso controlado y visibilidad |
| Movimiento lateral hacia OT | Validar aislamiento del entorno industrial |
| Intento de acceso hacia TIER0/DC01 | Proteger identidad y dominio |
| Intento de acceso hacia SOC/Wazuh | Proteger la plataforma de monitorización |
| Intento de acceso hacia PAW01 | Proteger el plano de administración |

Estas pruebas se realizaron de forma controlada y dentro del laboratorio.

---

## 16. Incidencias y troubleshooting

Durante el despliegue aparecieron incidencias técnicas que se documentaron como parte del proceso.

| Incidencia | Enfoque de diagnóstico | Solución aplicada |
|---|---|---|
| Resolución DNS incompleta | Revisión de DNS, reenviadores y reglas | Ajuste de DNS y pfSense |
| Conectividad entre segmentos | Revisión de IP, gateway, rutas y firewall | Corrección de reglas y rutas |
| Integración OT remota | Revisión de TRANSIT-LAB y host secundario | Ruta estática vía 192.168.60.2 |
| Procesos suspendidos en Ubuntu | Diagnóstico de servicios y sistema | Corrección y validación |
| Reglas temporales residuales | Revisión de mínimo privilegio | Retirada de reglas innecesarias |
| Replanteamiento de VMs | Reconstrucción del laboratorio | Mejora de coherencia y documentación |

El diagnóstico se realizó por capas: configuración IP, gateway, rutas, DNS, firewall, servicios, logs y pruebas desde distintos puntos del laboratorio.

---

## 17. Limitaciones del laboratorio

AÉGIDA fue diseñado como laboratorio virtualizado y no como implantación productiva completa.

Limitaciones principales:

- No dispone de alta disponibilidad real en firewall.
- No dispone de segundo controlador de dominio.
- Wazuh se despliega en modalidad all-in-one.
- El entorno OT es simulado, no físico.
- No se implementa EDR corporativo.
- No se usan certificados públicos.
- Las pruebas ofensivo-defensivas son controladas y limitadas.
- Las copias de seguridad y recuperación avanzada quedan como mejora futura.

Estas limitaciones son coherentes con un laboratorio de portfolio y permiten plantear una hoja de ruta de evolución.

---

## 18. Mejoras futuras

Posibles mejoras:

- Wazuh distribuido.
- Wazuh Active Response.
- Alertas por correo o mensajería.
- Integración con Nagios o Checkmk.
- Alta disponibilidad de pfSense.
- Segundo controlador de dominio.
- Backups automatizados.
- Hardening avanzado de Windows y Linux.
- Mayor realismo OT con Modbus TCP.
- Integración parcial con cloud.
- Automatización con scripts o playbooks.

---

## 19. Valor técnico del proyecto

AÉGIDA demuestra competencias prácticas en:

- Diseño de arquitecturas segmentadas.
- Administración de sistemas Windows y Linux.
- Active Directory y DNS.
- GPOs y hardening básico.
- Seguridad perimetral con pfSense.
- Administración segura mediante PAW.
- Monitorización SOC con Wazuh.
- Integración de agentes y FIM.
- Simulación de entorno OT.
- Validación defensiva con Kali Linux.
- Troubleshooting técnico.
- Documentación profesional.

El valor principal está en la integración: cada componente cumple una función dentro de una arquitectura defensiva coherente.

---

## 20. Conclusión técnica

AÉGIDA demuestra el diseño e implementación de una arquitectura defensiva segmentada, monitorizada y validada mediante pruebas controladas.

El laboratorio integra firewall, identidad, administración segura, DMZ, SOC, OT simulado y red de validación ofensivo-defensiva. Su enfoque principal es defensivo: reducir superficie de exposición, controlar comunicaciones, proteger activos críticos, mejorar visibilidad y documentar evidencias.

Como caso de estudio, AÉGIDA permite mostrar una visión completa de infraestructura segura, desde el diseño inicial hasta la validación final y las mejoras futuras.
