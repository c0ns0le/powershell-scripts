# PowerShell
New-SelfSignedCertificate -DnsName chemdrawdirect-demo.scienceaccelerated.com -CertStoreLocation Cert:\CurrentUser\My

# 为计算机创建本地证书颁发机构
makecert -n "CN=PowerShell Local Certificate Root" -a sha1 `
    -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer `
    -ss Root -sr localMachine
# 从该证书颁发机构生成个人证书
makecert -pe -n "CN=PowerShell User" -ss MY -a sha1 `
    -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer

mmc

cd C:\Users\v-witian\Desktop\scripts\certificate

# password is password
$privateCert = Get-PfxCertificate .\private.pfx
[convert]::ToBase64String($privateCert.RawData)
# export pfx
$privateCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 "C:\Users\v-witian\Desktop\scripts\certificate\private.pfx","password",([System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$data = $privateCert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pfx)
[convert]::ToBase64String($data)
$data | Set-Content -Path output_private.pfx -Encoding Byte


$publicCert = Get-PfxCertificate .\public.cer
[convert]::ToBase64String($publicCert.RawData)
[convert]::ToBase64String($publicCert.GetPublicKey())
# export cert
$publicCert.RawData | Set-Content -Path output_public.cer -Encoding Byte


# base64
[convert]::ToBase64String([byte[]]"123abcABC".ToCharArray())

######### sign code file ###########
$cert = (ls Cert:\CurrentUser\My -CodeSigningCert)[0]
Set-AuthenticodeSignature -Certificate $cert -FilePath .\test.ps1