$ln = Get-Object LogicalNetwork -Name paLogicalNet -StampId $stampid
$raa = Get-Object RunAsAccount -Name scxsvc -StampId $stampid

# add vmnetwork with gateway
$newvmn = New-LocalObject vmnetwork
$newvmn.Name = 'vmnetwork01'
$newvmn.StampId = $ln.StampId
$newvmn.LogicalNetworkId = $ln.ID

    # auto select cert
    $newGateway = New-LocalObject VPNVMNetworkGateway
    $newGateway.TargetVPNIPv4Address="1.1.1.1"
    $newGateway.AuthenticationMethod = "MachineCertificates"
    $newvmn.VPNGateway = $newGateway

    # cert path
    $newGateway = New-LocalObject VPNVMNetworkGateway
    $newGateway.TargetVPNIPv4Address="1.1.1.1"
    $newGateway.AuthenticationMethod = "MachineCertificates"
    $newGateway.AutoSelectCertificate = $false
    $newGateway.CertificateFilePath = "C:\Users\scxsvc\Desktop\SPFCer.cer"
    $newvmn.VPNGateway = $newGateway

    # run as account
    $newGateway = New-LocalObject VPNVMNetworkGateway
    $newGateway.TargetVPNIPv4Address="1.1.1.1"
    $newGateway.AuthenticationMethod = "PSKOnly"
    $newGateway.RunAsAccountID = $raa.ID
    $newvmn.VPNGateway = $newGateway

Add-Object $newvmn

# disconnect gateway
$vmn = $newvmn
$vmn = Get-Object VMNetwork -Name vmnetwork01

$vmn.VPNGateway = $null
$vmn.VPNGateway = $newGateway

Set-Object $vmn

# remove vmnetwork
$vmn = Get-Object VMNetwork -Name vmnetwork01
Remove-Object $vmn
