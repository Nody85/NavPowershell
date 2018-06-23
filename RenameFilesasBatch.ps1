#
$OLDLANGUAGECODE = "DEU"
$NEWLANGUAGECODE = "DES"

$DefaultFiles =  Get-ChildItem | Where-Object {$_.Name -like "*$OLDLANGUAGECODE*"}
ForEach($File in $DefaultFiles) 
{
    $newname = ([String]$File).Replace($OLDLANGUAGECODE,$NEWLANGUAGECODE)
    Rename-item -Path $File $newname
}