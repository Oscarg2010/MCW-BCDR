<# 
Microsoft Cloud Workshop: BCDR
.File Name
 - ClusterCreateSQLVM1.ps1
 
.What calls this script?
 - This is run manually on SQLVM1 to create the Windows Failover Cluster

.What does this script do?  
 - The Result will be a Cluster Named AOGCLUSTER running on the 10.0.2.99 IP Address
   with the hostname of AOGCLUSTER.CONTOSO.COM
 
 - Two Cluster Networks will be created Cluster Network 1 (10.0.2.0/24) and Cluster Network 2 (172.16.2.0/24)
#>
New-Cluster -Name AOGCLUSTER -Node SQLVM1,SQLVM2 -StaticAddress 10.0.2.99

Add-ClusterNode -Name SQLVM3
