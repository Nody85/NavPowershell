$NavVersion = 110
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\NavModelTools.ps1"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1"
Import-module "C:\Program Files\Microsoft Dynamics NAV\$NavVersion\Service\NavAdminTool.ps1"
$NavIde="C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\finsql.exe"

$ServerInstanceName = 'SERVICETIERNAME'

Sync-NAVTenant -ServerInstance $ServerInstanceName -mode CheckOnly

Start-NAVDataUpgrade -ServerInstance $ServerInstanceName

Get-NAVDataUpgrade -ServerInstance $ServerInstanceName -Detailed  | ogv

Resume-NAVDataUpgrade -ServerInstance $ServerInstanceName

Resume-NAVDataUpgrade -CodeunitId 104000 -FunctionName "SAMPLEFUNCTIONNAME" -ServerInstance $ServerInstanceName -CompanyName "SAMPLECOMPANY"

Stop-NAVDataUpgrade -ServerInstance $ServerInstanceName