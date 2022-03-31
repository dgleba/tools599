
# Purpose: compare size of each file in source vs destination

# https://stackoverflow.com/questions/57741838/how-to-compare-file-size-for-copied-files-in-powershell


# =================================================

# settings.

$SourceDir='C:\crib\c598'
$DestinationDir='C:\crib\c598copy'


$global:nickname = "24cmpfilesiz"
$global:logpath = "c:\data\test\logs"

cmd /c if not exist $logpath mkdir $logpath 
$global:mlogfile24 = "{0}\{1}_{2}__log.txt" -f $logpath, $(gc env:computername), $nickname
      

# =================================================

# get files modified between these two times..
$mendt = (Get-Date).Addminutes(-1)
$mstartt = (Get-Date).Addminutes(-19)

$Source = get-childitem "$SourceDir\*" | Where-Object {$_.LastWriteTime -lt $mendt -and $_.LastWriteTime -ge $mstartt}  | select Length, FullName
# Folder
# -file "*.txt" -Recurse 
# write-host $Source

$Dest = get-childitem "$DestinationDir\*"   | Where-Object {$_.LastWriteTime -lt $mendt -and $_.LastWriteTime -ge $mstartt} | select Length, @{N='FullName';E={$_.FullName.Replace($DestinationDir, $SourceDir)}}
# -file -Filter "*.txt" -Recurse
# write-host $Dest

write-host "Loop all files.."
$Source | ForEach{

  $mts = (Get-Date).toString("yyyy-MM-dd_HH.mm.ss.f")
  $Current=$_
  $FileInDest=$Dest | where FullName  -eq $Current.FullName | select -first 1

  if ($FileInDest -eq $null)
  {
      $mtext = "{0}, not found in destination, {1} ,vs, {2}" -f $mts, $Current.FullName, $DestinationDir
      write-host $mtext
      $mtext | Out-File -FilePath  $mlogfile24
      $mexit = 3
  }
  elseif ($Current.Length -ne $FileInDest.Length)
  {
      $mtext = "{0}, length mismatch, {1}  ,vs, {2}" -f $mts, $Current.FullName, $DestinationDir
      write-host $mtext
      $mtext | Out-File -FilePath  $mlogfile24
      $mexit = 2
  }

}

if ($mexit -ge 1) {
exit $mexit
}

# to check exit, try this at prompt: $lastexitcode
