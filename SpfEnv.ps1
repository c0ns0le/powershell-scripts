$VMMServer = "scxspf-ws8-17"

#Setup Environment

Set-ExecutionPolicy RemoteSigned -Scope Process -Force

ipmo 'C:\Program Files\Microsoft System Center 2012\Virtual Machine Manager\bin\psModules\virtualmachinemanager'

ipmo 'C:\Program Files\Common Files\Service Provider Foundation\spfadmin'

ipmo 'C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\System.Web.dll'
ipmo 'C:\Users\scxsvc\Desktop\System.Web.dll'

$env:path = $env:path + ";C:\inetpub\SPF\SC2012\VMM"

cd 'C:\inetpub\SPF\SC2012\VMM'

$global:ServerPorts =@{$VMMServer="8100"}

#get stampid for server
$server = Get-SCSPFServer | where {$_.Name -eq $VMMServer}
$stamp = Get-SCSPFStamp -Server $server
$StampID = $stamp.ID

#test the environment
.\Get-SCVirtualMachine2.ps1 -StampId $StampID | select Name,ID,Status
$vm = .\Get-SCVirtualMachine2.ps1 -StampId $StampID | where {$_.Name -eq 'vm_wilson'}

#find something
ls *.ps1 | foreach{echo $_; $_ | get-content | foreach {$_ | Select-String 'onbehalfof\('}}