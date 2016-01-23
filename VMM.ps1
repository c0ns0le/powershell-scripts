$vmmserver = 'scxvmm2012'
$name = 'scxspf-ws8-79'

#####################################################
ipmo 'C:\Program Files\Microsoft System Center 2012\Virtual Machine Manager\bin\psModules\virtualmachinemanager'

$vms = @{}

function Get-VM ($name)
{
    if (-not $vms.ContainsKey($name))
    {
        $vms[$name] = Get-SCVirtualMachine -VMMServer $vmmserver -Name $name
    }

    $vms[$name]
}

function Start-VM ($name)
{
    $vm = Get-VM $name

    while($vm.Status -ne 'PowerOff')
    {
        sleep 15
    }

    Start-SCVirtualMachine -VM $vm -RunAsynchronously
}

function Create-Checkpoint ($name, $checkpointName)
{
    $vm = Get-VM $name

    while($vm.Status -ne 'PowerOff')
    {
        sleep 15
    }

    New-SCVMCheckpoint -VM $vm -Name $checkpointName -RunAsynchronously
}

#####################################################

# Create-Checkpoint $name CleanOS; Start-VM $name
# Create-Checkpoint $name GeneralConfig; Start-VM $name
# Create-Checkpoint $name WADK-8501; Start-VM $name
Create-Checkpoint $name ReadyForAutomation; Start-VM $name