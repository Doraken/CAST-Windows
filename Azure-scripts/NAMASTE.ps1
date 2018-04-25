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
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
try {
    . ("$ScriptDirectory\ressources\Namaste-core.ps1")
    . ("$ScriptDirectory\ressources\Namaste-print.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}

$XmlConfigFile = "D:\arnau\Documents\GitHub\CAST-Windows\Azure-scripts\XmlTemplate.xml"
$Global:subscriptionId = ""
$Tab = [char]9

# Loadin basic configuration file ( profile and parameter for build)
[xml]$XmlDocument = Get-Content -Path $XmlConfigFile

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



function Create-inRgroup 
{
$resourceGroupNAme = Read-Host -Prompt 'give name of new ressource group'
Select-AzureLocation
$Global:AzureSelectedLocationsName
Create-Rgroup "$resourceGroupNAme" "$Global:AzureSelectedLocationsName"

}

function Create-Rgroup 
{
(
        [string]$resourceGroupNAme
    )
    Write-Host "Ressource group name     : " $resourceGroupNAme
    Write-Host "Ressource group location : " $Global:AzureSelectedLocationsName
New-AzureRmResourceGroup -Name $resourceGroupNAme -Location $Global:AzureSelectedLocationsName

}



Function Create-Vnet
{
(
        [string]$VnetRange
    )
    $VnetBrange =  $VnetBrange + ".0/24"
# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name default -AddressPrefix $VnetBrange

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup -Location $location  -Name MYvNET -AddressPrefix -Subnet $subnetConfig


}

function set-newBubble 
{
$global:AzureGlobalBtype = $XmlDocument.RootManagment.ManagedElement.StorageAccountRedudency.StoAccRed
$Counter = 0
Write-Menu-Header "Please select what kind of bubble we sill deploy"

foreach ($RedLev in $global:AzureStorageAccountRedundencyList) {
   Write-Host $Counter " Level :" $RedLev.Name
   $counter++
 }
 Put-Spacer
 $ItmVal = Read-Host -Prompt 'Select a redundency Level'
 $global:AzureStorageAccountRedundency = $global:AzureStorageAccountRedundencyList.Item($ItmVal).AzureNAme
 EnterToContinue $global:AzureStorageAccountRedundencyList.Item($ItmVal).Name



}




## OK VALIDE

Set-AzureSession
Write-Host "Please Wait until gathring of azure location is finished"
$Global:AzureListLocations = Get-AzureRmLocation
Select-AzureLocation
Create-StorageAccount manuel 
# Create-inRgroup

#Create-StorageAccount
#Select-VmSize