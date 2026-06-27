# Lecciones aprendidas — LAB-01 SQL Server DBA

## Resumen

Durante el LAB-01 se trabajaron tareas técnicas reales de administración SQL Server y también incidencias habituales de laboratorio.

El aprendizaje principal es que un entorno DBA no se valida solo instalando el motor SQL: hay que probar conectividad, permisos, backups, restores, automatización, auditoría y estado operativo final.

---

## Aprendizajes principales

- Validar red, DNS y dominio antes de instalar servicios.
- Separar servidor SQL y estación administrativa mejora el realismo.
- Revisar permisos NTFS antes de instalar SQL Server evita errores posteriores.
- Un backup solo tiene valor si se verifica y se prueba el restore.
- El recovery model FULL requiere una cadena de backups coherente.
- SQL Server Agent permite convertir tareas manuales en operación programada.
- Las alertas por fallo aportan valor operativo real.
- Los grupos AD facilitan aplicar mínimo privilegio.
- La auditoría y el dashboard ayudan a explicar el estado del entorno.

---

## Lecciones por bloque

| Bloque | Aprendizaje |
|---|---|
| Dominio y DNS | La resolución de nombres condiciona todo el laboratorio. |
| SQL Server | Las rutas, servicios y permisos deben quedar claros desde el principio. |
| Backup & Recovery | La estrategia solo es válida si se restaura y se verifica. |
| PITR | La recuperación temporal demuestra capacidad real ante errores operativos. |
| SQL Agent | La automatización convierte el laboratorio en operación mantenible. |
| Avisos | Una tarea crítica debe avisar cuando falla. |
| Seguridad | El mínimo privilegio debe probarse con usuarios reales de laboratorio. |
| Auditoría | La trazabilidad debe poder consultarse y explicarse. |
| Query Store | Comparar antes/después ayuda a demostrar diagnóstico de rendimiento. |
| Dashboard DBA | Un resumen final facilita explicar el estado de salud del entorno. |

---

## Incidencias y decisiones relevantes

- Se evitó instalar herramientas administrativas innecesarias en el servidor SQL.
- La administración se centralizó desde una estación DBA.
- Se mantuvo una separación clara entre datos, logs, backups, TempDB y auditoría.
- Se documentó la limitación de autenticación SMTP encontrada y se usó una alternativa técnica de laboratorio.
- Se validaron usuarios con distintos niveles de permisos para comprobar que la seguridad funcionaba en la práctica.

---

## Mejoras futuras

- Añadir scripts públicos más completos de creación de jobs y dashboard.
- Ampliar auditoría con más acciones sensibles.
- Integrar monitorización centralizada en un laboratorio posterior.
- Reforzar hardening SQL en LAB-03.
- Mantener continuidad con el entorno Always On de LAB-02.

---

## Conclusión

El laboratorio deja una base sólida para futuras ampliaciones del portfolio técnico, especialmente alta disponibilidad, hardening, auditoría avanzada y monitorización.
