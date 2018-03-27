#####
##
# Author : Arnaud Crampet 
# Mail   : Arnaud@crampet.net
# Usage  : Manage selfsignet certificate

#Var init
$CertSubjetCN = 'Dummy'
$CertLenght   = '1024'
$CertDuration = '1'
$CertFqdn     = """www.contoso.com"""
$cert         = ''
 
function Write-Menu-Header 
{
 param (
        [string]$Title = 'My Menu'
    )
#  Clear-Host
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
#  Clear-Host
 Put-Spacer
 Write-Host "you choose : [ $Value ] "
 Put-Spacer
 $dummy = Read-Host -Prompt 'Press enter to continue or CTRL+C to end'
#  Clear-Host
 }

function Set-KeyLenght
{
Write-Menu-Header "Certificate key lenght"
Put-Spacer
Write-Host "1 1024 bytes."
Write-Host "2 2048 bytes."
Write-Host "3 4096 bytes."
Write-Host "Q: Press 'Q' to quit."
Put-Spacer
$selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' { $global:CertLenght = '1024'} 
         '2' { $global:CertLenght = '2048'}
         '3' { $global:CertLenght = '4096'}
         'Q' { exit 0 }
     }
EnterToContinue $global:CertLenght
}

function Set-KeyDuration
{
Write-Menu-Header "Certificate key duration"
Put-Spacer
Write-Host "1  1 months."
Write-Host "2  3 months."
Write-Host "3  6 months."
Write-Host "4 12 months."
Write-Host "5 24 months."
Write-Host "6 36 months."
Write-Host "7 48 months."
Write-Host "Q: Press 'Q' to quit."
Put-Spacer
$selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' { $CertDuration = '1'} 
         '2' { $CertDuration = '3'}
         '3' { $CertDuration = '6'}
         '4' { $CertDuration = '12'} 
         '5' { $CertDuration = '24'}
         '6' { $CertDuration = '36'}
         '7' { $CertDuration = '48'} 
         'Q' { exit 0 }
     }
EnterToContinue $CertDuration
}

function Set-CertNameCn
{
Write-Menu-Header "Certificate Name"
Put-Spacer
$global:CertSubjetCN = Read-Host -Prompt 'Input Certificate base CN name'
EnterToContinue $global:CertSubjetCN
}

function Set-CertDomaineName
{
 Write-Menu-Header "Certificate domaine Name"
 Put-Spacer
 Write-Host " You may enter multiple Domaine Name"
 Write-Host "" 
 Write-Host " Exemple : ""www.contoso.com"",""www.mydomain.com"",""172.16.1.234"" "
 Put-Spacer
 $global:CertFqdn = Read-Host -Prompt 'Input Certificate base full qualified domain name'
 EnterToContinue $global:CertFqdn 
}

function Set-CertBaseVar
{
 # Globaly used certificate variables
 Set-CertNameCn
 Set-KeyLenght
 Set-KeyDuration
}


function Set-RootCert
{
# Create Self signed root certificate
# -dnsname -DnsName domain.example.com,anothersubdomain.example.com
# -Subject "CN=Patti Fuller,OU=UserAccounts,DC=corp,DC=contoso,DC=com" 
Set-CertBaseVar
$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "$CertSubjetCN" `
-KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength $CertLenght `
-CertStoreLocation "Cert:\CurrentUser\My" `
-KeyUsageProperty Sign `
-KeyUsage CertSign `
-NotAfter (Get-Date).AddYears($CertDuration)

}


function Set-ClientCert
{
Set-CertBaseVar
# Generate certificates from root (For Client Authentication only) (Not for web server)
New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "$CertSubjetCN" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength $CertLenght `
-NotAfter (Get-Date).AddMonths($CertDuration) `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
}


function Set-WebServiceCert
{
# Generate Web server self signet certificate
Set-CertBaseVar
Set-CertDomaineName 
 Generate certificate from root for web service
New-SelfSignedCertificate -Type Custom `
-Subject "$CertSubjetCN" -KeyExportPolicy Exportable `
-DnsName $CertFqdn `
-HashAlgorithm sha256 -KeyLength $CertLenght `
-KeyUsage "KeyEncipherment", "DigitalSignature" `
-NotAfter (Get-Date).AddMonths($CertDuration ) `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert
}

function Get-certificate
{
$CertList = Get-ChildItem -Path “Cert:\CurrentUser\My” 
$Counter = 0
Write-Menu-Header "Certificate Select"

foreach ($cert in $CertList) {
   Write-Host $Counter " cetificate :" $cert.Subject
   $counter++
 }
 Put-Spacer
 $ItmVal = Read-Host -Prompt 'Select Certificate base CN name'
 $global:CertTag = $CertList.Item($ItmVal).Subject
 $global:CertThumbprint = $CertList.Item($ItmVal).Thumbprint
 $Global:cert =  Get-ChildItem -Path "Cert:\CurrentUser\My\$global:CertThumbprint"
 EnterToContinue $global:CertTag
}

function Main
{
 Write-Menu-Header "Certificate Menu"
 Put-Spacer
 Write-Host "1  Create Root Certificate."
 Write-Host "2  Create Web certificate."
 Write-Host "3  Create Client authentication certificates."
 Write-Host "Q: Press 'Q' to quit."
 Put-Spacer
 $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' { Set-RootCert       } 
         '2' { Set-ClientCert     }
         '3' { Set-WebServiceCert }
         'Q' { exit 0 }
     }
}


Get-certificate
$Global:cert