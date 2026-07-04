# Valor profesional LAB-04

## Objetivo

Explicar qué competencias profesionales demuestra LAB-04 dentro del portfolio técnico.

Este laboratorio no se limita a instalar una herramienta. Demuestra criterio operativo: validar primero el entorno, desplegar monitorización centralizada, crear checks personalizados, evitar falsos positivos y cerrar una alerta real con evidencia de recuperación.

## Competencias demostradas

| Área | Competencia demostrada |
|---|---|
| Sistemas | Despliegue y administración de una VM Linux para servicio centralizado. |
| Windows Server | Integración de nodos Windows mediante agente, servicios y firewall. |
| SQL Server DBA | Monitorización de servicios, jobs, backups, bloqueos, sesiones y Always On. |
| Alta disponibilidad | Diseño de checks teniendo en cuenta primario/secundario y listener. |
| Seguridad | Respeto del hardening previo, Windows Authentication y ausencia de secretos en Git. |
| Monitorización | Uso de Zabbix Server, Agent 2, items, triggers, Latest data y Problems. |
| Automatización | PowerShell como wrapper para checks SQL custom. |
| Troubleshooting | Diagnóstico de Apache, agentes, DNS, clúster, backups antiguos y ruido de plantillas. |
| Documentación | Markdown, evidencias, manifest, scripts y cierre reproducible. |
| Git/GitHub | Versionado de scripts, template YAML, documentación y capturas seleccionadas. |

## Valor para perfil sysadmin / operación IT

LAB-04 muestra capacidad para:

- Centralizar monitorización de servidores.
- Instalar agentes en nodos Windows.
- Validar conectividad y puertos.
- Restringir firewall a un servidor de monitorización concreto.
- Interpretar problemas reales y distinguir ruido de alertas relevantes.
- Documentar hallazgos sin ocultar limitaciones.

## Valor para perfil DBA junior

El laboratorio demuestra conocimiento práctico de SQL Server operativo:

- Monitorización de SQL Server y SQL Server Agent.
- Validación de backups FULL y LOG.
- Revisión de jobs SQL Agent.
- Uso de `msdb` para backup history y job history.
- Uso de DMVs para sesiones, bloqueos y Always On.
- Diseño de checks con valores únicos aptos para monitorización.
- Validación de alerta por LOG backup antiguo y recuperación con backup manual.

## Valor para perfil seguridad defensiva / Blue Team junior

Aunque LAB-04 no es un SIEM, aporta una base muy útil para operación defensiva:

- Supervisión de disponibilidad de servicios críticos.
- Reducción de exposición mediante firewall restringido.
- Continuidad con el hardening del LAB-03.
- No publicación de secretos.
- Trazabilidad documental de incidencias.
- Preparación para futuros casos de uso SOC/Wazuh.

## Diferenciador del laboratorio

El punto más fuerte del LAB-04 es que no termina en una pantalla bonita. Termina con un ciclo real:

```text
métrica -> trigger -> problema -> acción correctiva -> recuperación -> evidencia
```

Ese ciclo es muy defendible en entrevista porque se parece a operación real de infraestructura.

## Limitaciones reconocidas

| Limitación | Estado |
|---|---|
| Dashboard ejecutivo dedicado no creado | Mejora futura no bloqueante. |
| ORN-SQL01 con Agent 2 temporalmente en LocalSystem | Documentado y validado funcionalmente. |
| Jobs AG-aware sin schedule | Documentado; explica alerta de backup antiguo. |
| Ruido de template Windows genérico | Documentado; no afecta a SQL custom. |

## Conclusión

LAB-04 aporta una pieza clave al portfolio: operación y monitorización centralizada sobre una plataforma SQL Server Always On previamente construida, endurecida y auditada. Es un laboratorio especialmente útil para candidaturas de sistemas, DBA junior, soporte avanzado, operación IT y base Blue Team.
