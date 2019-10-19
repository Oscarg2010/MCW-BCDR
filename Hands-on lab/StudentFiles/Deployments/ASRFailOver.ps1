<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - ASRFailover.ps1

.What calls this script?
 - This script gets called by the BCDRAOG Runbook in Azure Automation
 - A Failover from the Primary Site to the Secondary Site using Azure Site Recovery
 - This file will be run as a Custom Script Extention on the SQLVM3 box which is the Secondary Site,
 - AOG partner running in A-Synch mode with Manual Failover.

.What does this script do?
 - Forces a manual failover of the SQL AOG from SQLVM1 to SQLVM3
 - Now that SQLVM3 is the Primary Replica it will be changed to Synchronous Commits and Automatic Failovers
 
#>
Import-Module sqlps
$AGPath = "SQLSERVER:\Sql\SQLVM3\DEFAULT\AvailabilityGroups\BCDRAOG"
Switch-SqlAvailabilityGroup -Path $AGpath `
                             -AllowDataLoss `
                             -Force

$ReplicaPath = "SQLSERVER:\SQL\SQLVM3\DEFAULT\AvailabilityGroups\BCDRAOG\AvailabilityReplicas\SQLVM3"
Set-SqlAvailabilityReplica -AvailabilityMode "SynchronousCommit" `
                           -FailoverMode Automatic `
                           -Path $ReplicaPath