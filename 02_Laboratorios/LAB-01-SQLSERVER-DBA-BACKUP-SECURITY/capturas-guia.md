# Guía rápida de capturas LAB-01

## Objetivo

Esta guía explica cómo preparar o sustituir capturas finales del LAB-01 para GitHub.

## Carpeta destino

```text
02_Laboratorios/LAB-01-SQLSERVER-DBA-BACKUP-SECURITY/capturas
```

## Flujo recomendado

1. Abrir el documento Word final privado del LAB-01.
2. Localizar las capturas indicadas en `evidencias.md`.
3. Exportar solo las capturas con valor técnico.
4. Guardarlas en la carpeta `capturas`.
5. Renombrarlas con el esquema numerado recomendado.
6. Revisar que no aparezcan contraseñas, tokens ni datos sensibles.
7. Hacer commit local y push.

## Capturas prioritarias

- Dominio, DNS y estructura AD.
- SQL Server instalado y conexión SSMS.
- Backups y restore.
- SQL Server Agent jobs.
- Database Mail y operador DBA.
- Seguridad SQL y mínimo privilegio.
- Eventos SQL.
- Query Store.
- Dashboard DBA final.

## Comandos Git

```powershell
cd <ruta-local-del-repositorio>
git status
git add 02_Laboratorios/LAB-01-SQLSERVER-DBA-BACKUP-SECURITY/capturas
git commit -m "docs(lab01): actualizar capturas finales"
git push origin main
```
