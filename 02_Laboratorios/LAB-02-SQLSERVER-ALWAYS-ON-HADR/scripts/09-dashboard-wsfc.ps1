# LAB-02 - Dashboard final WSFC
# Ejecutar desde ORN-SQL01 con PowerShell como administrador.

Get-Cluster |
Select-Object Name, Domain, AdministrativeAccessPoint |
Format-Table -AutoSize

Get-ClusterNode |
Select-Object Name, State |
Format-Table -AutoSize

Get-ClusterQuorum |
Format-Table -AutoSize

Get-ClusterResource |
Select-Object Name, ResourceType, State, OwnerGroup, OwnerNode |
Format-Table -AutoSize

Get-ClusterNetwork |
Select-Object Name, Address, AddressMask, Role, State |
Format-Table -AutoSize

Resolve-DnsName ORN-SQLCL01.orion.lab -Type A
Resolve-DnsName ORN-SQLAG01.orion.lab -Type A
Resolve-DnsName ORN-FSW01.orion.lab -Type A
Resolve-DnsName ORN-SQL01.orion.lab -Type A
Resolve-DnsName ORN-SQL02.orion.lab -Type A
