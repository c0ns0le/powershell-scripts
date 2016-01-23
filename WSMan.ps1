$rs = 'scxspf-ws8-23'
$credential = New-Object System.Management.Automation.PsCredential("scx\scxsvc", (ConvertTo-SecureString "OpsMgr2007R2" -AsPlainText -Force))
Connect-WSMan -ComputerName $rs -Credential $credential
ls WSMan:\
cd WSMan:\scxspf-ws8-23
Disconnect-WSMan -ComputerName $rs
Test-WSMan