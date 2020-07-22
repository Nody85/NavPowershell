#Step 1 Extract all Captions from both Versions
#Step 2 Buikd Sourcefiles without Captions
#Step 3 Split Sourcefiles to Folders
#Step 4 Merge the Folders to an Output Folder
#Step 5 Add the Captions in the right order to the Output Folder

$NavVersion = 110
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\NavModelTools.ps1"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1"
Import-module "C:\Program Files\Microsoft Dynamics NAV\$NavVersion\Service\NavAdminTool.ps1"
$NavIde="C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\finsql.exe"


$WorkDir="C:\Temp\CombineCaptions\"
$BaseVersion="NAV_DE_CU9"                                 #NAV_CH_CU6
$BaseVersion_File=$WorkDir+$BaseVersion+".txt"            #NAV_CH_CU6.txt
$TargetVersion="NAV_CH_CU9"                               #NAV_CH_CU9 
$TargetVersion_File=$WorkDir+$TargetVersion+".txt"        #NAV_CH_CU9.txt
$ProductVersion="PRODUCT_DE_CU9"                          #PRODUCT_DE_CU9 
$ProductVersion_File=$WorkDir+$ProductVersion+".txt"      #PRODUCT_DE_CU9.txt

$ProductCaptionLayer ="DEU"
$DefaultCaptionLayer="DES","ITS","FRS","ENU"


$DatabaseName="Compiling Database"

#Step 1
Write-Host "Step 1" -ForegroundColor Green
$TargetVersionCaptionPath=$WorkDir+$TargetVersion+"_Caption"
MD $TargetVersionCaptionPath
$ProductVersionCaptionPath=$WorkDir+$ProductVersion+"_Caption"
MD $ProductVersionCaptionPath
Export-NAVApplicationObjectLanguage -Destination $TargetVersionCaptionPath -Source $TargetVersion_File -LanguageId $DefaultCaptionLayer
Export-NAVApplicationObjectLanguage -Destination $ProductVersionCaptionPath -Source $ProductVersion_File -LanguageId $ProductCaptionLayer

#Step 2
Write-Host "Step 2" -ForegroundColor Green
$BaseVersionCaptionless_File=$WorkDir+$BaseVersion+"_Captionless.txt"
$TargetVersionCaptionless_File=$WorkDir+$TargetVersion+"_Captionless.txt"
$ProductVersionCaptionless_File=$WorkDir+$ProductVersion+"_Captionless.txt"
Remove-NAVApplicationObjectLanguage -Destination $BaseVersionCaptionless_File -Source $BaseVersion_File -LanguageId $DefaultCaptionLayer
Remove-NAVApplicationObjectLanguage -Destination $TargetVersionCaptionless_File -Source $TargetVersion_File -LanguageId $DefaultCaptionLayer
Remove-NAVApplicationObjectLanguage -Destination $ProductVersionCaptionless_File -Source $ProductVersion_File -LanguageId $ProductCaptionLayer

#Step 3
#Warning Split-NAVApplicationObjectFile changes bad variable names
Write-Host "Step 3" -ForegroundColor Green
$BaseVersionCaptionless_Path=$WorkDir+$BaseVersion+"_Captionless"
$TargetVersionCaptionless_Path=$WorkDir+$TargetVersion+"_Captionless"
$ProductVersionCaptionless_Path=$WorkDir+$ProductVersion+"_Captionless"
Split-NAVApplicationObjectFile -Source $BaseVersionCaptionless_File -Destination $BaseVersionCaptionless_Path -Force
Split-NAVApplicationObjectFile -Source $TargetVersionCaptionless_File -Destination $TargetVersionCaptionless_Path -Force
Split-NAVApplicationObjectFile -Source $ProductVersionCaptionless_File -Destination $ProductVersionCaptionless_Path -Force

#Step 4
$ResultPath=$WorkDir+"MergeResult"
MD $ResultPath
Merge-NAVApplicationObject -ModifiedPath $TargetVersionCaptionless_Path -OriginalPath $BaseVersionCaptionless_Path -ResultPath $ResultPath -TargetPath $ProductVersionCaptionless_Path -DateTimeProperty FromTarget

#Merge failed Objects with KDIFF3
#Quality Gate 1 Compile without Captionlayer
#Import all Objects and fix syntax errors
#Compile all Objects
$WorkDir = $ResultPath
$WorkDirLogPath = $WorkDir+"LogPath"
$ReImportEveryFile = $SplitPath+"*.txt"
Import-NAVApplicationObject -DatabaseName $DatabaseName -Path $ReImportEveryFile -ImportAction Overwrite -LogPath $WorkDirLogPath -SynchronizeSchemaChanges Force -Confirm:$false

#Step 5
#Export all Objects to "SOURCECODEFOLDER"
Import-NAVApplicationObjectLanguage -Destination "CAPTIONIMPORTRESULT1" -LanguagePath "LANGUAGEFOLDER" -Source "SOURCECODEFOLDER" -LanguageId $ProductCaptionLayer
Import-NAVApplicationObjectLanguage -Destination "CAPTIONIMPORTRESULT2" -LanguagePath "LANGUAGEFOLDER" -Source "CAPTIONIMPORTRESULT1" -LanguageId $DefaultCaptionLayer

#Quality Gate 2 Compile with Captionlayer
#Compile all Objects
$WorkDir = $ResultPath
$WorkDirLogPath = $WorkDir+"LogPath"
$ReImportEveryFile = $SplitPath+"*.txt"
Import-NAVApplicationObject -DatabaseName $DatabaseName -Path "CAPTIONIMPORTRESULT2" -ImportAction Overwrite -LogPath $WorkDirLogPath -SynchronizeSchemaChanges Force -Confirm:$false
#Export
#Split
#Commit in Git