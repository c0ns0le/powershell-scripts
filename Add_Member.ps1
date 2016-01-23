Update-TypeData -TypeName System.String -MemberType NoteProperty -MemberName Desc -Value test

#[Microsoft.PowerShell.ToStringCodeMethods] | gm -Static

$person = New-Object psobject
$person | Add-Member -MemberType NoteProperty -Name FirstName -Value Wilson
$person | Add-Member -MemberType NoteProperty -Name LastName -Value Tian
$person | Add-Member -MemberType ScriptProperty -Name FullName -Value {$this.FirstName+" "+$this.LastName}
$person | Add-Member -MemberType ScriptMethod -Name ToString -Value {$this.FirstName+" "+$this.LastName} -Force
$person | Add-Member -MemberType CodeProperty -Name Type -Value ([Microsoft.PowerShell.ToStringCodeMethods].GetMethod("Type"))

