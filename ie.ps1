$ie = New-Object -com InternetExplorer.Application
$ie.Visible = $true
$ie.Navigate2("www.google.com")
#$ie.Document.body.innerText
$ie.Document.title

diff ($ie|gm -View Base) ($ie|gm -View Adapted) -IncludeEqual
diff (""|gm -View Base) (""|gm -View Adapted) -IncludeEqual