Start-Transcript -Path C:\sqldetail.Log

write-host ' installing NuGet module....'; [datetime]::Now
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
write-host ' installed NuGet module....'; [datetime]::Now

write-host ' installing azure module....'; [datetime]::Now
Install-Module -Name Azure,AzureRM -force
write-host ' installed azure module....'; [datetime]::Now

New-Item C:\Windows\Temp\sqldetail.txt -ItemType file
Add-Content 'C:\Windows\Temp\sqldetail.txt' 'DatabaseName:NewSolarWindsOrionDB'
Add-Content 'C:\Windows\Temp\sqldetail.txt' 'ServerName:10.112.74.141\RTC'
Add-Content 'C:\Windows\Temp\sqldetail.txt' 'UserPassword:Vinay@123'
Add-Content 'C:\Windows\Temp\sqldetail.txt' 'User:admin'

$s_name = "vinayblob1"
$pass = "ryhREPlM4WP8W6J2c7m0PAR4b3e6+R0fmKSJm8CNjLL6fIl5CR5zDhYGgCUGNhku/bfWrtZEIn1BEpw5PLg76g=="
$ctx = new-azurestoragecontext -StorageAccountName $s_name -StorageAccountKey $pass

write-host ' coping text file to azure blob....'; [datetime]::Now
Set-AzureStorageBlobContent -File C:\Windows\Temp\sqldetail.txt -Container vinay-storage-account-container -BlobType "Block" -Context $ctx
write-host ' copied text file to azure blob....'; [datetime]::Now

Stop-Transcript
