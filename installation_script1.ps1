param
(
	[string]$typeOfInstallation,
	[string]$productsToInstall,
	[string]$dbServerName, 
	[string]$databaseName, 
	[string]$dbUserName, 
	[string]$dbPassword
)

Start-Transcript -Path C:\postinstall.Log

if($typeOfInstallation -eq "false" -OR $typeOfInstallation -eq "False" -OR $typeOfInstallation -eq "FALSE") {
	[bool]$isStandard = $false
}
else {
	[bool]$isStandard = $true
}

write-host ' installing NuGet module....'; [datetime]::Now
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
write-host ' installed NuGet module....'; [datetime]::Now

write-host ' installing azure module....'; [datetime]::Now
Install-Module -Name Azure,AzureRM -force
write-host ' installed azure module....'; [datetime]::Now

$s_name = "vinayblob1"
$pass = "MOSlYQq3cMy+ZsZtqUmaHBL3gZ2PQshjmyKimPLBupDYrq9EWnDcujXNY3XyPUUf3g/EcFLMPnZbdt4vGzZ5DA=="
$ctx = new-azurestoragecontext -StorageAccountName $s_name -StorageAccountKey $pass

write-host 'coping text file from azure blob....'; [datetime]::Now
Get-AzureStorageBlobContent -Blob installers_list.json -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx

if($isStandard)
{
	Get-AzureStorageBlobContent -Blob standard.xml -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
}
else
{
	Get-AzureStorageBlobContent -Blob express.xml -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx	
}
#Get-AzureStorageBlobContent -Blob sqldetail.txt  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
#Remove-AzureStorageBlob -Blob sqldetail.txt -Container vinay-storage-account-container -Context $ctx
write-host ' copied text file from azure blob....'; [datetime]::Now

write-host 'reading installer name from json file....'; [datetime]::Now
$installers_list_object = Get-Content 'C:\Windows\Temp\installers_list.json' | Out-String | ConvertFrom-Json
$installer_name = $installers_list_object.$productsToInstall
write-host 'got the installer name from json file....'; [datetime]::Now

write-host ' copying solarwindinstaller  from azure blob....'; [datetime]::Now
Get-AzureStorageBlobContent -Blob $installer_name  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
write-host ' copied solarwindinstaller  from azure blob....'; [datetime]::Now

$filePath = 'C:\Windows\Temp\express.xml'
if($isStandard)
{
	$filePath = 'C:\Windows\Temp\standard.xml'
}

$xml=New-Object XML
$xml.Load($filePath)

$node=$xml.SilentConfig.InstallerConfiguration
$node.ProductsToInstall=$productsToInstall 

if($isStandard)
{
	$node=$xml.SilentConfig.Host.Info.Database	
	$node.ServerName=$dbServerName
	$node.DatabaseName=$databaseName
	$node.User=$dbUserName    
	$node.UserPassword=$dbPassword
}

$xml.Save($filePath)

cd "C:\Windows\Temp"
write-host ' starting installation solarwindinstaller....'; [datetime]::Now

New-Item C:\Windows\Temp\installer.ps1 -ItemType file
Add-Content 'C:\Windows\Temp\installer.ps1' $installer_name" /s /ConfigFile=""$filePath"""
.\installer.ps1

write-host ' installation started solarwindinstaller....'; [datetime]::Now

$process_name = $installer_name.Substring(0,$installer_name.LastIndexOf('.'))
while(1)
{
	$Solarwinds = Get-Process $process_name -ErrorAction SilentlyContinue
	if ($Solarwinds) {
	  Sleep 5
	  Remove-Variable Solarwinds
	  continue;
	}
	else {
		write-host "process completed"
		Remove-Variable Solarwinds
	    break;
	}
}
#exit 1
Stop-Transcript
