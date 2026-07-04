# Esquema lógico — LAB-00 AÉGIDA Case Study

## Objetivo

Añadir un esquema lógico renderizable directamente en GitHub mediante Mermaid, manteniendo las imágenes y diagramas existentes del laboratorio.

La imagen principal publicada se conserva en:

```text
diagramas/01-topologia-logica-global.png
```

## Esquema lógico Mermaid

```mermaid
flowchart TB
    WAN["WAN / Internet\nVMnet8 NAT\n192.168.139.0/24"]
    FW["AEGIDA-PF-FW\npfSense\nFirewall central / gateways"]

    subgraph DMZ["DMZ - 192.168.10.0/24"]
        DMZ01["AEGIDA-SRV-DMZ01\nUbuntu / Nginx\n192.168.10.10"]
    end

    subgraph MGMT["MGMT - 192.168.20.0/24"]
        PAW["AEGIDA-PAW01\nPAW / RSAT / Admin\n192.168.20.10"]
    end

    subgraph TIER0["TIER0 - 192.168.30.0/24"]
        DC["AEGIDA-DC01\nAD DS / DNS\n192.168.30.10"]
    end

    subgraph SOC["SOC - 192.168.40.0/24"]
        WAZUH["AEGIDA-SOC-WAZUH01\nWazuh all-in-one\n192.168.40.10"]
    end

    subgraph TRANSIT["TRANSIT-LAB - 192.168.60.0/24"]
        TRANSITGW["Host secundario / next hop\n192.168.60.2"]
    end

    subgraph OT["OT simulada - 192.168.50.0/24"]
        PLC["AEGIDA-OT-PLC01\nPLC simulado\n192.168.50.20"]
        HMI["AEGIDA-OT-HMI01\nHMI simulada\n192.168.50.30"]
    end

    subgraph KALI["RED-KALI - 192.168.70.0/24"]
        REDKALI["AEGIDA-RED-KALI01\nKali / pruebas controladas\n192.168.70.50"]
    end

    WAN --> FW
    FW --> DMZ01
    FW --> PAW
    FW --> DC
    FW --> WAZUH
    FW --> TRANSITGW
    TRANSITGW --> PLC
    TRANSITGW --> HMI
    FW --> REDKALI

    PAW -->|Administración autorizada| FW
    PAW -->|RSAT / DNS / GPO| DC
    PAW -->|SSH / HTTP| DMZ01
    PAW -->|Wazuh web / SSH| WAZUH
    PAW -->|Admin controlada| PLC
    PAW -->|Admin controlada| HMI

    DMZ01 -->|DNS limitado| DC
    DMZ01 -->|Agente Wazuh| WAZUH
    DC -->|Agente Wazuh| WAZUH
    PAW -->|Agente Wazuh| WAZUH
    PLC -->|Agente Wazuh| WAZUH
    HMI -->|Agente Wazuh| WAZUH

    REDKALI -. "Bloqueado / filtrado" .-> TIER0
    REDKALI -. "Bloqueado / filtrado" .-> MGMT
    REDKALI -. "Bloqueado / filtrado" .-> SOC
    REDKALI -. "Bloqueado / filtrado" .-> OT
    REDKALI -->|Pruebas controladas| DMZ01
```

## Lectura rápida

- pfSense actúa como núcleo de segmentación.
- La PAW concentra la administración autorizada.
- TIER0 contiene identidad y DNS.
- SOC/Wazuh aporta visibilidad defensiva.
- OT queda separada y se alcanza por TRANSIT-LAB.
- RED-KALI se usa como red no confiable para validar bloqueos y exposición controlada.
