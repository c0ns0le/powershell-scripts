$productList = ls HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall

$productList | foreach{
if($_.GetValue("DisplayName") -like "*System Center*"){
$_.GetValue("DisplayName")
$_.GetValue("DisplayVersion")
}
}
