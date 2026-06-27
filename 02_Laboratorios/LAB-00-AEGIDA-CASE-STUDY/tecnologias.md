# Tecnologías — LAB-00 AÉGIDA Case Study

## 1. Resumen tecnológico

AÉGIDA integra tecnologías de virtualización, redes, firewall, identidad, administración segura, monitorización SOC, sistemas Linux/Windows, servicios web, entorno OT simulado y herramientas de validación ofensivo-defensiva.

El objetivo del stack tecnológico no es únicamente desplegar servicios aislados, sino construir una arquitectura defensiva completa donde cada herramienta cumple una función concreta dentro del laboratorio.

---

## 2. Mapa general de tecnologías

| Área | Tecnología | Función dentro de AÉGIDA |
|---|---|---|
| Virtualización | VMware Workstation | Plataforma base del laboratorio |
| Firewall | pfSense CE | Segmentación, routing y filtrado |
| Identidad | Windows Server 2022 | Controlador de dominio |
| Directorio | Active Directory Domain Services | Gestión centralizada de identidades |
| DNS | Microsoft DNS Server | Resolución interna y reenviadores |
| Administración segura | Windows 11 Pro / PAW | Puesto privilegiado de administración |
| Políticas | GPOs | Restricciones, hardening y auditoría |
| SOC/SIEM | Wazuh | Monitorización, agentes, FIM y eventos |
| Linux Server | Ubuntu Server | Servidores DMZ, SOC y OT |
| Web | Nginx | Servicios web en DMZ y OT |
| Red atacante controlada | Kali Linux | Pruebas ofensivo-defensivas |
| Diagnóstico | PowerShell | Validación, red y administración |
| Acceso remoto | MobaXterm | SSH hacia sistemas Linux/pfSense |
| Análisis de red | Wireshark | Captura y revisión de tráfico |
| Validación ofensiva | curl / nc / Nmap / Nikto | Pruebas controladas de conectividad y exposición |
| Documentación | Markdown | Documentación profesional para GitHub |

---

## 3. Virtualización

### VMware Workstation

VMware Workstation se utiliza como plataforma principal de virtualización del laboratorio.

Funciones principales:

- Creación y ejecución de máquinas virtuales.
- Definición de redes virtuales separadas.
- Asignación de adaptadores por segmento.
- Integración de pfSense como firewall central.
- Simulación de una arquitectura corporativa/industrial completa.
- Separación entre host principal y host secundario para el entorno OT.

Redes utilizadas:

| VMnet | Zona | Tipo | Subred |
|---|---|---|---:|
| VMnet8 | WAN | NAT | 192.168.139.0/24 |
| VMnet2 | DMZ | Host-only | 192.168.10.0/24 |
| VMnet3 | MGMT | Host-only | 192.168.20.0/24 |
| VMnet4 | TIER0 | Host-only | 192.168.30.0/24 |
| VMnet5 | SOC | Host-only | 192.168.40.0/24 |
| VMnet6 | OT | Host-only en host secundario | 192.168.50.0/24 |
| VMnet7 | RED-KALI | Host-only / personalizada | 192.168.70.0/24 |
| VMnet0 | TRANSIT-LAB | Bridge dedicado | 192.168.60.0/24 |

---

## 4. Firewall y segmentación

### pfSense CE

pfSense CE es el núcleo de seguridad perimetral del laboratorio.

Máquina asociada:

```text
AEGIDA-PF-FW
```

Funciones principales:

- Firewall central.
- Gateway de las redes internas.
- Filtrado entre segmentos.
- Control por origen, destino y puerto.
- NAT hacia WAN.
- Rutas estáticas.
- Integración de RED-KALI como red no confiable.
- Control del tránsito hacia el entorno OT remoto.
- Registro de tráfico permitido y bloqueado.

Interfaces principales:

