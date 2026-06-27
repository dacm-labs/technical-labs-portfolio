# LAB-02 - Validacion final DNS y puertos
# Ejecutar desde ORN-DBA01 con PowerShell.

hostname

Clear-DnsClientCache

Resolve-DnsName ORN-SQL01.orion.lab -Type A
Resolve-DnsName ORN-SQL02.orion.lab -Type A
Resolve-DnsName ORN-SQLAG01.orion.lab -Type A
Resolve-DnsName ORN-SQLCL01.orion.lab -Type A
Resolve-DnsName ORN-FSW01.orion.lab -Type A

Test-NetConnection ORN-SQL01.orion.lab -Port 1433
Test-NetConnection ORN-SQL02.orion.lab -Port 1433
Test-NetConnection ORN-SQLAG01.orion.lab -Port 1433

Test-NetConnection ORN-SQL01.orion.lab -Port 5022
Test-NetConnection ORN-SQL02.orion.lab -Port 5022

Test-NetConnection ORN-SQLCL01.orion.lab -Port 3343
