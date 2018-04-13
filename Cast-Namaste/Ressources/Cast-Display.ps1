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

## Print functions 

function Write-Menu-Header 
{
 param (
        [string]$Title = 'My Menu'
    )
   Clear-Host
    Write-Host "================ $Title ================" -ForegroundColor Green
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
