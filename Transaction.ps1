Start-Transaction
Get-Transaction
New-Item HKCU:\Environment\test -UseTransaction
ls HKCU:\Environment -UseTransaction
Complete-Transaction

ls HKCU:\Environment
rm HKCU:\Environment\test