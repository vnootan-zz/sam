Start-Transcript -Path C:\preinstall.Log

write-host ' installing NuGet module....'; [datetime]::Now
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
write-host ' installed NuGet module....'; [datetime]::Now

write-host ' installing azure module....'; [datetime]::Now
Install-Module -Name Azure,AzureRM -force
write-host ' installed azure module....'; [datetime]::Now

$s_name = "vinayblob1"

$pass = "ryhREPlM4WP8W6J2c7m0PAR4b3e6+R0fmKSJm8CNjLL6fIl5CR5zDhYGgCUGNhku/bfWrtZEIn1BEpw5PLg76g=="

$ctx = new-azurestoragecontext -StorageAccountName $s_name -StorageAccountKey $pass

write-host 'coping text file from azure blob....'; [datetime]::Now
Get-AzureStorageBlobContent -Blob installer.xml  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
write-host ' copied text file from azure blob....'; [datetime]::Now

write-host ' copying solarwindinstaller  from azure blob....'; [datetime]::Now
Get-AzureStorageBlobContent -Blob Solarwinds-Orion-SAM-6.6.1-OfflineInstaller.exe  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
write-host ' copied solarwindinstaller  from azure blob....'; [datetime]::Now

$ResourceGroupName = "testResourceGroup"
$CustVMname = "testvm"
$customscriptname = "preinstall.ps1"

Remove-AzurermVMCustomScriptExtension -ResourceGroupName $ResourceGroupName -VMName $CustVMname –Name $customscriptname -Force

Stop-Transcript