| Zona | IP pfSense |
|---|---:|
| DMZ | 192.168.10.1 |
| MGMT | 192.168.20.1 |
| TIER0 | 192.168.30.1 |
| SOC | 192.168.40.1 |
| TRANSIT-LAB | 192.168.60.1 |
| RED-KALI | 192.168.70.1 |

La red OT se alcanza mediante ruta estática hacia `192.168.50.0/24` vía `192.168.60.2`.

---

## 5. Identidad y servicios Microsoft

### Windows Server 2022

Windows Server 2022 se utiliza como sistema base para el controlador de dominio del laboratorio.

Máquina asociada:

```text
AEGIDA-DC01 — 192.168.30.10
```

Funciones:

- Controlador de dominio.
- Servicio DNS interno.
- Resolución directa e inversa.
- Reenviadores DNS.
- Base del dominio `aegida.local`.
- Servicio crítico dentro del segmento TIER0.

---

### Active Directory Domain Services

Active Directory proporciona el modelo de identidad centralizada del laboratorio.

Funciones aplicadas:

- Dominio `aegida.local`.
- Estructura lógica mediante OUs.
- Cuentas administrativas separadas.
- Usuarios estándar.
- Cuentas de prueba.
- Grupos de seguridad.
- Organización basada en criticidad.
- Modelo inspirado en Tier 0.

Elementos principales:

| Elemento | Función |
|---|---|
| Tier0 | Rama lógica de activos críticos |
| Admins-T0 | Cuentas administrativas privilegiadas |
| Devices-T0 | Equipos de administración segura |
| Groups-T0 | Grupos críticos del dominio |
| Servers | Servidores por función |
| Users-OU | Usuarios administrativos, estándar y test |
| Groups | Grupos generales del dominio |

---

### DNS Server

El servicio DNS está integrado en AEGIDA-DC01.

Funciones principales:

- Resolución del dominio interno.
- Resolución de nombres de servidores.
- Resolución inversa mediante PTR.
- Reenviadores externos.
- Soporte para integración de clientes y servidores en el dominio.

---

## 6. Administración segura

### PAW — Privileged Access Workstation

La PAW es la estación privilegiada de administración del laboratorio.

Máquina asociada:

```text
AEGIDA-PAW01 — 192.168.20.10
```

Sistema:

```text
Windows 11 Pro
```

Funciones:

- Administración del dominio.
- Gestión de Active Directory.
- Gestión de DNS.
- Gestión de GPOs.
- Acceso a pfSense.
- Acceso a Wazuh.
- Acceso SSH a servidores Linux.
- Diagnóstico de conectividad.
- Análisis de red.
- Punto autorizado para tareas administrativas.

Herramientas instaladas en PAW:

| Herramienta | Uso |
|---|---|
| RSAT | Administración remota de servicios Microsoft |
| MobaXterm | SSH hacia Linux y pfSense |
| Wireshark | Análisis de tráfico |
| PowerShell 7 | Administración y validación |
| 7-Zip | Gestión de ficheros |
| Notepad++ | Edición técnica de texto y logs |

---

## 7. GPOs y hardening

Las GPOs se utilizan para convertir el diseño lógico de seguridad en restricciones aplicadas dentro del dominio.

GPOs principales:

| GPO | Función |
|---|---|
| GPO-T0-LocalAdmins-PAW | Administra miembros locales en PAW |
| GPO-T0-Logon-PAW | Controla inicio de sesión en PAW |
| GPO-T0-Restriccion-Logon-Clientes | Impide uso de cuentas Tier 0 en clientes no autorizados |
| GPO-T0-Logon-DC | Controla acceso al controlador de dominio |
| GPO-T0-Hardening-PAW | Endurecimiento básico de la PAW |
| GPO-Baseline-Domain | Auditoría mínima del dominio |

Medidas aplicadas:

- Control de administración local.
- Restricción de inicio de sesión.
- Separación de cuentas privilegiadas.
- Hardening básico de estación administrativa.
- Auditoría mínima.
- Refuerzo del modelo Tier 0.

---

## 8. Sistemas Linux

### Ubuntu Server

