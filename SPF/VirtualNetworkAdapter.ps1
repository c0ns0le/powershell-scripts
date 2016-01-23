$vmn1 = Get-Object VMNetwork -Name VMNetworkTests_VMNetwork01_460648
$vmn2 = Get-Object VMNetwork -Name VMNetworkTests_VMNetwork02_460648

$vm = Get-Object virtualmachine -Name VMNetworkTests_VM01_460648 -Expand virtualnetworkadapters
$vm = $taClient | Get-Object virtualmachine -Name VMNetworkTests_VM01_460648 -Expand virtualnetworkadapters
$vna = $vm.VirtualNetworkAdapters[0]

$vna.MACAddressType = 'Static'
$vna.MACAddressType = 'Dynamic'

$vna.VMNetworkId = $vmn1.ID
$vna.VMNetworkId = $vmn2.ID
Set-Object $vna
$taClient | Set-Object $vna

