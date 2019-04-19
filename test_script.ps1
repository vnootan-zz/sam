param([string]$dbServerName, [string]$databaseName, [string]$dbUserName, [string]$dbPassword)
Start-Transcript -Path C:\Windows\Temp\sqldetaillog.Log

Write-Host "dbServerName: $dbServerName";
Write-Host "databaseName: $databaseName";
Write-Host "dbUserName: $dbUserName";
Write-Host "dbPassword: $dbPassword";

Stop-Transcript
