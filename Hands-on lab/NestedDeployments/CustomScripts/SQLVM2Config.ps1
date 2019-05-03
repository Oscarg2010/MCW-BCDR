<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - SQLVM2Config.ps1
 
.What calls this script?
 - This is a PowerShell DSC script running as Script Extension called by BCDRIaaSPrimarySite.json

.What does this script do?  
 - Initializes a new data disk, formats and give the letter F:\ and creates Backup, Data and Logs directories
    
 - Sets SQL Configs: Directories made as defaults, Enables TCP, Eables Mixed Authentication SA Account

 - Adds the Domain Built-In Administrators to the SYSADMIN group

 - Opens three Firewall ports in support of the AOG:  1433 (default SQL), 5022 (HADR Listener), 59999 (Internal Loadbalacer Probe)

#>
Configuration Main
{

Param ( [string] $nodeName )

Import-DscResource -ModuleName PSDesiredStateConfiguration

Node $nodeName
  {
    Script ConfigureSql
    {
        TestScript = {
            return $false
        }
        SetScript ={
		$disk = Get-Disk | where-object PartitionStyle -eq "RAW"
		$disk | Initialize-Disk -PartitionStyle MBR -PassThru -confirm:$false
		$partition = $disk | New-Partition -UseMaximumSize -DriveLetter F
		$partition | Format-Volume -Confirm:$false -Force

		Start-Sleep -Seconds 60

		$logs = "F:\Logs"
		$data = "F:\Data"
		$backups = "F:\Backup" 
		[system.io.directory]::CreateDirectory($logs)
		[system.io.directory]::CreateDirectory($data)
		[system.io.directory]::CreateDirectory($backups)
		
	# Setup the data, backup and log directories as well as mixed mode authentication
	Import-Module "sqlps" -DisableNameChecking
	[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
	$sqlesq = new-object ('Microsoft.SqlServer.Management.Smo.Server') Localhost
	$sqlesq.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
	$sqlesq.Settings.DefaultFile = $data
	$sqlesq.Settings.DefaultLog = $logs
	$sqlesq.Settings.BackupDirectory = $backups
	$sqlesq.Alter() 

	# Enable TCP Server Network Protocol
	$smo = 'Microsoft.SqlServer.Management.Smo.'  
	$wmi = new-object ($smo + 'Wmi.ManagedComputer').  
	$uri = "ManagedComputer[@Name='" + (get-item env:\computername).Value + "']/ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Tcp']"  
	$Tcp = $wmi.GetSmoObject($uri)  
	$Tcp.IsEnabled = $true  
	$Tcp.Alter() 

	# Restart the SQL Server service
	Restart-Service -Name "MSSQLSERVER" -Force
	
	# Re-enable the sa account and set a new password to enable login
	Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER LOGIN sa ENABLE"
	Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER LOGIN sa WITH PASSWORD = 'demo@pass123'"
	
	#Add local administrators group as sysadmin
	Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "CREATE LOGIN [BUILTIN\Administrators] FROM WINDOWS"
	Invoke-Sqlcmd -ServerInstance Localhost -Database "master" -Query "ALTER SERVER ROLE sysadmin ADD MEMBER [BUILTIN\Administrators]"

	# Build Firewall Rules for SQL & AOG
	New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action allow 
	New-NetFirewallRule -DisplayName "SQL AG Endpoint" -Direction Inbound -Protocol TCP -LocalPort 5022 -Action allow 
	New-NetFirewallRule -DisplayName "SQL AG Load Balancer Probe Port" -Direction Inbound -Protocol TCP -LocalPort 59999 -Action allow 
			}
        GetScript = {@{Result = "ConfigureSql"}
		}
	}
  }
}