<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	08/04/2018 23:22
	 Created by:   	Arnaud Crampet 
	 Mail to: 		arnaud@crampet.net 
	 Organization: 	
	 Filename:     	Namaste.ps1
	 Operatin system: Windows 10 or windows server 2016  
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

# Get execution path
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Get generique Xml configuration file
$XmlConfigFile = "$ScriptDirectory\..\config\generic.xml"

# Loading basic configuration file ( profile and parameter for build)
[xml]$XmlDocument = Get-Content -Path $XmlConfigFile

# Gathering base directory definitions
$Global:CastBasePath = $XmlDocument.RootConfig.ScriptEnvVars.BasePath
$Global:CastLogPath  = $Global:CastBasePath + "\" + $XmlDocument.RootConfig.ScriptEnvVars.SubDirs.CentralLogDir
$Global:CastDataPath = $Global:CastBasePath + "\" + $XmlDocument.RootConfig.ScriptEnvVars.SubDirs.CentralDataDir
$Global:CastLibPath  = $Global:CastBasePath + "\" + $XmlDocument.RootConfig.ScriptEnvVars.SubDirs.CentralLibDir

# Gathering generated fil for sourcing duty
$Global:Sfile = $Global:CastBasePath + "\" + $XmlDocument.RootConfig.ScriptEnvVars.Inits
Clear-Host
Write-Host "Root script directory		   : $Global:CastBasePath"
Write-Host "Log directory 		           : $Global:CastLogPath"
Write-Host "Lib directory 		           : $Global:CastLibPath"
Write-Host "Data directory 		           : $Global:CastDataPath"
write-host "Sourcing Engine                : $Global:Sfile"

Write-Host "Sourcing base CAST engine : $Global:Sfile"
try
{
	. ("$Global:Sfile")
}
catch
{
	Write-Host "Error while loading supporting PowerShell Scripts"
}

# Starting main 
function test-CAST-LOG-MsgDisplay
{
	MsgDisplay "ceci est un message de test vert"   "1"  $false
	MsgDisplay "ceci est un message de test jaune"  "2"  $false
	MsgDisplay "ceci est un message de test orange" "3"  $false
	MsgDisplay "ceci est un message de test rouge"  "4"  $false
	
	MsgDisplay "ceci est un message de test vert avec sortie" "1"  $true
}

function test-CAST-LOG-MsgDisplay
{
	MsgDisplay ("ceci est un message de test vert")   ("1")  ($false)
	MsgDisplay "ceci est un message de test jaune"  "2"  $false
	MsgDisplay "ceci est un message de test orange" "3"  $false
	MsgDisplay "ceci est un message de test rouge"  "4"  $false
	
	#MsgDisplay "ceci est un message de test vert avec sortie" "1"  $true
}

function test-CAST-DISPLAY-Write-Menu-Header
{
	MsgDisplay "Test Write-Menu-Header without options"   "1"  $false
	Write-Menu-Header
	EnterToContinue
	MsgDisplay "Test Write-Menu-Header with options"   "1"  $false
	Write-Menu-Header "This is a menu title"
	EnterToContinue
}

function lauch-test
{
	test-CAST-LOG-MsgDisplay
	test-CAST-DISPLAY-Write-Menu-Header
}

lauch-test