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

$global:ErrSeek = $false
$Tab = [char]9

# Add table from globhal section 
 #Create Table object
    $table = New-Object system.Data.DataTable “SourcingState”
     Write-Host "Alert"
    #Define Columns
    $col1 = New-Object system.Data.DataColumn Sourced_Lib,([string])
    $col2 = New-Object system.Data.DataColumn Status,([string])
   

    #Add the Columns
    $table.columns.add($col1)
    $table.columns.add($col2)


function Get-FileToSource
{
param
	(
		[parameter(Mandatory = $true)]
		[String[]]$FileTSrc
	)
   
    $LString = $FileTSrc.Split("\")
    $Lindex = $LString.count - 1
    $ShorFile = $LString.GetValue($Lindex)
    
   
    #Create a row
    $row = $table.NewRow()

    #Enter data in the row
    $row.Sourced_Lib = "$ShorFile" 


    #Clear-Host

	#Write-Host "Soucing file : [ $ShorFile ] $Tab $Tab $Tab $Tab" -NoNewline

    try 
    {	
        . ($FileTSrc)  -EV Err  -EA "SilentlyContinue"
	    $row.Status = "Sourced OK" 
    
    }
      catch 
    {
      $row.Status = "Error sourcing File"
      $global:ErrSeek = $true
    }
        $table.Rows.Add($row)
    $table | Format-Table 
    
    #Write-Host "   --> sourced OK " -ForegroundColor Green
	
}

function SourceAllLibs
{
	Param
	(
		[parameter(Mandatory = $true)]
		[String[]]$BaseDir
	)
	$ColFile = Get-ChildItem $BaseDir -filter *.ps1 -recurse
		
	
	foreach ($file in $ColFile)
		{
            Write-Host "Enc cour"
            $LfileVar = $file.FullName
            if ( $LfileVar -cnotlike $Global:CastGenSrc) { Get-FileToSource "$LfileVar" }
		}
    
	}
	
Write-Host "Sourcing engine " -ForegroundColor Green
SourceAllLibs $Global:CastLibPath
if ( $global:ErrSeek -eq $true ) { Write-Host "Error during sourcing file procedure , Exiting " -ForegroundColor Red 
        exit 4 } else { Write-Host "All file sourced successfully ... continue" -ForegroundColor Green }

