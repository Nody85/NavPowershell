#Step 1 Extract all Captions from both Versions
#Step 2 Buikd Sourcefiles without Captions
#Step 3 Split Sourcefiles to Folders
#Step 4 Merge the Folders to an Output Folder
#Step 5 Add the Captions in the right order to the Output Folder

$NavVersion = 140
Import-Module "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\$NavVersion\RoleTailored Client\NavModelTools.ps1"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\$NavVersion\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1"
Import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\$NavVersion\Service\NavAdminTool.ps1"
$NavIde="C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\$NavVersion\RoleTailored Client\finsql.exe"


$WorkDir="C:\Temp\CombineCaptions\"
$BaseVersion="NAV_DE_CU9"                                 #NAV_DE_CU9
$BaseVersion_File=$WorkDir+$BaseVersion+".txt"            #NAV_DE_CU9.txt
$ProductVersion="PRODUCT_DE_CU9"                          #PRODUCT_DE_CU9 
$ProductVersion_File=$WorkDir+$ProductVersion+".txt"      #PRODUCT_DE_CU9.txt
$TargetVersion="NAV_CH_CU11"                               #NAV_CH_CU11 
$TargetVersion_File=$WorkDir+$TargetVersion+".txt"        #NAV_CH_CU11.txt

$LanguageCodes="DEU","DES","ITS","FRS","ENU"

#Step 1
Write-Host "Step 1" -ForegroundColor Green
$ProductVersionCaptionPath=$WorkDir+$ProductVersion+"_Caption"
MD $ProductVersionCaptionPath
$TargetVersionCaptionPath=$WorkDir+$TargetVersion+"_Caption"
MD $TargetVersionCaptionPath
Export-NAVApplicationObjectLanguage -Destination $ProductVersionCaptionPath -Source $ProductVersion_File -LanguageId $LanguageCodes
Export-NAVApplicationObjectLanguage -Destination $TargetVersionCaptionPath -Source $TargetVersion_File -LanguageId $LanguageCodes

#Step 2
Write-Host "Step 2" -ForegroundColor Green
$BaseVersionCaptionless_File=$WorkDir+$BaseVersion+"_Captionless.txt"
$ProductVersionCaptionless_File=$WorkDir+$ProductVersion+"_Captionless.txt"
$TargetVersionCaptionless_File=$WorkDir+$TargetVersion+"_Captionless.txt"

Remove-NAVApplicationObjectLanguage -Destination $BaseVersionCaptionless_File -Source $BaseVersion_File -LanguageId $LanguageCodes
Remove-NAVApplicationObjectLanguage -Destination $ProductVersionCaptionless_File -Source $ProductVersion_File -LanguageId $LanguageCodes
Remove-NAVApplicationObjectLanguage -Destination $TargetVersionCaptionless_File -Source $TargetVersion_File -LanguageId $LanguageCodes

#Step 3
Write-Host "Step 3" -ForegroundColor Green
$BaseVersionCaptionless_Path=$WorkDir+$BaseVersion+"_Captionless"
$ProductVersionCaptionless_Path=$WorkDir+$ProductVersion+"_Captionless"
$TargetVersionCaptionless_Path=$WorkDir+$TargetVersion+"_Captionless"
Split-NAVApplicationObjectFile -Source $BaseVersionCaptionless_File -Destination $BaseVersionCaptionless_Path -Force
Split-NAVApplicationObjectFile -Source $ProductVersionCaptionless_File -Destination $ProductVersionCaptionless_Path -Force
Split-NAVApplicationObjectFile -Source $TargetVersionCaptionless_File -Destination $TargetVersionCaptionless_Path -Force

#Step 4
$ResultPath=$WorkDir+"MergeResult"
MD $ResultPath
Merge-NAVApplicationObject -ModifiedPath $TargetVersionCaptionless_Path -OriginalPath $BaseVersionCaptionless_Path -ResultPath $ResultPath -TargetPath $ProductVersionCaptionless_Path -DateTimeProperty FromTarget



#$LanguageCodes | %{
 
#  write-host "Adding Language" $PSItem -ForegroundColor Red
#  if($LanguageCounter -eq 0)
#  {
#    Import-NAVApplicationObjectLanguage -Destination $Workdir$LanguageCounter -LanguagePath $ProductVersionCaptionPath\ -Source $ResultPath
#  }
#  else
#  {
#  }
#  $LanguageCounter++

 
#}

#Rest noch brauchbar ??

#Import-NAVApplicationObjectLanguage -Destination "C:\GIT\dynamicsnav\Objects\" -LanguagePath ($WorkDir\CU4 DE CAPTION\") -Source "C:\Users\AndersE\Desktop\Install\CU4 DE CAPTIONless\" -LanguageId "DEU"
#Export-NAVApplicationObjectLanguage -Destination "$WorkDir\CU4 SWISS CAPTION.txt" -Source "C:\GIT\dynamicsnav\Objects\" -LanguageId "DES","ITS","FRS","ENU"
#Import-NAVApplicationObjectLanguage -Destination "$WorkDir\CU4 DE CAPTIONDE.txt" -LanguagePath "$WorkDir\CU4 DE ZU DES CAPTION.txt" -Source "$WorkDir\CU4 DE CAPTIONless.txt" -LanguageId DES
#Import-NAVApplicationObjectLanguage -Destination "$WorkDir\CU4 DE CAPTIONDESITSFRS.txt" -LanguagePath "$WorkDir\CU4 SWISS CAPTION.txt" -Source "$WorkDir\CU4 DE CAPTIONDE.txt" -LanguageId "DES","ENU","FRS","ITS"
#Export-NAVApplicationObjectLanguage -Destination "$WorkDir\CAPTION DE\" -Source "$WorkDir\Unitop2018_CU4.txt" -LanguageId "DEU"
#Export-NAVApplicationObjectLanguage -Destination "$WorkDir\CAPTION DES" -Source "$WorkDir\GH_2018_CU4.txt" -LanguageId "DES","ITS","FRS","ENU"
#Import-NAVApplicationObjectLanguage -Destination "$WorkDir\CU4 DE CAPTIONless_Schritt1.txt" -LanguagePath ("$WorkDir\CAPTION DEDES\") -Source ("$WorkDir\CU4 DE CAPTIONless.txt") -LanguageId "DES"
#Import-NAVApplicationObjectLanguage -Destination "$WorkDir\CU4 DE CAPTIONless_Schritt2.txt" -LanguagePath ("$WorkDir\CAPTION DES\") -Source ("$WorkDir\CU4 DE CAPTIONless_Schritt1.txt") -LanguageId "DES","FRS","ITS","ENU"
#Import-NAVApplicationObject -DatabaseName 2018_CH -Path C:\GIT\dynamicsnav\Objects\*.txt -ImportAction Overwrite -LogPath "$WorkDir\LOG\"
#Import-NAVApplicationObject -DatabaseName 2018_CH -Path C:\GIT\SWISSMOD2018\*.txt -ImportAction Overwrite -LogPath "$WorkDir\LOG\"