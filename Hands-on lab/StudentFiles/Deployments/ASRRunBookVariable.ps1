<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - ASRRunBookVariable.ps1

.What calls this script?
 - No other scripts call this directly, but it is very important to the ASRRunBook.ps1 file.
 
 - It must be run from the LABVM or a machine with the Azure PowerShell cmdlets installed prior to running the ASRRunBook.

.What does this script do?
 - This script creates a variable in Azure Automation in support of the AOG Automated Failover

#>
Connect-AzAccount
$AutomationAccountName = "YOUR-AUTOMATION-ACOUNT-NAME-HERE"
$InputObject = @{"PrimarySiteSQLVMRG" = "BCDRIaaSPrimarySite" ; "PrimarySiteSQLVMName" = "SQLVM1" ; "SecondarySiteSQLVMRG" = "BCDRIaaSSecondarySite" ; "SecondarySiteSQLVMName" = "SQLVM3" ; "PrimarySitePath" = "SQLSERVER:\Sql\SQLVM1\DEFAULT\AvailabilityGroups\BCDRAOG" ; "SecondarySitePath" = "SQLSERVER:\Sql\SQLVM3\DEFAULT\AvailabilityGroups\BCDRAOG"}
$RPDetails = New-Object -TypeName PSObject -Property $InputObject  | ConvertTo-Json
New-AzAutomationVariable -Name "BCDRIaaSPlan" -ResourceGroupName "BCDRAzureAutomation" -AutomationAccountName $AutomationAccountName -Value $RPDetails -Encrypted $false
