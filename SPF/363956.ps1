# Create VM with additional OS data(Login/Password, domain join, Product key)
# VIrtualMachineTests.xml #363956
 
# Prepare
# 1. a VHD "SCX-WS7-X64.vhd"
# 2. a cloud "Cloud_363956", the cloud should have a logical network
$cloud = Get-Object cloud -Name Cloud_363956
# 3. a template "VMTemplate_ws7_363956",the template's OS type should be '64-bit edition of Windows Server 2008 R2 Enterprise'
$vt = Get-Object vmtemplate -Name VMTemplate_ws7_363956
# 4. create a VM using SPF
$newVM = New-LocalObject virtualmachine
$newVM.Name = 'VM_363956'
$newVM.StampId = $cloud.StampId
$newVM.CloudId = $cloud.ID
$newVM.VMTemplateId = $vt.ID
$newVM.FullName = "SCX Team"
$newVM.OrganizationName="Microsoft";
$newVM.ProductKey="489J6-VHDMP-X63PK-3K798-CPX3Y";
$newVM.LocalAdminUserName="wilson";
$newVM.LocalAdminPassword="User@123"
$newVM.Domain="scx.com";
$newVM.UserName="scx\scxsvc";
$newVM.Password="OpsMgr2007R2"

Add-Object $newVM

# Do these steps manually:
# 1. Please logon the created VM "VM_363956" with scx\scxsvc, ensure it is added into scx.com (It means this test case pass)
# 2. Join it out of scx.com (This is the reason why we do this case manually. If we don't do this step, this VM's info will be retained in DC)
# 3. Restart the VM
# 4. Stop the VM
# 5. Delete the VM


########################## Create VM using VMM PS #################################
$vt = Get-SCVMTemplate -VMMServer localhost -Name VMTemplate_2k3_363956
$vmhost = Get-VMHost -VMMServer localhost
$joinDomain = New-Object pscredential 'scx\scxsvc',(ConvertTo-SecureString -String OpsMgr2007R2 -AsPlainText -Force)
$localAdmin = New-Object pscredential 'Administrator',(ConvertTo-SecureString -String OpsMgr2007R2 -AsPlainText -Force)
New-SCVirtualMachine -VMHost $vmhost -Path 'C:\ProgramData\Microsoft\Windows\Hyper-V' -Name VM_CreatedByVmm -VMTemplate $vt -FullName "SCX Team" -OrganizationName Microsoft -ProductKey "VCGMC-M6B4Y-34YDW-9XH3H-WV67M" -Domain scx.com -DomainJoinCredential $joinDomain -LocalAdministratorCredential $localAdmin
