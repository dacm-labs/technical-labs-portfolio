# LAB-02 — SQL Server Always On Availability Groups

![LAB-02 — SQL Server Always On Availability Groups](diagramas/lab02_cover.png)

![Estado](https://img.shields.io/badge/estado-completado-success)
![Tipo](https://img.shields.io/badge/tipo-laboratorio-orange)
![Área](https://img.shields.io/badge/área-SQL%20Server%20%7C%20HA%2FDR%20%7C%20DBA-blueviolet)
![Stack](https://img.shields.io/badge/stack-SQL%20Server%202025%20%7C%20WSFC%20%7C%20Always%20On-lightgrey)

## Descripción

LAB-02 amplía el entorno DBA construido en LAB-01 hacia un escenario de alta disponibilidad basado en **Windows Server Failover Cluster** y **SQL Server Always On Availability Groups**.

El laboratorio reutiliza el dominio `orion.lab`, el nodo `ORN-SQL01`, la estación administrativa `ORN-DBA01` y la base `OrionLabDB`, añadiendo un segundo nodo SQL Server, un File Share Witness, un clúster WSFC, un Availability Group y un listener de conexión.

## Objetivos

- Construir un clúster WSFC de dos nodos para SQL Server.
- Configurar quorum mediante File Share Witness.
- Habilitar Always On en dos instancias SQL Server 2025.

