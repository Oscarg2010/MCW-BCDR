<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - ClusterUpdateSQLVM1.ps1
 
.What calls this script?
 - Run this script on SQLVM1 to update Windows Failover Cluster, but only after
   ClusterCreateSQLVM1.ps1 has be successfully executed and the steps to establish
   the SQL Always On Availability Group has been completed.
   
.What does this script do?  
 - This scrip creates the Windows Failover Client IP probes that are required to determine
   which nodes are online.
#>

$ClusterNetworkName = "Cluster Network 1"
$IPResourceName = "BCDRAOG_10.0.2.100"
$ILBIP = "10.0.2.100"
Import-Module FailoverClusters
Get-ClusterResource $IPResourceName | Set-ClusterParameter -Multiple @{"Address"="$ILBIP";"ProbePort"="59999";"SubnetMask"="255.255.255.255";"Network"="$ClusterNetworkName";"EnableDhcp"=0}
Stop-ClusterResource -Name $IPResourceName
Start-ClusterResource -Name "BCDRAOG"

$ClusterNetworkName = "Cluster Network 2"
$IPResourceName = "BCDRAOG_172.16.2.100"
$ILBIP = "172.16.2.100"
Import-Module FailoverClusters
Get-ClusterResource $IPResourceName | Set-ClusterParameter -Multiple @{"Address"="$ILBIP";"ProbePort"="59999";"SubnetMask"="255.255.255.255";"Network"="$ClusterNetworkName";"EnableDhcp"=0}
Stop-ClusterResource -Name $IPResourceName
Start-ClusterResource -Name "BCDRAOG"