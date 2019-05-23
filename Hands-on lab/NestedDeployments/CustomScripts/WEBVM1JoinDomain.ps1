<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - WEBVM1JoinDomain.ps1
 
.What calls this script?
 - This is a PowerShell script running as Script Extension called by BCDRIaaSPrimarySite.json

.What does this script do?  
 - Installs Windows Feature for IIS and Management Tools
    
 - Downloads the Contoso Insurance Policy Connect Sample Applciation and moves it to the default www folder

 - Joins Contoso.com domain and Restarts

#>
# Install IIS
Install-WindowsFeature -Name "web-server" `
                       -IncludeManagementTools `
                       -IncludeAllSubFeature

#Download and Unpack the Website
$zipDownload = "https://www.dropbox.com/s/wcfnuf76h3tn3ws/ContosoInsuranceIIS.zip?dl=1"
$downloadedFile = "D:\ContosoInsuranceIIS.zip"
$inetpubFolder = "C:\inetpub\wwwroot"
Invoke-WebRequest $zipDownload -OutFile $downloadedFile
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($downloadedFile, $inetpubFolder)

#Join Domain
$user = "mcwadmin"
$password = "demo@pass123"
$domain = "contoso.com"
$smPassword = (ConvertTo-SecureString $password -AsPlainText -Force)
$domainUser = "$domain\$user"
$cred = new-object -typename System.Management.Automation.PSCredential `
		           -argumentlist $domainUser, $smPassword
Add-Computer -DomainName $domain -Credential $cred -Restart
