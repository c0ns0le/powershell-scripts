$PSDefaultParameterValues = 
@{
"Send-MailMessage:SmtpServer"="Server01AB234x5";
"Get-WinEvent:LogName"="Microsoft-Windows-PrintService/Operational";
"Get-*:Verbose"=$true
}


function f
{
    #[CmdletBinding()]
    Param($a,$b,$c=2)

    "__PSBoundParameters__"
    $PSBoundParameters

    "__a__"
    $a
    "__b__"
    $b
    "__c__"
    $c

    "__args__"
    $args

    "__input__"
    $input

    "_____"
    $_
}

"this is input","input2" | f 1 2 3 4