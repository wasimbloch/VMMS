# This sample uses the native powershell functionality for pulling dynamic metadata from a Windows Azure VM for incoming reboot events caused by 
# planned maintenance. When reboot is pending, it will log an event in the EventLog.
# Before executing it, the event needs to be registered in the EventLogger by executing: New-EventLog –LogName Application –Source “IsVmInMaint”
# curl http://169.254.169.254/metadata/v1/maintenance
# curl http://169.254.169.254/metadata/v1/InstanceInfo
Try
{
	# Details of schedule task to execute.
	# schtasks /create /tn myVmmsTask /tr "%SystemRoot%\System32\WindowsPowerShell\v1.0\Powershell.exe -NoProfile -ExecutionPolicy Bypass C:\Packages\Plugins\IsVmInMaint.ps1" /sc minute /mo 1 /ru System

	#New-EventLog –LogName Application –Source “IsVmInMaint”

	# $result=curl http://169.254.169.254/metadata/latest/maintenance | findstr "^Content" | findstr -i "reboot"
	$maintresult = Invoke-WebRequest -Uri ("http://169.254.169.254/metadata/latest/maintenance") -Method Get -UseBasicParsing
	$result = $maintresult | findstr "^Content" | findstr -i "reboot"
	if ($result) 
	{
		Write-EventLog -LogName Application –Source "IsVmInMaint" -EntryType Information –EventID 1 –Message "Incoming VM reboot"
	}
	else
	{
		Write-EventLog -LogName Application –Source "IsVmInMaint" -EntryType Information –EventID 1 –Message "No upcoming VM reboot"
	}
	$instanceresult = Invoke-WebRequest -Uri ("http://169.254.169.254/metadata/latest/InstanceInfo") -Method Get -UseBasicParsing
	$result=$instanceresult | findstr "^Content"
	if ($result) {Write-EventLog -LogName Application –Source "IsVmInMaint" -EntryType Information –EventID 1 –Message "VM Instance Info : $result"}
}
Catch
{
	$ErrorMessage = $_.Exception.Message
	exit 1
}