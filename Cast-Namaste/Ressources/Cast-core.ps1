<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	08/04/2018 22:18
	 Created by:   	Arnaud Crampet
	 Mail to:   	arnaud@crampet.net
	 Organization: 	
	 Filename:     	Cast-Core.psm1
	 Operating system : Windows 10 or windows server 2016            
	===========================================================================
	.DESCRIPTION
		This file contain all cor function used bys cast windows framework
#>


## Print functions 

function Write-Menu-Header
{
	
 param (
        [string]$Title = 'My Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================" -ForegroundColor Green
    Write-Host ""                                         -ForegroundColor Green
 }   

<#
	.SYNOPSIS
		just call Put-Spacer function to print defined space on screen.
	
	.DESCRIPTION
		Prin on line, a screen separator and a new line.
	
	.EXAMPLE
		PS C:\> Put-Spacer
	
	.NOTES
		Don't return anything but scree display.
#>
function Put-Spacer
{
Write-Host ""
Write-Host "------------------------------------------------"
Write-Host ""
}

<#
	.SYNOPSIS
		this function is used to create a généric stop point with potentialy tunned display.
	
	.DESCRIPTION
		May print a value of a selected var ( passed as arg on call) and wait an enter key hit to continue.
	
	.PARAMETER Value
		Value ( not realy original args name i know ) may permite to display a selecter value to validate .
	
	.EXAMPLE
		PS C:\> EnterToContinue ["myVar"]
	
	.NOTES
		The var in call is optional .
#>
function EnterToContinue
{
 param (
        [string]$Value = 'Dummy'
    )
 
 Put-Spacer
 Write-Host "you choose : [ $Value ] "
 Put-Spacer
 $dummy = Read-Host -Prompt 'Press enter to continue or CTRL+C to end'
 Clear-Host
 }

## Authentification functions : 




## Listing functions 

function Select-RessourceGroup
{
$global:AzureRgroupList = Get-AzureRmResourceGroup
$Counter = 0
Write-Menu-Header "ressource group Select"

foreach ($Rgroup in $global:AzureRgroupList) {
   Write-Host $Counter " Ressource Groupe :" $Rgroup.ResourceGroupName
   $counter++
 }
 Put-Spacer
 $ItmVal = Read-Host -Prompt 'Select a ressource group'
 $global:AzureRgroupName = $global:AzureRgroupList.Item($ItmVal).ResourceGroupName
 $global:AzureRgroup = Get-AzureRmResourceGroup -name $global:AzureRgroupName
 EnterToContinue $global:AzureRgroupName
}

