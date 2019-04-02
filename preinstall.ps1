
Start-Transcript -Path C:\preinstall.Log

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
Get-AzureStorageBlobContent -Blob installer.xml  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
#Get-AzureStorageBlobContent -Blob sqldetail.txt  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
#Remove-AzureStorageBlob -Blob sqldetail.txt -Container vinay-storage-account-container -Context $ctx
write-host ' copied text file from azure blob....'; [datetime]::Now

write-host ' copying solarwindinstaller  from azure blob....'; [datetime]::Now
Get-AzureStorageBlobContent -Blob Solarwinds-Orion-SAM-6.6.1-OfflineInstaller.exe  -Container vinay-storage-account-container -Destination C:\Windows\Temp\ -Context $ctx
write-host ' copied solarwindinstaller  from azure blob....'; [datetime]::Now

#Copying sql details to installer file
$newstreamreader = New-Object System.IO.StreamReader("C:\Windows\temp\sqldetail.txt")

$filePath = 'C:\Windows\temp\installer.xml'
$xml=New-Object XML
$xml.Load($filePath)
$node=$xml.SilentConfig.Host.Info.Database

$eachlinenumber = 1
while (($readeachline =$newstreamreader.ReadLine()) -ne $null)
{   
    Write-Host $readeachline.Substring($readeachline.IndexOf(":")+1)
    
    if($readeachline.ToLower().Contains('databasename'))
        {
            $node.DatabaseName=$readeachline.Substring($readeachline.IndexOf(":")+1)
        }
    elseif($readeachline.ToLower().Contains('servername'))
        {
            $node.ServerName=$readeachline.Substring($readeachline.IndexOf(":")+1)
        }     
    elseif($readeachline.ToLower().Contains('userpassword'))
        {
            $node.UserPassword=$readeachline.Substring($readeachline.IndexOf(":")+1)
        }
    elseif($readeachline.ToLower().Contains('user'))
        {
            $node.User=$readeachline.Substring($readeachline.IndexOf(":")+1)
        }

    $eachlinenumber++
}

$xml.Save($filePath)
$newstreamreader.Dispose()

Stop-Transcript
