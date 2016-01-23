# IIS
# IIS Management Scripts and Tools
# IIS Security Basic Authentication
# IIS Security Windows Authentication
# IIS Application Development ASP.NET 4.5
# .NET Features 4.5 WCF Services HTTP Activation
# Management OData IIS Extension
Add-WindowsFeature 'Web-Server','Web-Scripting-Tools','Web-Basic-Auth','Web-Windows-Auth','Web-Asp-Net45','NET-WCF-HTTP-Activation45','ManagementOdata'

# SpiderMan Server Configuration
Enable-WSManCredSSP -Role Server -Force

$cred = Get-Credential -UserName '' -Message 'Your Microsoft Credential'
New-PSDrive -name share -PSProvider FileSystem -Root \\scxfiles\team\SPF\ -Credential $cred

# ASP.NET MVC 4 RC
start share:\AspNetMVC4Setup.exe

# WCF Data Services 5.0 for OData V3
start share:\WcfDataServices.exe

# test sign
start share:\testsign.cer
