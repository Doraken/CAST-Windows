#Create-GroupAndAccountForsSharepoint.ps1 Version 1.0
#Writen by Arnaud crampet 
# 
$DebugLevel             = 0
$StackFunct             = $MyInvocation.MyCommand.name.split('\.')[-2]       #Initialisation de la variable de stacktrace.
#Variable de gestion du temps
$timestamp              = Get-Date -UFormat "%Y-%m-%d_%H-%M"       # Horodatage pour les log fichiers
$Global:timestampFile   = Get-Date -UFormat "%Y-%m-%d_%H-%M"       # Horodatage pour les Noms fichiers

# Variable de gestion des nom de fichier de log et ou de traces.
$GLBFolderLogs         = "."
$BaseLogFile            = $GLBFolderLogs + "\Execution_log"   + $timestamp + ".txt"      #|#_LogFile   # Log generique d'exécution.
$BaseLogErr             = $GLBFolderLogs + "\Error_log"       + $timestamp + ".txt"      #|#_LogFile   # Log d'erreur.
$BaseLogAccnt           = $GLBFolderLogs + "\Account_log"     + $timestamp + ".txt"      #|#_LogFile   # Log de création des comptes.



# Fonction extraite du FrameWork CAST-W ( Common application Scripting Framwork - Windows ecrit par Arnaud Crampet 



function WorkDateInFIle () 
{
    # Auteur : Arnaud Crampet 19/12/2014
    # Fonction        : de génération variable de date pour l'hotrodatage des fichiers de logs. 
    # paramètres      : Aucun paramètres 
    # Utilisation     : WorkDateInFIle
    # Varable utilisé : 
    
    
    $Global:timestamp = Get-Date -UFormat "%Y-%m-%d;%H:%M"
 
   
}

function WorkDateFileName () 
{
    # Auteur : Arnaud Crampet 19/12/2014
    # Fonction de génération de stack d'execution des fonctions 
    # $_FunctName        = Nom de la fontion à ajouter ou à supprimer.
    # Utilisation : WorkDate
    

    $Global:timestampFile = Get-Date -UFormat "%Y-%m-%d_%H-%M"

   
}


function Write-GlbLogAndMessages ( [string]$_UsedLine, [int]$_errlevel, [boolean]$_Isfatal ) 
{
    #Gestion des erreur avec debord en log. 
    # $_UsedLine = contient la ligne de log à afficher / ecrire dans les log 
    # $_errlevel = indique le niveau de débug
    # $_Isfatal  =  indique si l'erreur doit provoquer la sortie.
    # Utilisation : Write-GlbLogAndMessages ("Texte de l'information") ("Niveau de l'erreur") ("Est fatale ou non") 

    # Récupération de l'horodatage.
    WorkDateInFIle

    if ($_Isfatal -eq $True ) 
        {
            # Emmission de la log texte vers le fichier d'erreur.
            Write-output ("ERREUR FATALE : " + $_UsedLine + " " +  $timestamp)  >> $BaseLogErr
            # Emmission de la log texte vers le Display.
            Write-Host   ("ERREUR FATALE : " + $_UsedLine + " " +  $timestamp)
            exit 4
        }
    if ( $_UsedLine -ne $null ) 
        {
            if ( $_errlevel -eq 0 ) 
                {
                    Write-Host  "info  : [ " $_errlevel " ]  Message [ "  $_UsedLine  " ]"
                    Write-Output $timestamp";Debug;"$_errlevel";"$_UsedLine                          >> $BaseLogFile
                } 
                   else 
                {
                    if ( $_errlevel -le $DebugLevel ) 
                        {
                            Write-Host  "Debug : [ " $_errlevel " ]  Message [ "  $_UsedLine  " ]"
                           # Write-Output  "$timestamp;Debug;$_errlevel;$_UsedLine"                  >> $BaseLogFile 
                        }
                        Write-Output   $timestamp";Debug;"$_errlevel";"$_UsedLine                   >> $BaseLogFile 
                }
        }
            else 
        { 
            Write-Output "Attention , votre variable de log est vide"
        }
}

