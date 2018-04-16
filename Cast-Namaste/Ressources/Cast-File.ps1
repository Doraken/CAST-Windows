<#	
	.NOTES
	===========================================================================
	 Created with: 	Powershell ISE
	 Created on:   	15/04/2018 23:22
	 Created by:   	Arnaud Crampet 
	 Mail to: 		arnaud@crampet.net 
	 Organization: 	
	 Filename:     	Cast-File.ps1
	 Operatin system: Windows 10 or windows server 2016  
	===========================================================================
	.DESCRIPTION
		Common file managment functions, from CAST.
#>


<#
	.SYNOPSIS
		this function is used to send back file name from full path string
	
	.DESCRIPTION
		juste split path string to get back file name
	
	.PARAMETER FileString
		FileString is used to strore full path string.
	
	.EXAMPLE
		PS C:\> get-BaseFilenamefromString ["c:<_temp<_toto.txt"]
	
	.NOTES
		The var in call is mandatory .
#>
function get-BaseFilenamefromString
{
param
	(
		[parameter(Mandatory = $true)]
		[String[]]$FileString
	)

    $LString = $FileString.Split("\")
    $Lindex = $LString.count - 1
    $LString.GetValue($Lindex)


}

