<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	09/04/2018 15:43
	 Created by:   	Arnaud Crampet
	 Mail to:    	arnaud@crampet.net
	 Organization: 	
	 Filename:     	Cast-SrcMaker.ps1
	 Operating system: Windows 10 or Windows Server 2016 
	===========================================================================
	.DESCRIPTION
		this file contain functions to rebuild sourcer cach file .
#>

function Get-FileToSource
{
	(
		[parameter(Mandatory = $true)]
		[String[]]$FileTSrc
	)
	Write-Host "Soucing file : [ $file ]" -NoNewline
	. ($FileTSrc)
	Write-Host "   --> sourced OK "
	
}

function SourceAllLibs
{
	Param
	(
		[parameter(Mandatory = $true)]
		[String[]]$BaseDir
	)
	$ColFile = Get-ChildItem $BaseDir -filter *.ps1 -recurse
		
	Write-Host "Creating lines "
	
	foreach ($file in $ColFile)
		{
			if ($file.fullname -cnotlike $Global:CastGenSrc) { Get-FileToSource ($file.FullName) }
		}
	Write-Host "writing end"
	}
	
	
	
	
SourceAllLibs $Global:CastLibPath

#get-FolderChildsS "D:\arnau\Documents\GitHub\CAST-Windows\Cast-Namaste"