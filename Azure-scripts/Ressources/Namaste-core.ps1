#####                                                          ####
###                                                             ###
##                                                               ##
# Author           : Arnaud Crampet                               #
# Mail             : Arnaud@crampet.net                           #
# Usage            : Not Another MAnagment Scripting Tool         #
#                    for azurE NAMASTE - core functions           #
# Operating system : Windows 10 or windows server 2016            #
###################################################################
# Configuration itrmps

## Print functions 

function Write-Menu-Header 
{
 param (
        [string]$Title = 'My Menu'
    )
   Clear-Host
    Write-Host "================ $Title ================"
    Write-Host ""
 }   

function Put-Spacer
{
Write-Host ""
Write-Host "------------------------------------------------"
Write-Host ""
}

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

function Set-AzureSession 
{
# Sign-in with Azure account credentials

Login-AzureRmAccount

# Select Azure Subscription

$Global:subscriptionId = (Get-AzureRmSubscription |  Out-GridView ` -Title "Select an Azure Subscription ..." ` -PassThru).SubscriptionId

Select-AzureRmSubscription  -SubscriptionId $Global:subscriptionId

}


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

function Select-SorageAccRedudency 
{
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