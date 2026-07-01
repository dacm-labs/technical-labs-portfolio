<#
.SYNOPSIS
    LAB-04 - Cluster and DNS health validation.

.DESCRIPTION
    Validates WSFC group/resource state, cluster node status, DNS resolution and domain secure channel.
    Useful after VM restarts, memory changes, failover tests or monitoring incidents.

.EXECUTION
    Run on ORN-SQL01 or ORN-SQL02 using PowerShell 7 as Administrator.
#>

Write-Host "=== Cluster groups ===" -ForegroundColor Cyan

Get-ClusterGroup |
Select-Object Name,State,OwnerNode |
Format-Table -AutoSize

Write-Host "`n=== Cluster resources ===" -ForegroundColor Cyan

Get-ClusterResource |
Select-Object Name,ResourceType,State,OwnerGroup,OwnerNode |
Sort-Object OwnerGroup,Name |
Format-Table -AutoSize

Write-Host "`n=== Cluster nodes ===" -ForegroundColor Cyan

Get-ClusterNode |
Select-Object Name,State |
Format-Table -AutoSize

Write-Host "`n=== DNS resolution ===" -ForegroundColor Cyan

$Names = @(
    "ORN-DC01.orion.lab",
    "ORN-SQL01.orion.lab",
    "ORN-SQL02.orion.lab",
    "ORN-SQLAG01.orion.lab",
    "ORN-SQLCL01.orion.lab"
)

foreach ($Name in $Names) {
    Resolve-DnsName $Name -Type A -DnsOnly |
    Select-Object Name,Type,IPAddress
}

Write-Host "`n=== Domain controller discovery ===" -ForegroundColor Cyan

nltest /dsgetdc:orion.lab

Write-Host "`n=== Computer secure channel ===" -ForegroundColor Cyan

Test-ComputerSecureChannel -Verbose
