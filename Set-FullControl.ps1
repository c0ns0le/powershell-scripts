function Set-FullControl
{
    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true,Mandatory=$true,Position=0)]
        $file
    )

    Begin
    {
    }
    Process
    {
        $a = $file.GetAccessControl()
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule BUILTIN\Users,([System.Security.AccessControl.FileSystemRights]::FullControl),([System.Security.AccessControl.AccessControlType]::Allow)
        $a.AddAccessRule($rule)
        $file.SetAccessControl($a)
    }
    End
    {
    }
}