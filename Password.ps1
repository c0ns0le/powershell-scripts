#A.same computer and username to recover the password
Read-Host "Your Password" -AsSecureString | ConvertFrom-SecureString | Out-File D:\temp\password.txt
$password = cat D:\temp\password.txt | ConvertTo-SecureString

#B.use the key parameter
$s = ""
1..16 | foreach{
$s += [char]$_
}
$key = $s.ToCharArray()

Read-Host "Your Password" -AsSecureString | ConvertFrom-SecureString -Key $key | Out-File D:\temp\password.txt
$password = cat D:\temp\password.txt | ConvertTo-SecureString -Key $key

#################
$credential = New-Object pscredential scx\scxsvc,$password

function BackToString{
    param($SecureString)

    $ptr = [System.IntPtr]::Zero
    $result

    try{
        $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($SecureString)
        $result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($ptr)
    }
    finally{
        [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($ptr)
    }

    return $result
}

BackToString $password