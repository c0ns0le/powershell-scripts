Set-ExecutionPolicy Unrestricted -Force

# function definition
function Get-BinaryDate
{
    $d = date
    $h = "{0:X16}" -f $d.ToFileTimeUtc()
    $h = ($h -replace '\w{2}','0x$& ').Trim()
    $hs = $h.Split(' ')
    [Array]::Reverse($hs)
    [byte[]]$hs
}

#==============================================================
# show file name extentions
sp HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced HideFileExt 0

# show hidden items
sp HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced Hidden 1

#==============================================================
# IE - Finish first time wizard
New-ItemProperty -Force 'HKCU:\Software\Microsoft\Internet Explorer\Main' IE10RunOncePerInstallCompleted -PropertyType dword -Value 1
New-ItemProperty -Force 'HKCU:\Software\Microsoft\Internet Explorer\Main' IE10RunOnceCompletionTime -PropertyType binary -Value $(Get-BinaryDate)
#New-ItemProperty -Force 'HKCU:\Software\Microsoft\Internet Explorer\BrowserEmulation' MSCompatibilityMode -PropertyType dword -Value 0
#New-ItemProperty -Force 'HKCU:\Software\Microsoft\Internet Explorer\PhishingFilter' EnabledV9 -PropertyType dword -Value 0

# IE - Set homepage to blank
Set-ItemProperty 'HKCU:\Software\Microsoft\Internet Explorer\Main' 'Start Page' about:blank

# IE - Disable feed view
ni 'HKCU:\Software\Microsoft\Internet Explorer\Feeds' -ea 0
New-ItemProperty -Force 'HKCU:\Software\Microsoft\Internet Explorer\Feeds' TurnOffOPV -PropertyType dword -Value 1

# IE - Tabs on separate row
ni 'HKCU:\Software\Microsoft\Internet Explorer\MINIE' -ea 0
New-ItemProperty -Force 'HKCU:\Software\Microsoft\Internet Explorer\MINIE' ShowTabsBelowAddressBar -PropertyType dword -Value 1

# IE - Show favorites bar
New-ItemProperty -Force 'HKCU:\Software\Microsoft\Internet Explorer\MINIE' LinksBandEnabled -PropertyType dword -Value 1

# IE - Add url link to favorites bar
$wshshell = new-object -comobject wscript.shell
$shortCut = $wshShell.CreateShortCut("$HOME\Favorites\Links\SPF.url")
$shortCut.TargetPath = "http://localhost:8090/SC2012/VMM/Microsoft.Management.Odata.svc/"
$shortCut.Save()

#==============================================================
# cmd - quick edit
Set-ItemProperty 'HKCU:\Console' QuickEdit 1

# cmd - layout size
# 100x300
Set-ItemProperty 'HKCU:\Console' ScreenBufferSize 19660900
# 100x50
Set-ItemProperty 'HKCU:\Console' WindowSize 3932260

#==============================================================
# install fiddler and notepad++
$cred = Get-Credential -UserName '' -Message 'Your Microsoft Credential'
New-PSDrive -name share -PSProvider FileSystem -Root \\scxfiles\team\SPF\Tools -Credential $cred

start share:\Fiddler2Setup.exe
start share:\npp.6.0.Installer.exe

