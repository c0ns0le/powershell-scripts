$file = 'D:\C#'
$zipfilename = 'D:\C#.zip'

#delete bin and obj directory
ls $file -Directory -Recurse | foreach {if ($_.Name -eq 'bin' -or $_.Name -eq 'obj'){del $_.FullName -Recurse}}

#new a zip
set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
(ls $zipfilename).IsReadOnly = $false

#get zip object
$shellApplication = new-object -com shell.application
$zipPackage = $shellApplication.NameSpace($zipfilename)

#copy file
$zipPackage.CopyHere($file)