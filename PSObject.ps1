$p = (Get-WMIObject Win32_Process)[0]

Get-WMIObject Win32_Process | Get-Member -View Base # Members of underlying .NET object only
# Adapted Type System (ATS)
Get-WMIObject Win32_Process | Get-Member -View Adapted # Members of object as adapted by PowerShell
# Extended Type System (ETS)
Get-WmiObject Win32_Process | Get-Member -View Extended # Members added by PowerShell

##### equals #####
$p = New-Object System.Object
$p.Equals($p)
$p.psobject

$p1 = New-Object psobject $p
$p1.Equals($p1)

$ps = New-Object psobject
$ps.Equals($ps)