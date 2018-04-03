#####                                                          ####
###                                                             ###
##                                                               ##
# Author           : Arnaud Crampet                               #
# Mail             : Arnaud@crampet.net                           #
# Usage            : Not Another MAnagment Scripting Tool         #
#                    for azurE NAMASTE                            #
# Operating system : Windows 10 or windows server 2016            #
###################################################################
# Configuration itrmps
$XmlConfigFile = "D:\arnau\Documents\GitHub\CAST-Windows\Azure-scripts\XmlTemplate.xml"
$Global:subscriptionId = ""
$SessionState = fasle 

# Loadin basic configuration file ( profile and parameter for build)


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


function Main
{
Write-Menu-Header "What did you want to do now ?"
Put-Spacer
Write-Host "1  Build new azure elements..."
Write-Host "2  Delete Some azure elements..."
Write-Host "3  List some elements..."
Write-Host "Q: Press 'Q' to quit."
Put-Spacer
$selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' { $Global:CertDuration = '1'} 
         '2' { $Global:CertDuration = '3'}
         '3' { $Global:CertDuration = '6'}
         'Q' { exit 0 }
     }
EnterToContinue $Global:CertDuration
}

function Main
{
Write-Menu-Header "Build"
Put-Spacer
Write-Host "1  Build one element"
Write-Host "2  Build standadized structures"
Write-Host "3  List Standardized structures"
Write-Host "Q: Press 'Q' to quit."
Write-Host "X: Press 'X' to go back main."
Put-Spacer
$selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' { Set-onelement             } 
         '2' { Set-GeneriqueStructure    }
         '3' { Get-AvaillableStdElements }
         'Q' { exit 0 }
     }
EnterToContinue $Global:CertDuration
}

function Set-onelement
{
Write-Menu-Header "Build"
Put-Spacer
Write-Host "1  Ressource Group"
Write-Host "2  Storage Account"
Write-Host "3  Virtual Machine"
Write-Host "3  Network Security Group"
Write-Host "4  Virtual gateway (vpn)"
Write-Host "Q: Press 'Q' to quit."
Write-Host "X: Press 'X' to go back main."
Put-Spacer
$selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' { Create-Rgroup                  } 
         '2' { Create-StorageAccount          }
         '3' { Create-VirtualMachine          }    
         '4' { Create-NetworkSecurityGroup    }
         '5' { Create-VirtualNetworkGateway   }
         'Q' { exit 0 }
     }
EnterToContinue $Global:CertDuration
}

function Set-AsureLocation
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

function Create-StorageAccount
{
Select-RessourceGroup


$StorageAccount = New-AzureRmStorageAccount -StorageAccountName $StorageAccountName -Type 'Standard_LRS' -ResourceGroupName $StorageResourceGroupName -Location "$ResourceGroupLocation"



}



[xml]$XmlDocument = Get-Content -Path $XmlConfigFile


$XmlDocument.RootManagment.TypePf.Rgroups.obj  

function Set-AzureSession 
{
# Sign-in with Azure account credentials

Login-AzureRmAccount

# Select Azure Subscription

$Global:subscriptionId = (Get-AzureRmSubscription |  Out-GridView ` -Title "Select an Azure Subscription ..." ` -PassThru).SubscriptionId

Select-AzureRmSubscription  -SubscriptionId $Global:subscriptionId

}


function Create-Rgroup 
{

New-AzureRmResourceGroup -Name $resourceGroup -Location $location

}


#Set-AzureSession
Write-Host "Please Wait until gathring of azure location is finished"
$Global:AzureListLocations = Get-AzureRmLocation


Set-AsureLocation
Select-RessourceGroup