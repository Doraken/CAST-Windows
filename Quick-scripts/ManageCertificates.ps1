#####
##
# Author : Arnaud Crampet 
# Mail   : Arnaud@crampet.net
# Usage  : Manage selfsignet certificate

#Var init
$CertSubjetCN = 'Dummy'
$CertLenght   = '1024'
$Global:CertDuration = '1'
$CertFqdn     = """www.contoso.com"""
$cert         = ''
$CertSavePath = "C:\cert"

 
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
         '1' { $global:RootCertLenght = '1024'} 
         '2' { $global:RootCertLenght = '2048'}
         '3' { $global:RootCertLenght = '4096'}
         'Q' { exit 0 }
     }
EnterToContinue $global:RootCertLenght
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
         '1' { $Global:CertDuration = '1'} 
         '2' { $Global:CertDuration = '3'}
         '3' { $Global:CertDuration = '6'}
         '4' { $Global:CertDuration = '12'} 
         '5' { $Global:CertDuration = '24'}
         '6' { $Global:CertDuration = '36'}
         '7' { $Global:CertDuration = '48'} 
         'Q' { exit 0 }
     }
EnterToContinue $Global:CertDuration
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
New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "$Global:CertSubjetCN" `
-KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength $Global:CertLenght `
-CertStoreLocation "Cert:\CurrentUser\My" `
-KeyUsageProperty Sign `
-KeyUsage CertSign `
-NotAfter (Get-Date).AddYears($Global:CertDuration)
main
}


function Set-ClientCert
{
Set-CertBaseVar
Get-certificate
write-host " Generate certificates from root (For Client Authentication only) (Not for web server)"
$ncert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "$Global:CertSubjetCN" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength $Global:CertLenght `
-NotAfter (Get-Date).AddMonths($Global:CertDuration) `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $global:RootCert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
EnterToContinue ""
main
}


function Set-WebServiceCert
{
# Generate Web server self signet certificate
Set-CertBaseVar
Get-certificate
Set-CertDomaineName 
write-host  "Generate certificate from root for web service"
$ncert = New-SelfSignedCertificate -Type Custom `
-Subject "$Global:CertSubjetCN" -KeyExportPolicy Exportable `
-DnsName $Global:CertFqdn `
-HashAlgorithm sha256 -KeyLength $Global:CertLenght `
-KeyUsage "KeyEncipherment", "DigitalSignature" `
-NotAfter (Get-Date).AddMonths($Global:CertDuration) `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $global:RootCert
EnterToContinue ""
main
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
 $global:RootCertTag = $CertList.Item($ItmVal).Subject
 $global:RootCertThumbprint = $CertList.Item($ItmVal).Thumbprint
 $global:RootCert =  Get-ChildItem -Path "Cert:\CurrentUser\My\$global:RootCertThumbprint"
 EnterToContinue $global:RootCertTag
 
}

function Get-CertList
{
 Write-Menu-Header "Certificate List" 
 $Certlist = Get-ChildItem -Path “Cert:\CurrentUser\My”
 $Certlist 
 write-host "" 
 write-host " Counted item : " $Certlist.count
 EnterToContinue  
 main
}


function Exp-ClientCert
{
Get-certificate
If(!(test-path $CertSavePath))
{
New-Item -ItemType Directory -Force -Path $CertSavePath
}
$FnameBase =  $global:RootCert.Subject.Split("=").Item(1)
$Fpath1 = $CertSavePath + "\" + $FnameBase + ".cer"
$Fpath2 = $CertSavePath + "\" + $FnameBase + "x64.cer"
Export-Certificate -Cert  $global:RootCert -FilePath $Fpath1 
certutil -encode $Fpath1  $Fpath2
explorer $CertSavePath
}
 

function Main
{
 Write-Menu-Header "Certificate Menu"
 Put-Spacer
 Write-Host "1  Create Root Certificate."
 Write-Host "2  Create Web certificate."
 Write-Host "3  Create Client authentication certificates."
 Write-Host "4  export Client authentication certificates."
 Write-Host "L  list all availlable certificates."
 Write-Host "Q: Press 'Q' to quit."
 Put-Spacer
 $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' { Set-RootCert       } 
         '2' { Set-WebServiceCert }
         '3' { Set-ClientCert     }
         '4' { Exp-ClientCert     }
         'L' { Get-CertList       }
         'Q' { exit 0             }
     }
}


main