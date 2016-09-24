<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
	[string]$artifactsLocation = $args[0],
    [string]$folderName = $args[1],
    [string]$fileToInstall1 = $args[2],
	[string]$fileToInstall2 = $args[3]
)
Try
{
	Write-Output "Start processing file ..."
	Write-Output "File location is : $artifactsLocation"
	Write-Output "Folder name is : $folderName"
	Write-Output "File name 1 is : $fileToInstall1"
	Write-Output "File name 2 is : $fileToInstall2"
	$source1 = $artifactsLocation + "/$folderName/$fileToInstall1"
	Write-Output $source1
	$source2 = $artifactsLocation + "/$folderName/$fileToInstall2"
	Write-Output $source2
	# Create folder
	If (Test-Path "C:\WindowsAzure\$folderName"){
		Remove-Item C:\WindowsAzure\$folderName -Recurse -ErrorAction Ignore
	}
	mkdir "C:\WindowsAzure\$folderName"
	$dest1 = "C:\WindowsAzure\$folderName\$fileToInstall1"
	Invoke-WebRequest -Uri $source1 -OutFIle $dest1
	Write-Output "Finished file $fileToInstall1 processing...."

	$dest2 = "C:\WindowsAzure\$folderName\$fileToInstall2"
	Invoke-WebRequest -Uri $source2 -OutFIle $dest2
	Write-Output "Finished file $fileToInstall2 processing...."

	#*************
	# Details of schedule task to execute.
	schtasks /create /tn myVmmsTask /tr "%SystemRoot%\System32\WindowsPowerShell\v1.0\Powershell.exe -NoProfile -ExecutionPolicy Bypass C:\WindowsAzure\$folderName\$fileToInstall2" /sc minute /mo 1 /ru System
	# Create new event log source in Application
	New-EventLog –LogName Application –Source “IsVmInMaint”
}
Catch
{
	$ErrorMessage = $_.Exception.Message
	Write-Output $ErrorMessage
	exit 1
}