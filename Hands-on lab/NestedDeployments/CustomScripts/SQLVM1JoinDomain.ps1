<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - SQLVM1JoinDomain.ps1
 
.What calls this script?
 - This is a PowerShell script running as Script Extension called by BCDRIaaSPrimarySite.json

.What does this script do?  
 - Installs Windows Feature for Failover Clustering and Management Tools
    
 - Changes Windows Firewall to Domain Mode and enables Files and Printer Sharing for Domain mode

 - Enables Network Discovery

 - Joins Contoso.com domain and Restarts

#>

Install-WindowsFeature -Name "Failover-Clustering" `
                       -IncludeManagementTools `
                       -IncludeAllSubFeature

### Disable domain firewall
Set-NetFirewallProfile -Profile Domain -Enabled False

### Enable File and Printer Sharing
Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Domain

### Enable Network Discovery
# Turn on SSDPSRV
Set-Service SSDPSRV -startupType Automatic
Start-Service SSDPSRV
# Turn on Dnscache
Set-Service Dnscache -startupType Automatic
Start-Service Dnscache
# Turn on upnphost
Set-Service upnphost -startupType Automatic
Start-Service upnphost
# Enable Network Discovery
Set-NetFirewallRule -DisplayGroup "Network Discovery" -Enabled True -Profile Domain

#Join Domain
$user = "mcwadmin"
$password = "demo@pass123"
$domain = "contoso.com"
$smPassword = (ConvertTo-SecureString $password -AsPlainText -Force)

$domainUser = "$domain\$user"
$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $domainUser, $smPassword

Add-Computer -DomainName $domain -Credential $cred -Restart
