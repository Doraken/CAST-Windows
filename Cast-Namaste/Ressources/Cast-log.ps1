<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	08/04/2018 23:45
	 Created by:   	Arnaud Crampet
	 Mail to: 		arnaud@crampet.net
	 Organization: 	
	 Filename:     	Cast-log.ps1
	 Oparating system: Windows 10 or Windows server 2016 
	===========================================================================
	.DESCRIPTION
		this file contain all log functions.
#>

function MsgDisplay
{
	Param
	(
		[parameter(Mandatory = $true)]
		[String[]]$MessageVar,
		[parameter(Mandatory = $true)]
		[int[]]$TypeMsgVar,
		[parameter(Mandatory = $true)]
		[bool]$EmmergencyExit
	)
	
	switch ($TypeMsgVar)
	{
		'1' { $MessageColor = "Green" }
		'2' { $MessageColor = "Yellow" }
		'3' { $MessageColor = "Yellow -BackgroundColor DarkGreen"}
		'4' { $MessageColor = "Red" }
	}
	Write-Host "$MessageVar" -ForegroundColor $MessageColor
	if ( $Êmergency = $true ) { Write-Host "Je vais sortire", exit $TypeMsgVar}
	
	
}

