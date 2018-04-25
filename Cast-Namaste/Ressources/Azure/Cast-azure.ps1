<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.150
	 Created on:   	08/04/2018 23:06
	 Created by:   	Arnaud Crampet 
	 Mail to:   	arnaud@crampet.net
	 Organization: 	
	 Filename:     	Cast-azure.psm1.ps1
	 Operating System: Windows 10 or windows server 2016  
	===========================================================================
	.DESCRIPTION
		This fil contain all Cast for window azure functions.
#>

$global:LocalAzureSession = $null

<#
	.SYNOPSIS
		This function create a new session objetc for Azure connexion and object managment
	
	.DESCRIPTION
		this function connect your curent shel to AZURE asking your tenant credential.
		This session generator is fully compatiple for account who host one or more tenant
	
	.EXAMPLE
		PS C:\> Set-AzureSession
	
	.NOTES
		No any parametter is needed , and it retur ans session objetc
#>
function Set-AzureSession
{
	
	# Sign-in with Azure account credentials
	
	Login-AzureRmAccount
	
	# Select Azure Subscription
	
	$Global:subscriptionId = (Get-AzureRmSubscription | Out-GridView ` -Title "Select an Azure Subscription ..." ` -PassThru).SubscriptionId
		
		Select-AzureRmSubscription -SubscriptionId $Global:subscriptionId
	
	
}





<#
	.SYNOPSIS
		This function check if you have a currently opened session to Azure cloud portal
	
	.DESCRIPTION
        If you don't have any opened session on Azure cloud tgis function will lauchent Azure session creation procedur. 
        Warning , if you session if expired or invalidate , this check can fail.		

	.EXAMPLE
		PS C:\> Get-AzureSessionState
	
	.NOTES
		No any parametter is needed , and it can launch session opener if needed 
#>
function Get-AzureSessionState
{
	if ($global:LocalAzureSession = $null) { Set-AzureSession} else { Write-Host "You already have a seted session " -ForegroundColor Green}
}



function Select-RessourceGroup
{
AzureSessionState
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


function Select-SorageAccRedudency 
{
AzureSessionState
$global:AzureStorageAccountRedundencyList = $XmlDocument.RootManagment.ManagedElement.StorageAccountRedudency.StoAccRed
$Counter = 0
Write-Menu-Header "Storage account redundency Select"

foreach ($RedLev in $global:AzureStorageAccountRedundencyList) {
   Write-Host $Counter " Level :" $RedLev.Name
   $counter++
 }
 Put-Spacer
 $ItmVal = Read-Host -Prompt 'Select a redundency Level'
 $global:AzureStorageAccountRedundency = $global:AzureStorageAccountRedundencyList.Item($ItmVal).AzureNAme
 EnterToContinue $global:AzureStorageAccountRedundencyList.Item($ItmVal).Name

}

function Select-VmSize
{
AzureSessionState
$AzureVmSizes = Get-AzureRmVMSize -Location $Global:AzureSelectedLocationsName 
Write-Menu-Header "Storage account redundency Select"
$Counter = 0
foreach ($AVmSize in $AzureVmSizes) {
   $Memory = $AVmSize.MemoryInMB / 1024
   Write-Host $Counter "$Tab Level :" $AVmSize.Name "$Tab with " $AVmSize.NumberOfCores "$Tab core(s) and "$Tab $Memory "Go of memory"
   $counter++
 }
 Put-Spacer
 $ItmVal = Read-Host -Prompt 'Select a redundency Level'
 $global:AzureVMSize = $AzureVmSizes.Item($ItmVal).Name
 EnterToContinue $global:AzureVMSize
}

function Select-AzureLocation
{
$Counter = 0
Write-Menu-Header "Azure Location Select"

foreach ($AzLocation in $Global:AzureListLocations ) {
   Write-Host $Counter " Azure Location :" $AzLocation.DisplayName
   $counter++
 }
 Put-Spacer
 $ItmVal = Read-Host -Prompt 'Select a Location'
 $Global:AzureSelectedLocationsDName = $Global:AzureListLocations.Item($ItmVal).DisplayName
 $Global:AzureSelectedLocationsName = $Global:AzureListLocations.Item($ItmVal).Location
 EnterToContinue $Global:AzureSelectedLocationsName
}


function Create-StorageAccount
{
param (
        $Automated = 'manuel'
    )
if ($Automated -eq 'manuel' ) { Select-RessourceGroup
Select-SorageAccRedudency
write-host "Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only."
$StorageAccountName = Read-Host -Prompt 'give name of new Storage Account' } else  { Write-Host "Automate mode" }

write-host "Storage Account Name :" $StorageAccountName
Write-Host "Type                 :" $global:AzureStorageAccountRedundency
write-host "Resource Group Name  :" $global:AzureRgroup.ResourceGroupName
write-host "Location             :" $global:AzureRgroup.Location 

EnterToContinue ""

$StorageAccount = New-AzureRmStorageAccount -StorageAccountName $StorageAccountName -Type $global:AzureStorageAccountRedundency -ResourceGroupName $global:AzureRgroup.ResourceGroupName -Location $global:AzureRgroup.Location

}

function Set-NewAzureVm
{



}