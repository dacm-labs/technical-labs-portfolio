# Lecciones aprendidas LAB-04

## Objetivo

Recoger los aprendizajes técnicos y operativos obtenidos durante el despliegue de monitorización centralizada con Zabbix sobre Windows Server, SQL Server y Always On.

## Lecciones técnicas

### 1. Monitorizar no es solo instalar una herramienta

Antes de instalar Zabbix fue necesario validar:

- RAM del host físico.
- Estado de SQL Server.
- Estado de Always On.
- DNS y puertos críticos.
- Jobs y backups.
- Auditoría.
- Hardening.
- Eventos Windows y clúster.

Esto evita construir monitorización sobre un entorno inestable.

### 2. La monitorización nativa sigue siendo útil

Get-Counter, PerfMon, logman, SQL Error Log, Windows Event Log y DMVs siguen siendo herramientas muy valiosas para entender qué está pasando antes de centralizar métricas.

La capa nativa aporta contexto y permite comprobar que los datos que más tarde verá Zabbix tienen sentido.

### 3. Always On obliga a diseñar checks con contexto

En un Availability Group no todos los nodos deben alertar igual.

Ejemplo clave:

- ORN-SQL01 es primario para `OrionLabDB`.
- ORN-SQL02 es secundario.
- Un backup antiguo debe alertar en el nodo responsable, no generar falsos positivos en la secundaria.

Por eso el item `orion.sql.ag.is_primary[OrionLabDB]` se vuelve esencial para condicionar triggers.

### 4. Windows Authentication complica, pero mejora el diseño

Era más fácil crear un usuario SQL, pero eso habría roto la línea de hardening del LAB-03.

Mantener Windows Authentication obliga a resolver mejor:

- Cuenta de servicio.
- Permisos locales.
- Derechos de servicio.
- Ejecución de scripts.
- Conexión integrada a SQL Server.

El resultado final es más defendible.

### 5. Los UserParameters deben devolver valores simples

Para Zabbix, un check debe ser predecible.

Los scripts manuales pueden devolver tablas o diagnósticos largos, pero los UserParameters deben devolver valores como:

- `1` correcto.
- `0` incorrecto.
- número de sesiones.
- horas desde último backup.
- número de bloqueos.

Esto obliga a traducir necesidad DBA a métrica operativa.

### 6. No todo problema del dashboard es relevante

El template Windows genérico puede generar ruido por servicios no críticos.

La lección es separar:

- Problemas SQL custom relevantes.
- Problemas genéricos Windows que no bloquean el laboratorio.

Esto es muy parecido a operación real: no toda alerta tiene la misma prioridad.

### 7. La evidencia más fuerte es la recuperación

La captura de una alerta es útil, pero la validación completa incluye:

1. Detección.
2. Diagnóstico.
3. Acción correctiva.
4. Resolución.
5. Estado final limpio.

El ciclo de LOG backup antiguo demuestra esa cadena completa.

## Incidencias destacadas

| Incidencia | Aprendizaje |
|---|---|
| Apache no arrancaba por ProxyTimeout | Validar módulos y PHP-FPM antes de asumir fallo de Zabbix. |
| Jobs AG-aware sin schedule | Un job enabled no significa que se ejecute automáticamente. |
| Eventos FailoverClustering tras redimensionar | Revisar estado actual antes de corregir eventos históricos. |
| APIPA local en ORN-SQL02 | Diferenciar DNS autoritativo de resolución local del host. |
| Agent 2 en SQL01 con LocalSystem | Priorizar estabilidad y documentar excepción cuando el servicio funciona. |

## Mejoras futuras

- Crear dashboard ejecutivo específico para SQL Server Operations.
- Homogeneizar la cuenta de servicio de Agent 2 en SQL01 y SQL02.
- Programar schedules para jobs AG-aware si el entorno queda encendido.
- Ajustar triggers ruidosos del template Windows.
- Añadir más checks SQL: log usage, DB size, failed logins, CHECKDB age y latency básica.

## Conclusión

LAB-04 refuerza una idea clave: monitorizar bien requiere entender la infraestructura, el servicio, la seguridad y el contexto operativo. Zabbix aporta la plataforma, pero el valor profesional está en diseñar checks útiles, evitar falsos positivos y demostrar recuperación real.
