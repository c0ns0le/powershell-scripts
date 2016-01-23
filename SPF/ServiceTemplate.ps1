$st = Get-Object ServiceTemplate -Name willst -Expand ComputerTierTemplates
$vt = Get-AssociationObject $st.ComputerTierTemplates[0] VMTemplate
$vna = Get-AssociationObject $vt VirtualNetworkAdapters
$vna
