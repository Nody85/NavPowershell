#This script is to proof low quality releases shipped by Fob or complete databases
#Step 1 Export all Objects that are in your developer license
#Step 2 Splits all Objects that could be exported
#Step 3 Try to Re-Import the Objects if there is any Syntax Errror or you can not import an Object with your license, you will see it in the logpath to investigate

$NavVersion = 140
Import-Module "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\$NavVersion\RoleTailored Client\NavModelTools.ps1"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\$NavVersion\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1"
Import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\$NavVersion\Service\NavAdminTool.ps1"
$NavIde="C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\$NavVersion\RoleTailored Client\finsql.exe"

$DatabaseName = "MyDataBase"
$WorkDir = "C:\Temp\$DatabaseName\Objects\"
MD $WorkDir -Force
#Step 1
Export-NAVApplicationObject -DatabaseName $DatabaseName -Path $WorkDir"Export.txt" -ExportTxtSkipUnlicensed

#Step 2
$SplitPath = $WorkDir+"\Export\"
Split-NAVApplicationObjectFile -Source $WorkDir"Export.txt" -Destination $SplitPath -Force

#Step3
$WorkDirLogPath = $WorkDir+"LogPath"
$ReImportEveryFile = $SplitPath+"*.txt"
Import-NAVApplicationObject -DatabaseName $DatabaseName -Path $ReImportEveryFile -ImportAction Overwrite -LogPath $WorkDirLogPath -SynchronizeSchemaChanges Force -Confirm:$false