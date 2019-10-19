<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - ASRFailoverSQLVM1.ps1

.What calls this script?
 - This script gets called by the BCDRAOG Runbook in Azure Automation
 - A Failover from the Primary Site to the Secondary Site using Azure Site Recovery
 - This file will be run as a Custom Script Extention on the SQLVM1 box which is in the Primary Site,
 - AOG partner running in A-Synch mode with Automatic Failover.

.What does this script do?
 - Resumes Data movement to the local Replica.  During the Force failover data movement is paused
 - Now that SQLVM3 is the Primary Replica it will be changed to Synchronous Commits and Automatic Failovers
 - Without this step then the AOG won't be in a "Synchronized" State
 
#>
Import-Module sqlps
$DBPath = "SQLSERVER:\Sql\SQLVM1\DEFAULT\AvailabilityGroups\BCDRAOG\AvailabilityDatabases"
Get-ChildItem $DBPath | Resume-SqlAvailabilityDatabase