function Set-StackMgmF ( [String]$_FunctName, [boolean]$_AddName ) 
{
    # Auteur : Arnaud Crampet 19/12/2014
    # Fonction de génération de stack d'execution des fonctions 
    # $_FunctName        = Nom de la fontion à ajouter ou à supprimer.
    # $_AddName          = Variable vrai/faux pour la gestion du mode addition ou soustraction :     $False = Supprime le nom de fonction |   $True Ajoute le nom de la fonction à la trace.
    # $Global:StackFunct = Variable string à porté globale utilisé par la stack Trace initialisé en debut de script.
    # Utilisation en ajout       : Set-StackMgmF ($MyInvocation.MyCommand.name) ($True)
    # Utilisation en suppression : Set-StackMgmF ($MyInvocation.MyCommand.name)  ($False)

    if ( $_AddName -eq $False ) 
            {
                # Elimination de la dernière fonction de la stack d'exécution.
                $Global:StackFunct = $StackFunct.Replace( "\" + $_FunctName, "" ) 
                $_Uline            = "[ Back To function  : ] " + $StackFunct            # Génération de la ligne de débug.           
                Write-GlbLogAndMessages ($_Uline) ("4") ($False)                                              # Emission du Debug de base de la fonction. Niveau 4
            }
          Else 
            {
                # Ajout du nom de la fonction en cour à la stack d'exécution.
                $Global:StackFunct = $StackFunct + "\" + $_FunctName
                $_Uline            = "[ Entering function : ] " +  $Global:StackFunct    # Génération de la ligne de débug.                  
                Write-GlbLogAndMessages ($_Uline) ("4") ($False)                                                # Emission du Debug de base de la fonction. Niveau 4
      }
 
}
# Fin de des fonction de framwork 







function GenPasswd ([STRING]$_AccountName ) 
{
    Set-StackMgmF ($MyInvocation.MyCommand.name)  ($True)
    #ConvertTo-SecureString [-String] <String
   
    

    $__CharsAlpha = @("A","a","B","b","C","c","D","d","E","e","F","f","G","g","H","h","I","i","J","j","K","k","L","l","M","m","N","n","O","o","P","p","Q","q","R","r","S","s","T","t","U","u","V","v","W","w","X","x","Y","y","Z","z")
    $__CharsNum   = @("1","2","3","4","5","6","7","8","9","0","9","8","7","6","5","4","3","2","1")
    $__CharsCmp   = @("!",":",";","@","-","#")
    $__RandRand   = @("1","2","3","2","3","1","3","2","3","1","2","3","1","2","3","1","2","1","1","2","3","2","3","2","1","1","2","3","2","2","1","2","3","2","2","2","3","2","3","2","1","1","2","1","2","3","1","3","2","3","2","1","2","2")

    $__Maxcount = 15
    $__CurCount = 0
    $__passwd = ""
    while($__CurCount -ne $__Maxcount)
         {
           $__CurCount++
           $TypeCharGet = Get-Random -InputObject $__RandRand
           
           
           switch ($TypeCharGet) 
            { 
                1 { $__passwdItm = Get-Random -InputObject  $__CharsAlpha  } 
                2 { $__passwdItm = Get-Random -InputObject  $__CharsNum  } 
                3 { $__passwdItm = Get-Random -InputObject  $__CharsCmp  } 
            }
           $__passwd = $__passwd + $__passwdItm
           
           
         }
         
    Write-GlbLogAndMessages ("Generate password for  $_AccountNAme ") ("0") ($False) 
    Write-GlbLogAndMessages ("  $__passwd") ("0") ($False) 
    $BaseLogAccnt           = $GLBFolderLogs + "\" + $_AccountName +"_Account_log_"     + $Global:timestampFile + ".txt"      #|#_LogFile   # Log de création des comptes.
    Write-GlbLogAndMessages ("  Save in file :  $BaseLogAccnt") ("0") ($False) 
    write-output " Generate password for :  $_AccountNAme " >>   $BaseLogAccnt
    write-output " password              :  $__passwd "     >>   $BaseLogAccnt
    
    Set-StackMgmF ($MyInvocation.MyCommand.name)  ($False)
   
}



function DisplSep ()
{

Write-GlbLogAndMessages ("") ("0") ($False) 
Write-GlbLogAndMessages ("----") ("0") ($False) 
Write-GlbLogAndMessages ("") ("0") ($False) 

}

function Main ()
{
    Set-StackMgmF ($MyInvocation.MyCommand.name)  ($True)
    $name = Read-Host 'What is your username?'
    GenPasswd ($Name)
    Set-StackMgmF ($MyInvocation.MyCommand.name)  ($False)
}


main