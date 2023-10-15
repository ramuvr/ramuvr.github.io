@echo off
powershell.exe -ExecutionPolicy Bypass -File ".\azcopysync.ps1" -LocalPath "C:\Data" -ContainerURL "https://mystorage.blob.core.windows.net/mycontainer" -SecretVault "MyVault" -SecretName "MySecret" -TenantId "MyTenantId"
