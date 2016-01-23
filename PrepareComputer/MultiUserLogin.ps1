#install Remote-Desktop-Services
Add-WindowsFeature 'Remote-Desktop-Services'

New-ItemProperty -Force -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name fSingleSessionPerUser -PropertyType dword -Value 0

New-ItemProperty -Force -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name MaxInstanceCount -PropertyType dword -Value 3
