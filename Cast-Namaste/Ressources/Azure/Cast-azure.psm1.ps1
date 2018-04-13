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
	
}

function Get-AzureSessionState
{
	if ($global:LocalAzureSession = $null) { Set-AzureSession} else { Write-Host "You already have a seted session "}
}