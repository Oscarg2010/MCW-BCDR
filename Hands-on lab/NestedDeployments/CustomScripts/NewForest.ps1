<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - NewForest.ps1
 
.What calls this script?
 - This is a PowerShell script run as a Custom Script extention called by BCDRIaaSPrimarySite.json

.What does this script do?  
 - Initializes a new data disk, formats and give the letter F:\ (Active Directory will be installed here)
    
 - Instsalls the Active Directory Domain Services Feature and Management Tools

 - Installs a new Active Directory Forest & Domain and places the NTDS Database and SYSVOL on the F Drive

#>


#Configure Disk on Domain Controller
$disk = Get-Disk | where-object PartitionStyle -eq "RAW"
$disk | Initialize-Disk -PartitionStyle MBR -PassThru -confirm:$false
$partition = $disk | New-Partition -UseMaximumSize -DriveLetter F
$partition | Format-Volume -Confirm:$false -Force

#Install Domain Services and Configure New AD Forest
$password = "demo@pass123"
$domain = "contoso.com"
$smPassword = (ConvertTo-SecureString $password -AsPlainText -Force)

Install-WindowsFeature -Name "AD-Domain-Services" `
                       -IncludeManagementTools `
                       -IncludeAllSubFeature 
 
Install-ADDSForest -DomainName $domain `
				   -DomainMode "Win2012" `
				   -ForestMode "Win2012" `
                   -DatabasePath "F:\NTDS" `
				   -LogPath "F:\NTDS" `
                   -SYSVOLPath "F:\NTDS\SYSVOL" `
				   -SafeModeAdministratorPassword $smPassword `
                   -Force