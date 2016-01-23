#Setup Database

$stp= New-SCSPFStamp -Name Gold

$key = "MIICGjCCAYOgAwIBAgIQeJe5qR+4T6VJNZYtWjhErzANBgkqhkiG9w0BAQQFADAgMR4wHAYDVQQDExVBQ1MyQ2xpZW50Q2VydGlmaWNhdGUwHhcNMTExMDEwMDcwMDAwWhcNNDExMjMxMDcwMDAwWjAgMR4wHAYDVQQDExVBQ1MyQ2xpZW50Q2VydGlmaWNhdGUwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKjtrnJ+bduREosQ9+SH1ocI13wlxStLi8y5heGPo5UBcuf0hYRq4PvjwEY2twebP6iwxjwGqhu224UDUfPWMhQBOh+NFnv9GHAh+W4jFJxvTCcyXTkZRFqgAYRjMvyxzNeHVqn4AJ/ddKGf1fMVCuKhPYteHy2yNacXujucPP6/AgMBAAGjVTBTMFEGA1UdAQRKMEiAEFD3/7uhGcI2nSHZqB0bN66hIjAgMR4wHAYDVQQDExVBQ1MyQ2xpZW50Q2VydGlmaWNhdGWCEHiXuakfuE+lSTWWLVo4RK8wDQYJKoZIhvcNAQEEBQADgYEAkgxktVU5e8TVoigsDRm4qyw6gM/kie3e6dFM0T1BFoQV0PW9W9yKPiP72eTi+331tLFnwDxz5RJLABctAO71plwtREd0k3E0Jsju+Web+u8YcCD43aViQXgXRrY5ghDGwpFRcaNa1PnYY5nk3DYfyZZdz1L+fb30VDiugdf7dBI="

$tenant=new-scspftenant -Name Administrator -Key $key -IssuerName "Issuer01" -Stamps $stp

New-SCSPFTenantUserRole -Tenant $tenant -Name "SPFTestSSU"

New-SCSPFServer -Name $VMMServer -ServerType 0 -Stamp $stp


################ Multiple Tenant-Stamps ##################################
$VMMServer1 = "scxspf-ws8-24"
$VMMServer2 = "scxspf-ws8-35"

$env:path = $env:path + ";C:\inetpub\SPF\SC2012\VMM"

 $global:ServerPorts = @{$VMMServer1="8100"; $VMMServer2="8100"}

import-module "C:\Program Files\Common Files\Service Provider Foundation\spfadmin\spfadmin.psd1"
Import-module "C:\Program Files\Microsoft System Center 2012\Virtual Machine Manager\bin\psModules\virtualmachinemanager\virtualmachinemanager.psd1"

$stp1= New-SCSPFStamp -Name Gold
$stp2= New-SCSPFStamp -Name Silver

$key = "MIICGjCCAYOgAwIBAgIQeJe5qR+4T6VJNZYtWjhErzANBgkqhkiG9w0BAQQFADAgMR4wHAYDVQQDExVBQ1MyQ2xpZW50Q2VydGlmaWNhdGUwHhcNMTExMDEwMDcwMDAwWhcNNDExMjMxMDcwMDAwWjAgMR4wHAYDVQQDExVBQ1MyQ2xpZW50Q2VydGlmaWNhdGUwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKjtrnJ+bduREosQ9+SH1ocI13wlxStLi8y5heGPo5UBcuf0hYRq4PvjwEY2twebP6iwxjwGqhu224UDUfPWMhQBOh+NFnv9GHAh+W4jFJxvTCcyXTkZRFqgAYRjMvyxzNeHVqn4AJ/ddKGf1fMVCuKhPYteHy2yNacXujucPP6/AgMBAAGjVTBTMFEGA1UdAQRKMEiAEFD3/7uhGcI2nSHZqB0bN66hIjAgMR4wHAYDVQQDExVBQ1MyQ2xpZW50Q2VydGlmaWNhdGWCEHiXuakfuE+lSTWWLVo4RK8wDQYJKoZIhvcNAQEEBQADgYEAkgxktVU5e8TVoigsDRm4qyw6gM/kie3e6dFM0T1BFoQV0PW9W9yKPiP72eTi+331tLFnwDxz5RJLABctAO71plwtREd0k3E0Jsju+Web+u8YcCD43aViQXgXRrY5ghDGwpFRcaNa1PnYY5nk3DYfyZZdz1L+fb30VDiugdf7dBI="

$tenant=new-scspftenant -Name  Administrator -Key $key -IssuerName "Issuer01" -Stamps $stp1, $stp2

New-SCSPFTenantUserRole -Tenant $tenant -Name "SPFTestSSU"

New-SCSPFServer -Name $VMMServer1 -ServerType 0 -Stamp $stp1
New-SCSPFServer -Name $VMMServer2 -ServerType 0 -Stamp $stp2

(Get-SCSPFTenant -Name Administrator).stamps
