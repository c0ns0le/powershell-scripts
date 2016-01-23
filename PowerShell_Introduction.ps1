# 命令模式 字符串不需要加引号，除变量和圆括号中的内容外的所有内容均可看作字符串
copy users.txt accounts.txt
copy $src $dest
write-host 2+2

# 表达式模式 以高级语言分析方法来进行分析：若为数字，则原样表示该数字；若为字符串，则需要加引号
2+2
"Hello" + " world"
"abc" * 2
$a = "hi"
$a.length * 13

# PowerShell使用了面向对象方法，基于.Net
$a = ls
$a.GetType()
$a[0].GetType()
$a = $a[0]
$a | Out-Default

# 使用.Net对象/静态方法
$list = New-Object System.Collections.ArrayList
$list.Add(123)
$list.Add('abc')
$list.Count

[string]::Compare("abc","ABC")

# 调用COM组件
$ie = New-Object -ComObject InternetExplorer.Application
$ie.Visible = $true
$ie.Navigate2("google.com")
$ie.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)

# PowerShell命令称为cmdlet。自带有超过100个cmdlet
# 动词-名词
Get-Verb
Get-Process

# 别名
Get-Alias
gal -Definition Get-ChildItem
gal ls
gal ise
# %,foreach -> ForEach-Object
# ?,where -> Where-Object
# cd -> Set-Location
# cls,clear -> Clear-Host
# cp,copy -> Copy-Item
# type,cat -> Get-Content
cp abc abc -ErrorAction 
cp abc abc -ea 0
Set-Alias job Get-Job

# 公共参数
# -confirm 在执行cmdlet前提示用户。
# -debug  提供相关调试信息。-db
# -ErrorAction 提示cmdlet在执行某项操作时可能出现的错误。如：继续，停止等。-ea
# -ErrorVariable  使用一个特定的变量($error)来保存错误信息。-ev
# -OutVariable 用于保存输出信息的变量。-ov
# -OutBuffer 确定在进行下一次管道传递前需要缓存的对象数量。-ob
# -Verbose 为我们提供更多细节。-vb
# -whatif  并不会真正执行cmdlet，只是告诉你会发生什么。
Set-ExecutionPolicy Unrestricted -Confirm
Set-ExecutionPolicy Unrestricted -WhatIf

# PowerShell允许我们像操作驱动器、文件一样对数据、对象等进行操作
Get-PSProvider
Get-PSDrive
cd Variable:
###########################################################################################
# 单引号，双引号
"$a"
'$a'
'"$a"'
"'$a'"
"""$a"""
'''$a'''

# 转义字符 反引号`
"`$a"
"`0" -eq ''
"abc`n123"
"abc`t123"

# number
3 -eq 4
3 -ne 5
3 -lt 4
3 -le 4
3 -gt 4
3 -ge 4

# string
"abc" -match "a"
"abc" -like "a*"
"abc" -notlike "a*"
"abc123" -replace "a","b"
'abc' -eq 'ABC'
'abc' -ieq 'ABC'
'abc' -ceq 'ABC'

# 集合
1,2,3 -contains 2
1,2,3 -notcontains 2

# 类型
$list -is [object]
$list -as [object]
[object]$list

# logical
-not $true
!$true
$true -and $false
$true -or $false

# binary
0xFF -band 0x02
0xFF -bor 0x34
-bnot 0xFF

# array,hashtable
$a = @()
$a = @(0,1,2,3,"abc")
$a += 'new'
$a + $a
$a[-1]
$a[1..9]
$a[0,2,4]

$h = @{}
$h = @{name='Wilson';age='25'}
$h['name']
$h.age
$h.id = 123
$h.Remove("name")
$h.Clear()
###########################################################################################
# 常用cmdlet
Get-Help
help ls
Get-Command
Get-Member -InputObject $a
ls | Get-Member
New-Item D:\temp\a.txt -ItemType file
Get-Content D:\temp\a.txt
Set-Content D:\temp\a.txt
ls -Path D:\temp | where {$_.LastWriteTime -gt "2012/15/06"}
Get-Process | Out-GridView
Get-Process | Export-Csv -Path D:\temp\p.csv
start D:\temp\p.csv
Start-Job -ScriptBlock {ls}
Get-Job | Wait-Job | Receive-Job

# 预定义变量
Get-Variable
$^
$$
$?
$_
$input
$Error

$null
$true
$false

$HOME
$profile
$Host
$PSHOME
Set-Variable a 'xyz'

# 函数/ps1脚本
function MyFunction ($param1, $param2)
{
   "param1: $param1"
   "param2: $param2"
}

function MyFunction
{
    Param($param1, $param2)
    #...
}

# 管道/管道函数
function Get-Name
{
    Begin
    {
    "Begin..."
    '=================='
    }
    Process
    {
    $_.name
    sleep -Milliseconds 500
    }
    End
    {
    '=================='
    "End..."
    }
}

ls | Get-Name

ls | where {$_.name -like '*.txt'} | Get-Name

########################################
Import-Module

#########################################
# remote powershell
$rs = 'scxspf-ws8-23'
$cred = New-Object System.Management.Automation.PsCredential scx\scxsvc,(ConvertTo-SecureString "OpsMgr2007R2" -AsPlainText -Force)
$session = New-PSSession -ComputerName $rs -Credential $cred
Invoke-Command -Session $session -ScriptBlock {ls}
Enter-PSSession $session
Exit-PSSession