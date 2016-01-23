######### get wmi object ######################
Get-WmiObject -list -Namespace root\CIMV2 -ComputerName localhost
Get-WmiObject -list -Namespace root\CIMV2 | where {$_.Name -match 'Win32_+' -and $_.Name.Length -lt 20}
Get-WmiObject -Namespace root\CIMV2 -Class win32_bios

########### get installed softwares ####################
Get-WmiObject win32_Product | Select Name,Version,PackageName,Installdate,Vendor | Sort InstallDate -Descending

# get particular process
gwmi -Class win32_process -Filter 'name="powershell.exe"'
# WMI query language (WQL)
gwmi -Query 'select * from win32_process where name like "powershell%"' | select name,__path

############ get com object #########################
gwmi -Class Win32_ClassicCOMClassSetting -ComputerName . -Namespace ROOT\cimv2 | ? {$_.progid -like '*.application.*'} | select progid

gci HKLM:\Software\Classes -ea 0 | ? {$_.PSChildName -match '^\w+\.\w+$' -and (gp "$($_.PSPath)\CLSID" -ea 0)} | ? {$_.PSChildName -like '*.application'}
gci HKLM:\Software\Classes -ea 0 | ? {$_.PSChildName -match '^\w+\.\w+$' -and (gp "$($_.PSPath)\CLSID" -ea 0)} | ? {$_.PSChildName -like 'WScript.Shell'}

# gci -> get-childitem
# -ea -> -erroraction
# ? -> where-object
# gp -> get-itemproperty
# ft -> format-table

######## code sample to invoke a com object ############################
$x = New-Object -com Excel.Application
$x.Visible = $True
Start-Sleep 5
$x.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($x)
Remove-Variable x
