$branch = "Vmm2"

$VMM = "C:\CDM_SFE\Branches\OnPrem\Improvements\SPF_$branch\OnPrem\SCSPF\bin\Debug\Tests\ProductTests\VMM"
cd $VMM\TestVarMaps

ls *.log | foreach{rm $_}
ls *_report.xml | foreach{rm $_}

.\MCF.exe /m:CoreScenarioTests.xml /v:309955


.\MCF.exe /m:VirtualHardDiskTests.xml /v:310319

.\MCF.exe /m:VirtualDiskDriveTests.xml /v:310404

.\MCF.exe /m:VirtualMachineTests.xml /v:369431

.\MCF.exe /m:VirtualDVDDriveTests.xml /v:310317

#update proxy.cs
C:\CDM_SFE\Branches\OnPrem\Improvements\SPF_Vmm2\OnPrem\SCSPF\Externals\Microsoft.Data.Services\bin\.NETFramework\DataSvcUtil.exe /out:$HOME\Desktop\proxy.cs `
/uri:"http://scxspf-ws8-15:8090/SC2012/VMM/Microsoft.Management.Odata.svc" /version:3.0 /dataservicecollection

start C:\CDM_SFE\Branches\OnPrem\Improvements\SPF_Vmm2\OnPrem\SCSPF\Test\UnitTests\VMMProxy

#================ run a new mcf===========================
function New-MCF ($VmmPath, $Number, $McfArgs)
{
$NewVmmPath = "$VmmPath-$Number"

#copy files
cp $VmmPath $NewVmmPath -Container -Recurse -Force

$cd = "cd $NewVmmPath\TestVarMaps;"

#clean logs
$clean = 'ls *.log | foreach{rm $_}; ls *_report.xml | foreach{rm $_};'

#run
start powershell "-NoExit -Command $cd $clean .\MCF.exe $McfArgs"
}


New-MCF $VMM '111' '/m:CoreScenarioTests.xml /v:309955'

New-MCF $VMM '222' '/m:CoreScenarioTests.xml /v:309955'

New-MCF $VMM '333' '/m:VirtualSCSIAdapterTests.xml /v:310427'