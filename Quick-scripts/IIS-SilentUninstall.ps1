<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	12/04/2018 14:28
	 Created by:   	Arnaud Crampet
	 Mail TO:		arnaud@crampet.net
	 Organization: 	
	 Filename:     	IIS-SilentUnInstall.ps1
	 Opérating System: Windows 2012 server ( datacenter ) R2
	===========================================================================
	.DESCRIPTION
		This script will UNinstall IIS ans all needed deps on your server
#>

$Global:ArrayApp = @("Web-Server", "Web-WebServer", "Web-Security", "Web-Default-Doc", "Web-Dir-Browsing", "Web-Http-Errors", "Web-Static-Content", "Web-Http-Logging", "Web-Filtering", "Web-Stat-Compression", "Web-Net-Ext45", "Web-ISAPI-Ext", "Web-ISAPI-Filter", "Web-Asp-Net45", "add-windowsfeature", "Web-Performance")

function Get-Error
{

	if ($? -eq $true) { Write-Host " [ OK ] " -ForegroundColor Green  }
	else { Write-Host " [ ERROR ] " -ForegroundColor Red }
}

function Import-IIS-ps
{
	Write-Host "Getting powershell extention for server managment		"  -NoNewline
	import-module servermanager -ErrorAction "silentlycontinue"
	Get-Error
}

function Set-IIS-BUNINSTALL
{
		
	foreach ($Items in $ArrayApp)
	{
		Write-Host "Removing component : $Items		"  -NoNewline
		Uninstall-WindowsFeature $Items -ErrorAction "silentlycontinue"
		Get-Error
	}
	
	
	 
	
	
}


function main
{
	Import-IIS-ps
	Set-IIS-BUNINSTALL
	
}

main