Ubuntu Server se utiliza como sistema base para varios servidores del laboratorio.

Máquinas asociadas:

| Máquina | Función |
|---|---|
| AEGIDA-SRV-DMZ01 | Servidor web en DMZ |
| AEGIDA-SOC-WAZUH01 | Nodo Wazuh |
| AEGIDA-OT-PLC01 | PLC simulado |
| AEGIDA-OT-HMI01 | HMI simulada |

Uso dentro del laboratorio:

- Servicios ligeros.
- Administración por SSH.
- Instalación de Nginx.
- Integración con Wazuh Agent.
- Simulación de activos OT.
- Validaciones de conectividad y seguridad.

---

## 9. Servicios web

### Nginx

Nginx se utiliza como servidor web ligero en la DMZ y en los activos OT simulados.

Máquinas donde se utiliza:

| Máquina | Uso de Nginx |
|---|---|
| AEGIDA-SRV-DMZ01 | Servicio web de DMZ |
| AEGIDA-OT-PLC01 | Página de estado del PLC simulado |
| AEGIDA-OT-HMI01 | Panel web HMI simulado |

Funciones:

- Publicación web controlada.
- Simulación de servicio expuesto en DMZ.
- Simulación de paneles OT.
- Generación de evidencias mediante logs.
- Pruebas de acceso HTTP.
- Validaciones con curl, nc, navegador y herramientas de análisis.

---

## 10. SOC / SIEM

### Wazuh

Wazuh se utiliza como plataforma SOC/SIEM del laboratorio.

Máquina asociada:

```text
AEGIDA-SOC-WAZUH01 — 192.168.40.10
```

Funciones:

- Monitorización de endpoints.
- Gestión de agentes.
- Revisión de eventos.
- Detección de cambios mediante FIM.
- Inventario básico de activos.
- Revisión de vulnerabilidades.
- Mapeo con MITRE ATT&CK.
- Apoyo a respuesta ante incidentes.
- Evidencias de seguridad durante las pruebas.

Agentes desplegados:

| Agente | Segmento | Función |
|---|---|---|
| AEGIDA-SRV-DMZ01 | DMZ | Monitorización del servidor web |
| AEGIDA-DC01 | TIER0 | Monitorización del controlador de dominio |
| AEGIDA-PAW01 | MGMT | Monitorización de estación administrativa |
| AEGIDA-OT-PLC01 | OT | Monitorización de PLC simulado |
| AEGIDA-OT-HMI01 | OT | Monitorización de HMI simulada |

---

## 11. File Integrity Monitoring

FIM se utiliza para detectar modificaciones controladas en ficheros monitorizados.

Aplicación en AÉGIDA:

- Monitorización de rutas web en activos OT.
- Detección de cambios en ficheros `index.html`.
- Validación de alertas tras modificaciones controladas.
- Evidencias de integridad en PLC01 y HMI01.

Valor defensivo:

- Detecta cambios no previstos.
- Aporta visibilidad sobre activos monitorizados.
- Complementa la segmentación de pfSense.
- Refuerza el enfoque SOC del laboratorio.

---

## 12. Entorno OT simulado

El entorno OT se compone de dos máquinas Linux que representan una relación básica HMI/PLC.

| Máquina | IP | Función |
|---|---:|---|
| AEGIDA-OT-PLC01 | 192.168.50.20 | PLC simulado |
| AEGIDA-OT-HMI01 | 192.168.50.30 | HMI simulada |

Tecnologías usadas:

- Ubuntu Server.
- Nginx.
- SSH.
- Wazuh Agent.
- FIM.
- Routing mediante host secundario.
- Integración por TRANSIT-LAB.

Características:

- Segmento OT separado.
- Acceso controlado desde PAW.
- Monitorización desde SOC.
- Aislamiento frente a RED-KALI.
- Relación funcional HMI → PLC mediante acceso web.

---

## 13. Red atacante controlada

### Kali Linux

Kali Linux se utiliza como origen de pruebas ofensivo-defensivas controladas.

