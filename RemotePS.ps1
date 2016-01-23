########## Client ##########
Set-Item WSMan:\localhost\Client\TrustedHosts –Value * -Force
# enable CredSSP
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force

########## Server #########
Enable-PSRemoting -Force
# Start service WinRM
Start-Service WinRM
Restart-Service WinRM
# Enable-WSManCredSSP -Role Server
Enable-WSManCredSSP -Role Server
# set max number
Set-Item WSMan:\localhost\Shell\MaxShellsPerUser 100

######### Disable Server ##########
Disable-PSRemoting -Force
Stop-Service WinRM -WhatIf
Set-Service WinRM -StartupType Manual -WhatIf
Remove-Item WSMan:\localhost\Listener\* -Recurse -WhatIf

# config
$rs = 'scxspf-ws8-117'
# $cred = Get-Credential -UserName scx\scxsvc -Message OpsMgr2007R2
$cred = New-Object PsCredential scx\scxsvc,(ConvertTo-SecureString "OpsMgr2007R2" -AsPlainText -Force)

# connect to disconnected session
Get-PSSession -ComputerName $rs -Credential $cred | Connect-PSSession -OutVariable session
Receive-PSSession -Session $session[0]
Disconnect-PSSession $session -IdleTimeoutSec 60*60*1
#Connect-PSSession -ComputerName $rs -Credential $cred

#new a session
# New-PSSession -ConnectionUri http://localhost:5985/WSMAN
$session = New-PSSession -ComputerName $rs -Credential $cred
$session2 = New-PSSession -ComputerName $rs -Credential $cred -Authentication Credssp
Enter-PSSession $session
Enter-PSSession $session2
Exit-PSSession

#====a.invoke a command
$cmd = {
    param($ComputerName,$ServiceName)
    $service = Get-Service -ComputerName $ComputerName -Name $ServiceName
    return $service
}

$service = Invoke-Command -Session $session -ScriptBlock $cmd -ArgumentList scxspf-ws8-117,winrm

icm $session {sleep 10;1/0} -AsJob
Get-Job | Receive-Job
Get-Job | Remove-Job

Invoke-Command -Session $session -ScriptBlock {ls}
Invoke-Command -Session $sessionList -ScriptBlock {cd ..} -ThrottleLimit 32

#====b.import session
Import-PSSession -Session $session -Prefix RS
#====b.import module of session
Import-PSSession -Session $session -Module spfadmin
Import-PSSession -Session $session -Module virtualmachinemanager
#====run a cmdlet
Set-RSLocation
Get-RSLocation
Get-RSChildItem

#job
$job = Invoke-Command -Session $session -ScriptBlock {ls} -AsJob
$cj = $job.ChildJobs[0]
$result = $cj.Output

# enter pssession
Enter-PSSession $session
# ...
Exit-PSSession

# remove pssession
Remove-PSSession $session
Get-PSSession | Remove-PSSession