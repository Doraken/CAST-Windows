<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	08/04/2018 23:39
	 Created by:   	Arnaud Crampet
	 Mail To:		arnaud@crampet.net
	 Organization: 	
	 Filename:     	Azure-menu.ps1
	 Operating system: Windows 10 or Windows server 2016
	===========================================================================
	.DESCRIPTION
		This fil only contain come menu for Azure managment function .
#>




function Main
{
	Write-Menu-Header "Welcome to NAMASTE"
	Put-Spacer
	Write-Host "1  Interact with azure"
	Write-Host "2  Interact with a computer"
	Write-Host "3  Navigate in configuration"
	Write-Host "Q: Press 'Q' to quit."
	Put-Spacer
	$selection = Read-Host "Please make a selection"
	switch ($selection)
	{
		'1' { Mnu-Azure }
		'2' { Mnu-Computer }
		'3' { Mnu-Configuration }
		'Q' { exit 0 }
	}
	EnterToContinue $Global:CertDuration
}