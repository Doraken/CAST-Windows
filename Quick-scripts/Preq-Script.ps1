# Scripte : Prerequesite installer for Sharepoint 2013                      Version : 1.0
# Author  : Arnaud Crampet 
#



$timestamp            = Get-Date -UFormat "%Y-%m-%d_%H-%M" # Horodatage pour les log fichiers
$Global:timestampFile = Get-Date -UFormat "%Y-%m-%d_%H-%M" # Horodatage pour les Noms fichiers 

$Script_Action = "Sharepoint_Preq_Installer"
$Glb_RootAdmin = "E:\admin"
$Glb_RootLog   = $Glb_RootAdmin + "\logs"
$Glb_RootSrc   = $Glb_RootAdmin + "\Src"
$GlbLogFile    = $Glb_RootLog + "\" + $Script_action + "_" + $Global:timestampFile + ".log"

$GLBSrcServer    = "\\10.60.1.10"
$GLBSrcShpPreqr  = $GLBSrcServer + "\iso\SharePoint\Prerequesite"
$GLBSrcShpBin    = $GLBSrcServer + "\iso\SharePoint\2013US"
$GLBSrcLocRoot   = $Glb_RootSrc + "\SharePoint"



$strPackage = @("Net-Framework-Features","Web-Server","Web-WebServer","Web-Common-Http","Web-Static-Content","Web-Default-Doc","Web-Dir-Browsing","Web-Http-Errors","Web-App-Dev","Web-Asp-Net","Web-Net-Ext","Web-ISAPI-Ext","Web-ISAPI-Filter","Web-Health","Web-Http-Logging","Web-Log-Libraries","Web-Request-Monitor","Web-Http-Tracing","Web-Security","Web-Basic-Auth","Web-Windows-Auth","Web-Filtering","Web-Digest-Auth","Web-Performance","Web-Stat-Compression","Web-Dyn-Compression","Web-Mgmt-Tools","Web-Mgmt-Console","Web-Mgmt-Compat","Web-Metabase","Application-Server","AS-Web-Support","AS-TCP-Port-Sharing","AS-WAS-Support","AS-HTTP-Activation","AS-TCP-Activation","AS-Named-Pipes","AS-Net-Framework","WAS","WAS-Process-Model","WAS-NET-Environment","WAS-Config-APIs","Web-Lgcy-Scripting","Windows-Identity-Foundation","Server-Media-Foundation","Xps-Viewer")
$DebugLevel = 6


Function UpdateTStamp
{
    $timestamp            = Get-Date -UFormat "%Y-%m-%d_%H-%M" # Horodatage pour les log fichiers
}

function New-Dir ([string]$_DirCreate )
{
    # Auteur : Arnaud Crampet 19/12/2014
    # Function de création de répertoires
    # $_BaseDirCreate = répertoir ou la création doit avoir lieux 
    # $_DirCreate     = répertoir à créer 
    # Appelle         : New-Dir(mon répertoir de base ) (mon répertoir à créer )
     
     
     
    $Path = $_DirCreate
    $DirLevel = 0
    foreach ($_Dir in $Path.split("\") )
        {
        if ($DirLevel -eq 0 ) 
            { 
            $RbuildPath = $_Dir 
            $DirLevel = 1
            } 
        else
            {
            $RbuildPath = $RbuildPath + "\" + $_Dir 
            }
 
        if ( Get-DireStatus($RbuildPath) -eq $True) 
            {
             
            }
            Else 
            { 
                try 
                {
                 new-item  $RbuildPath -itemtype directory
                }
                catch 
                {
                 $_LocErrMessage   = $_.exception.message 
                 $_LocFailledItem  = $_.exception.ItemName
                 Write-OutputStd ("Error on : " + $_LocErrMessage + " For :" + $_LocFailledItem) ("red")
                 Write-OutputStd ($RbuildPath) ("red")
                 break 
                 }
            }
        }

}


Function Get-DireStatus ([STRING]$_TstDirFpath) 
 {
    $ExistState = $False
    if ( test-path $_TstDirFpath) 
        { 
        if ( 6 -le $DebugLevel ) {
            Write-OutputStd ("Found Directory : [ " + $_TstDirFpath  + " ] ") ("green") }
            $ExistState = $True
        }
            else 
        {
            Write-OutputStd (" Directory Not Found : [ " + $_TstDirFpath + " ] ") ("red")
        }
 return $ExistState
}


function Get-ResultExecution ( [STRING]$_ExecutionCode, [STRING]$_ExecutInfo )
{
 if ( $_ExecutionCode -eq $True ) 
   { 
     Write-OutputStd ("Execution of :" + $_ExecutInfo  + "  : OK") ("green")
   }
   else 
   {
     Write-OutputStd ("Error on Execution of :" + $_ExecutInfo + "  : Ko") ("RED")
     Write-OutputStd ("Exit code : " + $_ExecutionCode) ("RED")
     write-OutputStd ("Exiting forced") ("RED")
     exit 1
   }
}

Function CopySrc 
{
Write-OutputStd ( "Copying Sharepoint Prerequesite Sources  : " + $GLBSrcShpPreqr ) ("green") 
$CMDexec = "robocopy " + $GLBSrcShpPreqr + " " + $GLBSrcLocRoot + "/E /R:2 /W:2 /LOG:" + $Glb_RootLog + "\SrcCopy_" + $Global:timestampFile + ".log"
& $CMDexec
Get-ResultExecution ($lastexitCode) ("Package Copy : Shrapoint 2013 Prerequesite Files ")


Write-OutputStd ( "Copying Sharepoint  Sources  : " + $GLBSrcShpBin ) ("green") 
$CMDexec = "robocopy " + $GLBSrcShpBin + " " + $GLBSrcLocRoot + "/E /R:2 /W:2 /LOG:" + $Glb_RootLog + "\SrcCopy_" + $Global:timestampFile + ".log"
& $CMDexec
Get-ResultExecution ($lastexitCode) ("Package Copy : Shrapoint 2013 install Files ")

}

Function Write-OutputStd([STRINg]$_WriteLine, [String]$_ForeGround )
{
write-host    $_WriteLine  -foregroundcolor $_ForeGround 
write-output  $_WriteLine >> $GlbLogFile
}


function main ()
{
New-Dir $Glb_RootAdmin
New-Dir $Glb_RootLog 
New-Dir $GLBSrcLocRoot  
 
foreach ( $_Package in $strPackage ) 
 {
   $_CMDEXECUTE = "Add-WindowsFeature  " + $_Package
   Write-OutputStd ( "Installing : " + $_CMDEXECUTE ) ("green") 
   Add-WindowsFeature   $_Package
   Get-ResultExecution ($?) ("Package installation  $_Package")
  }
  
  CopySrc
}

Main