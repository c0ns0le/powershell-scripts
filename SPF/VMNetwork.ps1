ipmo D:\Sandbox\private\v-witian\SPF.Test\SPF.Test.PSModule\bin\Debug\psModules\spfweb -Verbose

# TA can create VM subnet and IP pool
# 1:n (one LogicalNetwork can create multiple VMNetwork)
$lnName = 'paLogicalNet'
$vmnName = 'Avaz01'

# no VM subnet and IP pool
# 1:1
$lnName = 'NoIsolation'
$vmnName = 'NoIsolation'

# TA can NOT create VM Subnet an IP pool
# 1:n
$lnName = 'VLAN'
$vmnName = 'VLAN01'

# Similar to VLAN
# 1:n
$lnName = 'External'
$vmnName = 'External01'

# get logical network
$ln = Get-Object LogicalNetwork -Name $lnName -StampId $stampid

$newvmn = New-LocalObject vmnetwork
$newvmn.Name = 'vmnetwork01'
$newvmn.StampId = $ln.StampId
$newvmn.LogicalNetworkId = $ln.ID

Add-Object $newvmn

# get VM Network
$vmn = Get-Object vmnetwork -StampId $stampid -Name vmnetwork01

# create VM Subnet
$subnet = New-LocalObject VMSubnet
$subnet.StampId = $stampid
$subnet.Name = 'subnet01'
$subnet.VMNetworkId = $vmn.ID
$subnet.Subnet = '192.168.1.0/24'

Add-Object $subnet

# get VM subnet
$subnet = Get-Object vmsubnet -StampId $stampid -Name subnet01

# create IP Pool
$newipp = New-LocalObject StaticIPAddressPool
$newipp.StampId = $stampid
$newipp.Name = 'ipPool01'
$newipp.VMSubnetId = $subnet.ID
$newipp.Subnet = '192.168.1.0/24'
$newipp.DNSServers.Add("192.168.1.1")
$newipp.DNSSuffix = "DNSSuffix"
$newipp.DNSSearchSuffixes.Add("192.168.1.2")

Add-Object $newipp

# get IP Pool
$ippool = Get-Object StaticIPAddressPool -StampId $stampid -Name ipPool01