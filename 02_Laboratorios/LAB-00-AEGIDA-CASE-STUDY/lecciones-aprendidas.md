# Lecciones aprendidas — LAB-00 AÉGIDA Case Study

## 1. Objetivo del documento

Este documento recoge las principales lecciones aprendidas durante el diseño, despliegue, validación y documentación del laboratorio **AÉGIDA**.

El objetivo es mostrar el aprendizaje técnico obtenido, las incidencias relevantes, las decisiones tomadas y las mejoras futuras identificadas durante el desarrollo del caso de estudio.

---

## 2. Aprendizaje principal

La principal lección de AÉGIDA es que una arquitectura defensiva no depende de una única herramienta, sino de la integración coherente de varias capas:

- Red.
- Firewall.
- Identidad.
- Administración.
- Monitorización.
- Servicios.
- Evidencias.
- Procedimientos.
- Documentación.

pfSense, Active Directory, PAW, Wazuh, DMZ, OT y Kali tienen valor individual, pero el valor real aparece cuando todos esos componentes trabajan dentro de una arquitectura segmentada, controlada y documentada.

---

## 3. Importancia de la segmentación

Una de las lecciones más importantes fue comprobar que la segmentación debe diseñarse desde el principio.

Separar DMZ, MGMT, TIER0, SOC, OT y RED-KALI permite:

- Reducir exposición.
- Evitar movimiento lateral.
- Proteger activos críticos.
- Controlar flujos por origen, destino y puerto.
- Analizar mejor los eventos.
- Documentar reglas y decisiones.
- Diferenciar tráfico autorizado de tráfico no autorizado.

Una red plana habría simplificado el despliegue, pero habría reducido drásticamente el valor defensivo del laboratorio.

---

## 4. pfSense como punto central de control

pfSense fue uno de los componentes más importantes del laboratorio.

Lecciones aprendidas:

- El orden de reglas importa.
- Los aliases ayudan a mantener claridad.
- Las reglas temporales deben retirarse después de las pruebas.
- Los logs del firewall son fundamentales para validar bloqueos.
- El tráfico bloqueado en firewall puede no generar eventos en el endpoint.
- Las rutas estáticas deben documentarse con precisión.
- El firewall no solo permite o bloquea: también ayuda a entender el diseño.

Una conclusión importante fue que pfSense actúa como primera capa de contención. Si bloquea correctamente un intento antes de llegar al destino, es normal que herramientas como Wazuh no vean actividad directa en el agente afectado.

---

## 5. Active Directory y Tier 0

El diseño del dominio permitió entender la importancia de separar activos críticos, cuentas privilegiadas y administración ordinaria.

Lecciones aprendidas:

- El controlador de dominio debe tratarse como activo crítico.
- Las cuentas privilegiadas no deben usarse para tareas normales.
- La estructura de OUs facilita aplicar políticas de forma ordenada.
- Los grupos de seguridad permiten escalar permisos sin depender de usuarios individuales.
- El modelo Tier 0 aporta claridad al diseño defensivo.
- DNS es un servicio crítico para el funcionamiento del dominio.

Una administración desordenada puede funcionar al principio, pero complica el mantenimiento y aumenta el riesgo. Organizar el dominio desde el inicio evita muchos problemas posteriores.

---

## 6. PAW y administración segura

La PAW demostró ser una pieza clave para separar la administración legítima de accesos no confiables.

Lecciones aprendidas:

- La administración debe realizarse desde un origen controlado.
- RSAT permite gestionar servicios Microsoft sin trabajar directamente sobre el servidor.
- MobaXterm centraliza conexiones SSH hacia sistemas Linux.
- Wireshark y PowerShell son herramientas muy útiles para validar red y tráfico.
- Una PAW no debe convertirse en un equipo de uso general.
- La administración segura requiere tanto diseño como disciplina operativa.

AEGIDA-PAW01 permitió centralizar tareas administrativas y justificar reglas específicas en pfSense.

---

## 7. GPOs y hardening

Las GPOs ayudaron a convertir el diseño lógico en restricciones reales.

Lecciones aprendidas:

- Una estructura de OUs clara facilita aplicar GPOs.
- Las restricciones de inicio de sesión son importantes para proteger cuentas privilegiadas.
- El hardening debe aplicarse de forma gradual y validada.
- Una política demasiado agresiva puede romper operativa.
- La auditoría mínima es necesaria para ganar trazabilidad.
- Las GPOs deben documentarse con nombre, objetivo y alcance.

