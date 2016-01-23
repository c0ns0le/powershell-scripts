function Replace-StringInFile ($filePath, $placeHolder, $newValue)
{
    # pattern
    $pattern = "*$placeholder*"

    # read config content
    $config = Get-Content $filePath

    # backup file path
    $backupPath = "$($filePath).bak"

    # if no backup file, make one
    if(-not $(Test-Path $backupPath)){cp $filePath $backupPath}

    # read backup content
    $backup = Get-Content $backupPath

    # find pattern in backup
    for ($i = 0; $i -lt $config.Length; $i++)
    {
        if ($backup[$i] -like $pattern)
        {
            # replace place holder with new value
            $regex = $placeHolder -replace '[$]','[$]'
            $changed = $backup[$i] -replace $regex,$newValue
            # update lines in config
            $config[$i] = $changed
        }
    }

    # save
    sp $filePath IsReadOnly $false
    Set-Content $filePath $config
}

function Modify-ConfigFile
{
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [string[]] $FilePaths,
        [hashtable] $EnvMap,
        [string] $SPFWebServer,
        [string] $SPFDBServer,
        [string] $SPFVMMServer,
        [string] $SPFVMMServer2,
        [bool] $RefreshDB,
        [switch] $Initialize
    )

    foreach ($FilePath in $FilePaths)
    {
        # used when the TFS config file is updated
        # "Undo Pending Changes" should be done before using this parameter
        if ($Initialize)
        {
            rm "$($filePath).bak" -ea 0
        }

        if ($PSBoundParameters.ContainsKey("EnvMap"))
        {
            Replace-StringInFile $FilePath '$SPFWebServer$' $EnvMap.SPFWebServer
            Replace-StringInFile $FilePath '$SPFDBServer$' $EnvMap.SPFDBServer
            Replace-StringInFile $FilePath '$SPFVMMServer$' $EnvMap.SPFVMMServer
            Replace-StringInFile $FilePath '$SPFVMMServer2$' $EnvMap.SPFVMMServer2
        }
        else
        {
            if ($PSBoundParameters.ContainsKey("SPFWebServer")) {Replace-StringInFile $FilePath '$SPFWebServer$' $SPFWebServer}
            if ($PSBoundParameters.ContainsKey("SPFDBServer")) {Replace-StringInFile $FilePath '$SPFDBServer$' $SPFDBServer}
            if ($PSBoundParameters.ContainsKey("SPFVMMServer")) {Replace-StringInFile $FilePath '$SPFVMMServer$' $SPFVMMServer}
            if ($PSBoundParameters.ContainsKey("SPFVMMServer2")) {Replace-StringInFile $FilePath '$SPFVMMServer2$' $SPFVMMServer2}
        }

        if ($PSBoundParameters.ContainsKey("RefreshDB"))
        {
            if ($RefreshDB) {Replace-StringInFile $FilePath '<RefreshDBforTestGroup>true</RefreshDBforTestGroup>' '<RefreshDBforTestGroup>true</RefreshDBforTestGroup>'}
            else {Replace-StringInFile $FilePath '<RefreshDBforTestGroup>true</RefreshDBforTestGroup>' '<RefreshDBforTestGroup>false</RefreshDBforTestGroup>'}
        }
    }
}

############################################
$branch = "Vmm2"

$file1 = "C:\CDM_SFE\Branches\OnPrem\Improvements\SPF_$branch\OnPrem\SCSPF\Test\ProductTest\SPF.Test\VMM\SPF.Test.VMM.config"
$file2 = "C:\CDM_SFE\Branches\OnPrem\Improvements\SPF_$branch\OnPrem\SCSPF\Test\ProductTest\SPF.Test\SPF.Test.Common.TestBase\configFiles\SPF.Test.MultiTenancy.xml"

$spf = 'scxspf-ws8-65'
$db = 'scxspf-ws8-64'
$vmmserver1 = 'scxspf-ws8-63'
$vmmserver2 = 'scxspf-ws8-62'

$cti = @{SPFWebServer="scxspf-ws8-45";SPFDBServer="scxspf-ws8-44";SPFVMMServer="scxspf-ws8-43";SPFVMMServer2="scxspf-ws8-42"}

#Modify-ConfigFile $file1,$file2 -SPFWebServer $spf -SPFDBServer $db -SPFVMMServer $vmmserver1 -SPFVMMServer2 $vmmserver2
Modify-ConfigFile $file1,$file2 -EnvMap $cti -RefreshDB $false
