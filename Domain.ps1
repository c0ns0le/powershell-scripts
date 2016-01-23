# leave domain
Remove-Computer -Workgroup workgroup
Restart-Computer

# join domain
$credential = New-Object System.Management.Automation.PsCredential("scx\scxsvc", (ConvertTo-SecureString "OpsMgr2007R2" -AsPlainText -Force))
Add-Computer -DomainName scx.com -Credential $credential
Restart-Computer