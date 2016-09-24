<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
	[string]$artifactsLocation = $args[0],
    [string]$folderName = $args[1],
    [string]$fileToInstall = $args[2]
)
Try
{
	Write-Output "Start processing file ..."
	Write-Output "File location is : $artifactsLocation"
	Write-Output "Folder name is : $folderName"
	Write-Output "File name is : $fileToInstall"
	$source = $artifactsLocation + "/$folderName/$fileToInstall"
	Write-Output $source
	# Create folder
	If (Test-Path "C:\WindowsAzure\$folderName"){
		Remove-Item C:\WindowsAzure\$folderName -Recurse -ErrorAction Ignore
	}
	mkdir "C:\WindowsAzure\$folderName"
	$dest = "C:\WindowsAzure\$folderName\$fileToInstall"
	Invoke-WebRequest -Uri $source -OutFIle $dest
	Write-Output "Finished file processing...."
}
Catch
{
	$ErrorMessage = $_.Exception.Message
	Write-Output $ErrorMessage
	exit 1
}