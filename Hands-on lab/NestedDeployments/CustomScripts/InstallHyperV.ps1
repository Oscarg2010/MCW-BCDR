<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - InstallHyperV.ps1
 
.What calls this script?
 - This is a PowerShell DSC run as a Custom Script extention called by BCDROnPremPrimarySite.json

.What does this script do?  
 - Downloads NuGet package provider
    
 - Installs the DscResource and xHyper-V PS modules in support of the upcoming DSC Extenion run in HyperVHostConfig.ps1

 - Installs Hyper-V with all Features and Management Tools and then Restarts the Machine

#>

# Set PowerShell Execution Policy
Set-ExecutionPolicy Unrestricted -Force

# Enable TLS 1.2 Strong Cryptography in .NET Framework 4.5 or higher
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install Nuget
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Find-Module -Includes DscResource -Name xHyper-v | Install-Module -Force

# Install Hyper-V and Reboot
Install-WindowsFeature -Name Hyper-V `
                       -IncludeAllSubFeature `
                       -IncludeManagementTools `
                       -Verbose `
                       -Restart