El objetivo no fue aplicar una línea base empresarial completa, sino demostrar controles coherentes con el laboratorio.

---

## 8. Wazuh y visibilidad defensiva

Wazuh aportó la capa de visibilidad del laboratorio.

Lecciones aprendidas:

- Un firewall bloquea tráfico, pero el SOC aporta contexto.
- Los agentes permiten observar endpoints concretos.
- FIM es útil para detectar cambios en ficheros sensibles.
- La monitorización debe planificarse por activo y criticidad.
- No todo evento relevante aparece en todos los sistemas.
- La ausencia de evento también puede ser información si el tráfico fue bloqueado antes.
- Wazuh all-in-one es suficiente para laboratorio, pero limitado frente a un entorno real.

La integración de agentes en DMZ, DC01, PAW y OT permitió demostrar monitorización transversal.

---

## 9. Entorno OT simulado

El entorno OT permitió añadir una capa diferencial al laboratorio.

Lecciones aprendidas:

- OT debe tratarse como segmento separado.
- La comunicación hacia OT debe estar muy controlada.
- Una HMI y un PLC simulados permiten representar relaciones industriales básicas.
- El acceso administrativo a OT debe proceder de un origen autorizado.
- Monitorizar OT con Wazuh aporta visibilidad adicional.
- Separar OT en un host secundario añade complejidad, pero mejora el realismo de la arquitectura.

Aunque el entorno OT no utiliza PLC físico real, sirve para demostrar principios de segmentación IT/OT.

---

## 10. RED-KALI y validación defensiva

RED-KALI permitió comprobar el comportamiento de la arquitectura desde una red no confiable.

Lecciones aprendidas:

- Kali debe usarse como herramienta de validación, no como red confiable.
- Las pruebas deben ser controladas y documentadas.
- El acceso a DMZ puede habilitarse temporalmente para validar escenarios.
- El acceso a TIER0, SOC, MGMT y OT debe permanecer bloqueado.
- Las reglas temporales deben retirarse tras la prueba.
- La validación defensiva debe centrarse en comprobar controles, no en forzar ataques innecesarios.

El valor de RED-KALI fue demostrar que la arquitectura podía contener tráfico no autorizado.

---

## 11. Troubleshooting por capas

Una de las mayores lecciones del proyecto fue reforzar el diagnóstico por capas.

Orden de revisión aplicado:

1. Configuración IP.
2. Máscara y gateway.
3. DNS.
4. Rutas.
5. Firewall.
6. Reglas y aliases.
7. Servicios.
8. Logs.
9. Pruebas desde origen y destino.
10. Evidencias finales.

Este enfoque permitió aislar problemas sin hacer cambios al azar.

---

## 12. Incidencias relevantes

Durante el desarrollo aparecieron incidencias reales que ayudaron a mejorar el laboratorio.

| Incidencia | Aprendizaje |
|---|---|
| Problemas de resolución DNS | DNS no debe validarse solo desde un equipo; hay que comprobar servicio, reenviadores y reglas |
| Problemas de conectividad | Una ruta correcta no garantiza comunicación si el firewall bloquea |
| Integración OT remota | Las rutas estáticas y el host secundario deben documentarse con precisión |
| Procesos suspendidos en Ubuntu | No todos los fallos son de red; también hay que revisar el estado del sistema |
| Reglas temporales residuales | El mínimo privilegio exige limpiar permisos después de validar |
| Reconstrucción del laboratorio | A veces rehacer bien es mejor que arrastrar configuraciones problemáticas |

Estas incidencias aportaron valor al proyecto porque obligaron a diagnosticar, corregir y documentar.

---

## 13. Reconstrucción y mejora del laboratorio

Una decisión importante fue reconstruir el laboratorio tras una incidencia con las máquinas virtuales.

Lecciones aprendidas:

- Los snapshots y backups son fundamentales.
- La documentación debe permitir reconstruir el entorno.
- Una reconstrucción puede mejorar la coherencia del diseño.
- Rehacer desde cero puede eliminar configuraciones arrastradas.
- El orden de despliegue importa.
- Las evidencias deben guardarse de forma organizada.

