<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	09/04/2018 15:40
	 Created by:   	Arnaud Crampet 
	 Mail to:       arnaud@crampet.net
	 Organization: 	
	 Filename:     	Cast-Menu.ps1
     Operating system: Windows 10 or windows server 2016
	===========================================================================
	.DESCRIPTION
		This file will contain all généric function on how to build a menu in powershell.
#>

function Write-Menu-Header
{
	param (
		[string]$Title = 'My Menu'
	)
	Clear-Host
	Write-Host "================ $Title ================" -ForegroundColor Green
	Write-Host ""
}  