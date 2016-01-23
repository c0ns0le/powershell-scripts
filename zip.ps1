<#Somedays I feel like the Windows PowerShell Evangelist. Anyway, Johnny Halife and I were working on a script that would package up the files for a windows sidebar gadget as a post build event. Turns out you can do this with Windows PowerShell (surprise, surprise).
 
Once we got this working, I thought it would be cool to turn them into functions and add them to my profile so they are always available.
 
Being short of time (as always) I figured if I could:#>
 
#1. Create a New Zip
function New-Zip
{
	param([string]$zipfilename)
	set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
	(dir $zipfilename).IsReadOnly = $false
}
#usage: new-zip c:\demo\myzip.zip 

#2. Add files to a zip via a pipeline
function Add-Zip
{
	param([string]$zipfilename)

	if(-not (test-path($zipfilename)))
	{
		set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
		(dir $zipfilename).IsReadOnly = $false	
	}
	
	$shellApplication = new-object -com shell.application
	$zipPackage = $shellApplication.NameSpace($zipfilename)
	
	foreach($file in $input) 
	{ 
            $zipPackage.CopyHere($file.FullName)
            Start-sleep -milliseconds 500
	}
}
#usage: dir c:\demo\files\*.* -Recurse | add-Zip c:\demo\myzip.zip 

#3. List the files in a zip
function Get-Zip
{
	param([string]$zipfilename)
	if(test-path($zipfilename))
	{
		$shellApplication = new-object -com shell.application
		$zipPackage = $shellApplication.NameSpace($zipfilename)
		$zipPackage.Items() | Select Path
	}
}
#usage: Get-Zip c:\demo\myzip.zip 

#4. Extract the files form the zip
function Extract-Zip
{
	param([string]$zipfilename, [string] $destination)

	if(test-path($zipfilename))
	{	
		$shellApplication = new-object -com shell.application
		$zipPackage = $shellApplication.NameSpace($zipfilename)
		$destinationFolder = $shellApplication.NameSpace($destination)
		$destinationFolder.CopyHere($zipPackage.Items())
	}
}
#usage: extract-zip c:\demo\myzip.zip c:\demo\destination 

#So, how do we package the Vista Sidebar Gadget?
#dir <path_to_gadget_files | add-Zip <path_to_gadget_zip>
#Rename-Item <path_to_gadget_zip> <path_to_gadget_zip>.Gadget
