$NavVersion = 110
$ServerInstance = dynamicsnav110
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\NavModelTools.ps1"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\Microsoft.Dynamics.Nav.Ide.psm1"
Import-module "C:\Program Files\Microsoft Dynamics NAV\$NavVersion\Service\NavAdminTool.ps1"
$NavIde="C:\Program Files (x86)\Microsoft Dynamics NAV\$NavVersion\RoleTailored Client\finsql.exe"

$CompanyList = Get-NAVCompany -ServerInstance $ServerInstance

Foreach ($Company in $CompanyList)
{
  Write-Host $Company.CompanyName -ForegroundColor DarkGreen
  Invoke-NAVCodeunit -CodeunitId 170017 -ServerInstance dynamicsnav110 -CompanyName $Company.CompanyName
}