Esta experiencia reforzó la importancia de la continuidad, la recuperación y la trazabilidad.

---

## 14. Documentación técnica

AÉGIDA demostró que documentar bien es parte del trabajo técnico.

Lecciones aprendidas:

- La documentación no debe ser solo académica.
- GitHub necesita documentación más directa y profesional.
- Las capturas deben seleccionarse, no publicarse todas.
- Los diagramas son más útiles que muchas capturas repetidas.
- Cada archivo debe tener una función clara.
- Es mejor separar arquitectura, tecnologías, evidencias, explicación técnica y lecciones aprendidas.
- Una buena documentación ayuda en entrevistas y revisión técnica.

La transformación a case study profesional permitió convertir una memoria extensa en una documentación más útil para portfolio.

---

## 15. Qué funcionó bien

Puntos que funcionaron especialmente bien:

- Segmentación por zonas.
- pfSense como núcleo de control.
- Separación de MGMT, TIER0 y RED-KALI.
- PAW como punto central de administración.
- Wazuh con cinco agentes.
- FIM sobre activos OT.
- DMZ con servicio web controlado.
- RED-KALI para validar bloqueos.
- Documentación de incidencias.
- Roadmap de mejoras futuras.

---

## 16. Qué mejoraría

Aspectos que podrían mejorarse en una evolución futura:

- Incorporar segundo controlador de dominio.
- Implementar backups automatizados.
- Añadir alta disponibilidad en pfSense.
- Ampliar hardening de Windows y Linux.
- Desplegar Wazuh en arquitectura distribuida.
- Configurar alertas automáticas.
- Integrar una herramienta NOC.
- Añadir simulación Modbus TCP.
- Mejorar procedimientos SOC.
- Automatizar despliegues y validaciones.
- Incorporar control de versiones de configuraciones.
- Extraer y organizar capturas finales desde el PDF original.

---

## 17. Limitaciones asumidas

El laboratorio presenta limitaciones razonables:

- Entorno virtualizado local.
- Recursos físicos limitados.
- OT simulado, no físico.
- Wazuh all-in-one.
- Sin alta disponibilidad real.
- Sin EDR corporativo.
- Sin certificados públicos.
- Pruebas ofensivo-defensivas controladas.
- Evidencias actuales basadas en la documentación final del proyecto.

Estas limitaciones no invalidan el laboratorio. Al contrario, ayudan a definir una evolución realista.

---

## 18. Lecciones para futuros laboratorios ORION

AÉGIDA servirá como base para futuros laboratorios de ORION.

Lecciones aplicables:

- Diseñar primero la arquitectura.
- Crear tabla de redes antes de desplegar.
- Documentar IPs, roles y flujos.
- Guardar capturas clave desde el inicio.
- Usar commits frecuentes.
- Separar documentación pública de notas internas.
- Evitar publicar información sensible.
- Mantener README claro y orientado a valor profesional.
- Crear evidencias seleccionadas, no masivas.
- Pensar cada laboratorio como case study.

---

## 19. Valor personal del aprendizaje

AÉGIDA permitió consolidar conocimientos en varias áreas:

- Redes.
- Sistemas.
- Firewall.
- Active Directory.
- GPOs.
- Linux.
- Wazuh.
- OT simulado.
- Kali Linux.
- Troubleshooting.
- Documentación.
- GitHub.
- Presentación profesional de proyectos.

El aprendizaje más importante fue entender cómo conectar tecnologías distintas dentro de una arquitectura defensiva coherente.

---

## 20. Conclusión

AÉGIDA demuestra que un buen laboratorio profesional no depende solo de la cantidad de herramientas utilizadas, sino de cómo se integran, validan y documentan.

Las principales lecciones aprendidas fueron:

- La segmentación debe diseñarse desde el inicio.
- La administración privilegiada debe estar separada.
- La identidad debe protegerse como activo crítico.
- La monitorización complementa al firewall.
- Las pruebas ofensivas deben tener finalidad defensiva.
- Las incidencias son parte del aprendizaje.
- La documentación técnica convierte un laboratorio en portfolio profesional.

Dentro de PROYECTO ORION, AÉGIDA queda como laboratorio base para seguir evolucionando hacia escenarios más avanzados de ciberseguridad defensiva, SOC, infraestructura híbrida, cloud y automatización.
