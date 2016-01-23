$tenantName = "ta_RedCola"
$UserRole = Get-Object UserRole -Name $tenantName -Expand VMNetworkQuota

$UserRole.VMNetworkQuota

$quotaCol = New-LocalObject VMNetworkQuota -GenericCollection ObservableCollection
$quota = New-LocalObject VMNetworkQuota
$quota.StampId = $stampid
$quota.VMNetworkMaximum = 2
$quota.VMNetworkMaximumPerUser = 3
$quotaCol.Add($quota)
$UserRole.VMNetworkQuota = $quotaCol

Set-Object $UserRole

$taClient = New-LocalObject -WebClient -EnableToken -Tenant $tenantName -UserName $userID -CertClient $RedCola
$UserRole = $taClient | Get-Object UserRole -Name $tenantName -Expand VMNetworkQuota