Máquina asociada:

```text
AEGIDA-RED-KALI01 — 192.168.70.50
```

Red:

```text
RED-KALI — 192.168.70.0/24
```

Uso:

- Validación de reglas de firewall.
- Pruebas de conectividad.
- Intentos controlados hacia DMZ.
- Validación de bloqueos hacia TIER0, SOC, MGMT y OT.
- Simulación de red no confiable.
- Generación de evidencias de contención.

Herramientas utilizadas:

| Herramienta | Uso |
|---|---|
| curl | Pruebas HTTP |
| nc | Pruebas TCP por puerto |
| Nmap | Reconocimiento controlado |
| Nikto | Análisis web controlado |
| ping | Pruebas básicas ICMP cuando procede |

---

## 14. Herramientas de administración y diagnóstico

| Herramienta | Sistema | Uso |
|---|---|---|
| PowerShell | Windows | Validación de red, DNS, puertos y administración |
| Test-NetConnection | Windows | Comprobación TCP |
| nslookup | Windows/Linux | Resolución DNS |
| ipconfig / ip / route | Windows/Linux | Configuración de red |
| MobaXterm | Windows | Acceso SSH |
| Wireshark | Windows | Captura y análisis de tráfico |
| pfSense logs | pfSense | Evidencias de bloqueo/permiso |
| Wazuh Dashboard | Linux/Wazuh | Revisión SOC |
| Nginx logs | Linux | Evidencias de acceso web |
| journalctl / systemctl | Linux | Estado de servicios |

---

## 15. Documentación técnica

La documentación del laboratorio se realiza en Markdown para integrarla en GitHub.

Archivos principales:

| Archivo | Propósito |
|---|---|
| README.md | Presentación profesional del caso de estudio |
| arquitectura.md | Diseño de red, zonas, máquinas y flujos |
| tecnologias.md | Stack tecnológico utilizado |
| evidencias.md | Pruebas y validaciones |
| defensa.md | Guía de explicación para entrevistas |
| resumen-cv.md | Resumen profesional para CV/LinkedIn |
| lecciones-aprendidas.md | Incidencias, limitaciones y mejoras |

---

## 16. Tecnologías pendientes de versión exacta

Algunas versiones concretas deben confirmarse antes de publicarse como dato cerrado.

| Tecnología | Estado |
|---|---|
| pfSense CE | Confirmada en el proyecto como 2.8.1 |
| VMware Workstation | Pendiente de confirmar versión exacta |
| Wazuh | Pendiente de confirmar versión exacta |
| Ubuntu Server | Pendiente de confirmar versión exacta |
| Kali Linux | Pendiente de confirmar versión exacta |
| Nginx | Pendiente de confirmar versión exacta |
| Windows Server 2022 | Confirmado |
| Windows 11 Pro | Confirmado |

---

## 17. Valor profesional del stack

El stack tecnológico de AÉGIDA permite demostrar competencias prácticas en:

- Diseño de redes segmentadas.
- Administración de firewalls.
- Gestión de identidades con Active Directory.
- Administración segura mediante PAW.
- Aplicación de GPOs.
- Administración Windows y Linux.
- Despliegue de servicios web.
- Monitorización SOC/SIEM.
- Integración de agentes Wazuh.
- Detección de cambios mediante FIM.
- Simulación de entorno OT.
- Validación defensiva con Kali.
- Troubleshooting de red y servicios.
- Documentación profesional orientada a portfolio.

---

## 18. Conclusión

Las tecnologías utilizadas en AÉGIDA forman un stack coherente para un laboratorio de ciberseguridad defensiva orientado a infraestructura, SOC, administración de sistemas y segmentación de red.

El valor del laboratorio no está solo en las herramientas empleadas, sino en su integración dentro de una arquitectura funcional: pfSense controla, Active Directory identifica, PAW administra, Wazuh monitoriza, DMZ expone servicios controlados, OT simula activos industriales y Kali valida la eficacia defensiva del diseño.
