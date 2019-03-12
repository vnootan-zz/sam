Start-Transcript -Path C:\postinstall.Log

cd "C:\Windows\Temp"

.\Solarwinds-Orion-SAM-6.6.1-OfflineInstaller.exe /s /ConfigFile="C:\Windows\Temp\installer.xml"

while(1)
{
$Solarwinds = Get-Process Solarwinds-Orion-SAM-6.6.1-OfflineInstaller -ErrorAction SilentlyContinue
if ($Solarwinds) {
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
#exit 1

Stop-Transcript
