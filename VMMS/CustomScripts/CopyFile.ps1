<# Custom Script for Windows to install a file from Azure Storage using the staging folder created by the deployment script #>
param (
	[string]$artifactsLocation,
    [string]$folderName,
    [string]$fileToInstall
)
Try
{
	$source = $artifactsLocation + "\$folderName\$fileToInstall"
	$dest = "C:\WindowsAzure\$folderName\$fileToInstall"
	Invoke-WebRequest $source -OutFile $dest
	#Write-Output "SAS token is : $artifactsLocationSasToken"
}
Catch
{
	$ErrorMessage = $_.Exception.Message
	exit 1
}