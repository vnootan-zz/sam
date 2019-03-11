Start-Transcript -Path C:\postinstallation.Log

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
Get-AzureStorageBlobContent -Blob sqldetail.txt  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
write-host ' copied text file from azure blob....'; [datetime]::Now

write-host ' copying solarwindinstaller  from azure blob....'; [datetime]::Now
Get-AzureStorageBlobContent -Blob Solarwinds-Orion-SAM-6.6.1-OfflineInstaller.exe  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
write-host ' copied solarwindinstaller  from azure blob....'; [datetime]::Now


#Invoke-WebRequest -Uri "https://installer.solarwinds.com/Download/156b7586-4cc0-4867-9f22-f81eeefcdc57/Solarwinds-Orion-SAM.exe" -OutFile "C:\Windows\Temp\Solarwinds-Orion-SAM.exe"

#Invoke-WebRequest -Uri "https://drive.google.com/uc?export=download&id=1d8MpgDTUdEzKeWZjtVjO-heVDLe1FGI4" -OutFile "C:\Windows\Temp\installer.xml"


cd "C:\Windows\Temp"

write-host ' starting installation solarwindinstaller....'; [datetime]::Now
.\Solarwinds-Orion-SAM-6.6.1-OfflineInstaller.exe /s /ConfigFile="C:\Windows\Temp\installer.xml"
write-host ' installation completed solarwindinstaller....'; [datetime]::Now

while(1)
{
$Solarwinds = Get-Process Solarwinds-Orion-SAM-6.6.1-OfflineInstaller -ErrorAction SilentlyContinue
if ($Solarwinds) {
   Write-Host " process running...sleep 5 sec"
  Sleep 5
  Remove-Variable Solarwinds
  continue;
}
else {
	write-host "process end"
	Remove-Variable Solarwinds
    break;
}
}
exit 1

Stop-Transcript
