$dir = 'D:\Sandbox\private\v-witian\SPF.Test\SPF.Test.PSModule\bin\Debug'
cd $dir
ipmo .\psModules\spfweb -Verbose

$SPFServer
# $SPFServer = 'scxspf-ws8-65'
$vmmserver = 'scxspf-ws8-06'
$vmmserver2 = 'scxspf-ws8-09'
$vmmserver3 = 'scxspf-ws8-117'

## Initialize-SPFDatabase $vmmserver $vmmserver2

$stampid = Get-StampidForServer $vmmserver
$stampid2 = Get-StampidForServer $vmmserver2
$stampid3 = Get-StampidForServer $vmmserver3

$vmm = New-LocalObject -WebClient

# cloud
$cloud = Get-Object cloud -Name CloudSCX -StampId $stampid -Expand LogicalNetworks,CapabilityProfiles,QuotaAndUsageComponents
$cloud = Get-Object cloud -Name willcloud
Get-AssociationObject $cloud QuotaAndUsageComponents

# vm template
$vt = Get-Object vmtemplate -Name willvt

# VHD
$vhd = Get-Object VirtualHardDisk -Name 'Blank Disk - Small.vhd' -StampId $stampid

# vm
$vm = Get-Object virtualmachine -Name VM_363956
$vm = Get-Object virtualmachine -Name VirtualMachineTests_VM01_388078 -Expand VirtualNetworkAdapters
$vm.MostRecentTask.StartTime
$vm.Operation = 'Repair'
$vm.Dismiss = $true
Set-Object $vm

# create a vm
$newVM = New-LocalObject virtualmachine
$newVM.Name = 'willvm'
$newVM.StampId = $cloud.StampId
$newVM.CloudId = $cloud.ID
$newVM.VMTemplateId = $vt.ID
# $newVM.VirtualHardDiskId = $vhd.ID

$vnaInput = New-LocalObject NewVMVirtualNetworkAdapterInput
# $vnaInput.MACAddressType = 'Static'
# $vnaInput.MACAddress = Get-RandomMacAddress
$vnaInput.VMNetworkName = 'vmnetwork'
$vnaInputCol = New-LocalObject NewVMVirtualNetworkAdapterInput -GenericCollection ObservableCollection
$vnaInputCol.Add($vnaInput)
$newVM.NewVirtualNetworkAdapterInput = $vnaInputCol

Add-Object $newVM

# remove a vm
Remove-Object $newVM

# virtual DVD drive
$dvd = Get-Object VirtualDVDDrive -Name VirtualDVDDriveTests_VM01_310414 -StampId $stampid
$dvd = Get-AssociationObject $vm VirtualDVDDrives
$vm = Get-AssociationObject $dvd ParentVM
Remove-Object $dvd

# virtual network adapter
$vna = Get-Object VirtualNetworkAdapter -Filter @{VMId=$null} -StampId $stampid
$vna = (Get-AssociationObject $vm VirtualNetworkAdapters)[0]
$vna = $vm.VirtualNetworkAdapters[0]
$vna.VMId = $vm.ID
$vna.VMNetworkName=$null
Set-Object $vna

# vmnetwork
$vmns = Get-Object vmnetwork
$vmns | select Name,ID

$vmn = Get-Object vmnetwork -Name PublicVMN
$vmn = $vmn[0]
Get-AssociationObject $vmn grantedtolist

# vna -- vmn
$vna.VMNetworkName = $null
$vna.VMNetworkName = $vmns[0].Name
$vna.VMNetworkName = $vmns[1].Name
$vna.VMNetworkName = $vmns[2].Name
$vna.VMNetworkName = $vmns[3].Name
$vna.VMNetworkName = $vmns[4].Name
$vna.VMNetworkName = $vmns[5].Name

Set-Object $vna
