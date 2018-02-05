﻿#This script is to proof low quality releases shipped by Fob or complete databases
#Step 1 Export all Objects that are in your developer license
#Step 2 Splits all Objects that could be exported
#Step 3 Try to Re-Import the Objects if there is any Syntax Errror or you can not import an Object with your license, you will see it in the logpath to investigate

$NavVersion = 100
$NavIde="C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\finsql.exe"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\NavModelTools.ps1"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1"
Import-module "C:\Program Files\Microsoft Dynamics NAV\$NavVersion\Service\NavAdminTool.ps1"

$DatabaseName = "MyDataBase"
$WorkDir = "C:\Temp\Objects\"
MD $WorkDir -Force

Export-NAVApplicationObject -DatabaseName $DatabaseName -Path $WorkDir"Export.txt" -ExportTxtSkipUnlicensed

$SplitPath = $WorkDir+"\Export\"
Split-NAVApplicationObjectFile -Source $WorkDir"Export.txt" -Destination $SplitPath -Force

$WorkDirLogPath = $WorkDir+"LogPath"
$ReImportEveryFile = $SplitPath+"*.txt"
Import-NAVApplicationObject -DatabaseName $DatabaseName -Path $ReImportEveryFile -ImportAction Overwrite -LogPath $WorkDirLogPath -SynchronizeSchemaChanges Force -Confirm:$false