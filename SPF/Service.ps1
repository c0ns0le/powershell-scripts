# create a service
$cloud = Get-Object Cloud -Name willcloud
$st = Get-Object ServiceTemplate -Name willst

$service = New-LocalObject Service
# $service.Name = 'willservice'
$service.NewServiceDeployment.ServiceConfiguration.Name = 'willservice'
$service.StampId = $cloud.StampId
$service.CloudId = $cloud.ID
$service.ServiceTemplateId = $st.ID

Add-Object $service

# get a service
$service = Get-Object Service -Name asdfdsfefew

$service.ServicingWindow.Name = 'willsw'

Set-Object $service

