<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - ASRFailback.ps1

.What calls this script?
 - This script gets called by the BCDRAOG Runbook in Azure Automation
 - A Failover from the Secondary Site to the Primary Site using Azure Site Recovery

.What does this script do?
 - Forces a Manual failover of the SQL AOG from SQLVM3 to SQLVM1
 - Now that SQLVM1 will resume as the Primary Replica with Synchronous Commits and Automatic Failovers
 
#>
Import-Module sqlps
$AGPath = "SQLSERVER:\Sql\SQLVM1\DEFAULT\AvailabilityGroups\BCDRAOG"
Switch-SqlAvailabilityGroup -Path $AGPath
