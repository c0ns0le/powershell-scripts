$vt = Get-Object vmtemplate -Name willvt
$vt.GrantedToList
# $vt.GrantedToList.Clear()

# get user role
$role = Get-Object UserRole -Name ssu_RedCola

$grant1 = New-LocalObject UserAndRole
$grant1.RoleID = $role.ID
$grant2 = New-LocalObject UserAndRole
$grant2.RoleID = $role.ID
$grant2.User = 'scx\vmtest'
$vt.GrantedToList.Add($grant1)
$vt.GrantedToList.Add($grant2)

Set-Object $vt

# OBO
$taClient = New-LocalObject -WebClient -EnableToken -Tenant $tenantName -UserName $userID -CertClient $RedCola

$vt = $taClient | Get-Object vmtemplate -Name willvt

$grantList = New-LocalObject UserAndRole -GenericCollection ObservableCollection
$grant1 = New-LocalObject UserAndRole
$grant1.RoleID = $role.ID
$grantList.Add($grant1)
$grant2 = New-LocalObject UserAndRole
$grant2.RoleID = $role.ID
$grant2.User = 'scx\vmtest'
$grantList.Add($grant2)
$vt.GrantedToList = $grantList

$taClient | Set-Object $vt

$vt = Get-Object vmtemplate -Name willvt;Set-Object $vt