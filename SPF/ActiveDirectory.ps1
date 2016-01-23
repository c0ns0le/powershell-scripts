Get-WindowsFeature *ad*
install-WindowsFeature -Name rsat-ad-powershell
ipmo ActiveDirectory

# add outlook group to local group
# 1. expand the outlook email group
# 2. copy them to notepad2
# 3. replace ; with \r\n
# 4. replace .*<([^.]*@.*microsoft.com)>.* with \1
# 5. replace \s*(.*)\s<.*>.* with \1

.\net.exe localgroup spfuser /add
cat $HOME\Desktop\spft.txt | foreach{
.\net.exe localgroup spfuser $_ /add
}

$outlook = new-object -com Outlook.Application
$adlist = $outlook.Session.GetGlobalAddressList()

$groups = $outlook.Session.AddressLists | where {$_.Name -eq 'All Groups'}

$group = $groups.AddressEntries | where {$_.Name -eq 'SC Service Provider Foundation Team'}


$adlist.AddressEntries | where {$_.Name -eq 'CDM Auto and Int SPF CTI Team'}
