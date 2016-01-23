$RedCola = Get-CertClient RedCola
$BlueCola = Get-CertClient BlueCola

# add RedCola tenant
$tenantName = "ta_RedCola"
$ssuName = "ssu_RedCola"
$userID = 'SCX\vmtest'

$tenant = New-LocalObject Tenant
$tenant.Name = $tenantName
$tenant.IssuerName = $RedCola.IssuerName
$tenant.AuthenticationKey = $RedCola.GetPublicKey()

Add-Object $tenant

# link tenant with stamps
$tenant = Get-Object Tenant -Name $tenantName
$stamp1 = (Get-Object server -Name $vmmserver -Expand Stamps).Stamps[0]
Add-Link -Source $tenant -SourceProperty "Stamps" -Target $stamp1
$stamp2 = (Get-Object server -Name $vmmserver2 -Expand Stamps).Stamps[0]
Add-Link -Source $tenant -SourceProperty "Stamps" -Target $stamp2
# $stamp3 = (Get-Object server -Name $vmmserver3 -Expand Stamps).Stamps[0]
# Add-Link -Source $tenant -SourceProperty "Stamps" -Target $stamp3

# add member
$UserRole = Get-Object UserRole -Name $tenantName
$UserRole.AddMember.Add($userID)

Set-Object $UserRole

# add permisson
<#
$UserRole = Get-Object UserRole -Name $tenantName
$userPermCol = New-LocalObject UserRolePermission -GenericCollection ObservableCollection
$userPerm = New-LocalObject UserRolePermission
$userPerm.StampId = $stampid
$userPerm.Permission.Add("AuthorVMNetwork")
$userPermCol.Add($userPerm)
$UserRole.PermissionInput = $userPermCol

Set-Object $UserRole
#>

# add resourece
<#
$UserRole = Get-Object UserRole -Name $tenantName
$resourceCol = New-LocalObject UserRoleResource -GenericCollection ObservableCollection
$resource = New-LocalObject UserRoleResource
$resource.ResourceType = 'VirtualMachine'
$vm = Get-Object VirtualMachine -Name WillTestNewVM
$resource.Resource = $vm.ID
$resource.StampId = $vm.StampId
$resourceCol.Add($resource)
$UserRole.AddResource = $resourceCol

Set-Object $UserRole
#>

# create a SSU under tenant
$taClient = New-LocalObject -WebClient -EnableToken -Tenant $tenantName -UserName $userID -CertClient $RedCola
$UserRole = New-LocalObject UserRole
$UserRole.Name = $ssuName
$UserRole.UserRoleProfile = 'SelfServiceUser'

$taClient | Add-Object $UserRole

# Add member to SSU
$UserRole = $taClient | Get-Object UserRole -Name $ssuName
$UserRole.AddMember.Add($userID)

$taClient | Set-Object $UserRole

# use OBO
$taClient = New-LocalObject -WebClient -EnableToken -Tenant $tenantName -UserName $userID -CertClient $RedCola
$ssuClient = New-LocalObject -WebClient -EnableToken -Tenant $tenantName -UserRole $ssuName -UserName $userID -CertClient $RedCola