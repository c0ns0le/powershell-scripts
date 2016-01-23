$cloudName = 'willTestCloud'
$templateName = 'willTestVT'

#cloud
$cloud = Get-SCCloud | where {$_.Name -eq $cloudName}
$CloudID = $cloud.ID

#vm template
$template = Get-SCVMTemplate | where {$_.Name -eq $templateName}
$VMTemplateID = $template.ID

# new a 2k3 VM
$vm = .\New-SCVirtualMachine2.ps1 -StampId $StampID -CloudId $CloudID -VMTemplateId $VMTemplateID -Name 'CreateVM_VM03_363956' -FullName 'SCX Team' -OrganizationName 'Microsoft' -ProductKey 'VCGMC-M6B4Y-34YDW-9XH3H-WV67M' -LocalAdminUserName 'Administrator' -LocalAdminPassword 'fr0p!l3ks'

# find something
ls *.ps1 | foreach{echo $_; $_ | get-content | foreach {$_ | Select-String 'onbehalfof\('}}

#logical network
.\Get-SCLogicalNetwork2.ps1 -StampId $StampID | select Name,ID
$lnet = .\Get-SCLogicalNetwork2.ps1 -StampId $StampID | where {$_.Name -eq 'SCXVS2'}

#virtual network adapter
$vm = .\Get-SCVirtualMachine2.ps1 -StampId $StampID -Name willtestvm                                                                       
$vna = .\New-SCVirtualNetworkAdapter2.ps1 -StampId $StampID -VMId $vm.ID -IsSynthetic $true

#vm network
$vmnet = .\New-SCVMNetwork2.ps1 -StampId $StampID -Name 'willTestVMNetwork' -LogicalNetworkID $lnet.ID
.\Set-SCVirtualNetworkAdapter2.ps1 -StampId $StampID -ID $vna.ID -VMNetworkName 'willTestVMNetwork'