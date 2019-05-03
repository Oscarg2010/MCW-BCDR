<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - ASRRunBookSQL.ps1

.What calls this script?
 - This is an Azure Automation Runbook used for Failing over and Failing Back SQL Always On Region to Region.
 
 - Azure Site Recovery is required for this to function properly as it relies on the context,
   of the failover type passed.

.What does this script do?  
 - When there is a Failover from Primary to Secondary the RecoveryPlanContext.FailoverDirection property 
   is set to: "PrimaryToSecondary", the script will force a manual failover allowing dataloss of the 
   SQL AOG from SQLVM1 (Primary Replica/Auto) to SQLVM3(Secondary Replica/Manual) and then set the 
   SQLVM1 and SQLVM2 to resume data movement (Data movement is Paused by SQL during manual failovers).
 
 - When there is a Failback from Secondary to Primary the RecoveryPlanContext.FailoverDirection property 
   is set to: "SecondaryToPrimary" and the script will then set SQLVM1 to the Primary Replica.  SQLVM3
   will remain a Syncronous partern and must be manually configured back to Asynchronous / Manual once the
   BCDR team agrees this is a safe course of action.
 
#>
workflow ASRSQLFailover
{
    param ( 
        [parameter(Mandatory=$false)] 
        [Object]$RecoveryPlanContext 
    ) 
    $connectionName = "AzureRunAsConnection" 
    $ASRFailoverScriptPath = "https://www.dropbox.com/s/q3tb6h2u1qqzqx8/ASRFailOver.ps1?dl=1"
	$ASRFailoverScriptPathSQLVM1 = "https://www.dropbox.com/s/t3f2wx9rzlwgkbx/ASRFailOverSQLVM1.ps1?dl=1"
	$ASRFailoverScriptPathSQLVM2 = "https://www.dropbox.com/s/cfr2v9alyslct8c/ASRFailOverSQLVM2.ps1?dl=1"
	$ASRFailBackScriptPath = "https://www.dropbox.com/s/szq4zkq75xa3ue1/ASRFailBack.ps1?dl=1"
    
Try 
 {
    #Logging in to Azure...

    "Logging in to Azure..."
    $Conn = Get-AutomationConnection -Name AzureRunAsConnection 
     Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

    "Selecting Azure subscription..."
    Select-AzureRmSubscription -SubscriptionId $Conn.SubscriptionID -TenantId $Conn.tenantid 
 }
Catch
 {
      $ErrorMessage = 'Login to Azure subscription failed.'
      $ErrorMessage += " `n"
      $ErrorMessage += 'Error: '
      $ErrorMessage += $_
      Write-Error -Message $ErrorMessage `
                    -ErrorAction Stop
 }
	
    $RPVariable = Get-AutomationVariable -Name $RecoveryPlanContext.RecoveryPlanName
    $RPVariable = $RPVariable | convertfrom-json
	
	"Configurations used by this Runbook for the Failover..."
    Write-Output $RPVariable

	"Determining if Failover or Failback..."
	Write-Output $RecoveryPlanContext.FailoverDirection
	
	"Configuring Script based on Direction of Failover..."
    if ($RecoveryPlanContext.FailoverDirection -eq "PrimaryToSecondary") { 
        $SQLVMRG = $RPVariable.SecondarySiteSQLVMRG
        $SQLVMName = $RPVariable.SecondarySiteSQLVMName
        $Path = $RPVariable.SecondarySitePath
		$SQLVM1RG = $RPVariable.PrimarySiteSQLVMRG
		$SQLVM2RG = $RPVariable.PrimarySiteSQLVMRG
		        
        InlineScript {

			Write-Output "Failing Over from Primary Site to Secondary Site"
            Write-Output "Removing older custom script extension on: Primary Replica"
            $SQLVM = Get-AzureRMVM -ResourceGroupName $Using:SQLVMRG -Name $Using:SQLVMName
            $csextension = $SQLVM.Extensions |  Where-Object {$_.VirtualMachineExtensionType -eq "CustomScriptExtension"}
            Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVMRG -VMName $Using:SQLVMName -Name $csextension.Name -Force
            Write-output "Failing over from Primary Site to Secondary Site. The new Primary Replica is on:" $SQLVMName
            Set-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVMRG -VMName $Using:SQLVMName -Location $SQLVM.Location -FileUri $Using:ASRFailoverScriptPath -Run ASRFailover.ps1 -Name ASRFailOverCS
            Write-output "Completed AG Failover to Secondary Site"
			
			Write-Output "Removing older custom script extension on: SQLVM1" 
            $SQLVM1 = Get-AzureRMVM -ResourceGroupName $Using:SQLVM1RG -Name "SQLVM1"
            $csextension = $SQLVM1.Extensions |  Where-Object {$_.VirtualMachineExtensionType -eq "CustomScriptExtension"}
            Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVM1RG -VMName "SQLVM1" -Name $csextension.Name -Force
            Write-output "Resuming Data Movement on SQLVM1"
            Set-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVM1RG -VMName "SQLVM1" -Location $SQLVM1.Location -FileUri $Using:ASRFailoverScriptPathSQLVM1 -Run ASRFailoverSQLVM1.ps1 -Name ASRFailOverSQLVM1CS
            Write-output "Data Movement Resumed on SQLVM1"

			Write-Output "Removing older custom script extension on: SQLVM2" 
            $SQLVM2 = Get-AzureRMVM -ResourceGroupName $Using:SQLVM2RG -Name "SQLVM2"
            $csextension = $SQLVM2.Extensions |  Where-Object {$_.VirtualMachineExtensionType -eq "CustomScriptExtension"}
            Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVM2RG -VMName "SQLVM2" -Name $csextension.Name -Force
            Write-output "Resuming Data Movement on SQLVM2"
            Set-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVM2RG -VMName "SQLVM2" -Location $SQLVM2.Location -FileUri $Using:ASRFailoverScriptPathSQLVM2 -Run ASRFailoverSQLVM2.ps1 -Name ASRFailOverSQLVM2CS
            Write-output "Data Movement Resumed on SQLVM2"
		}
    }
    else {
        $SQLVMRG = $RPVariable.PrimarySiteSQLVMRG
        $SQLVMName = $RPVariable.PrimarySiteSQLVMName
        $Path = $RPVariable.PrimarySitePath
        
        InlineScript {
			
			Write-Output "Failing Back from Secondary Site to Primary Site"
            Write-Output "Removing older custom script extension"
            $SQLVM = Get-AzureRMVM -ResourceGroupName $Using:SQLVMRG -Name $Using:SQLVMName
            $csextension = $SQLVM.Extensions |  Where-Object {$_.VirtualMachineExtensionType -eq "CustomScriptExtension"}
            Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVMRG -VMName $Using:SQLVMName -Name $csextension.Name -Force
            Write-output "Failing back from Secondary Site to Primary Site. The new Primary Replica is on SQLVM1"
            Set-AzureRmVMCustomScriptExtension -ResourceGroupName $Using:SQLVMRG -VMName $Using:SQLVMName -Location $SQLVM.Location -FileUri $Using:ASRFailBackScriptPath -Run ASRFailback.ps1 -Name ASRFailBackCS
            Write-output "Completed AG Failback to Primary Site"
		}
    }
}
