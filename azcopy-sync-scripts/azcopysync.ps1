<#
.SYNOPSIS
    This script synchronizes local files with Azure Blob Storage.

.DESCRIPTION
    This PowerShell script automates the process of synchronizing files from a local folder to an Azure Blob Storage container.

.PARAMETER LocalPath
    Specifies the local folder to be synchronized.

.PARAMETER ContainerURL
    Specifies the Azure Storage container URL.

.PARAMETER SecretVault
    Specifies the name of the secret Vault containing the secrets.

.PARAMETER SecretName
    Specifies the name of the secret containing SPN details.

.PARAMETER TenantId
    Tenantid of the Entra ID tenant where Azure Storage, SPN are created.

.NOTES
    Author: Ramu Venkitaramanan
    Version: 1.0
    Date: October 15, 2023

.EXAMPLE
    .\azcopysync.ps1 -LocalPath "C:\Data" -ContainerURL "https://mystorage.blob.core.windows.net/mycontainer" -SecretVault "MyVault" -SecretName "MySecret" -TenantId "MyTenantId"
    Synchronize the local folder with the specified Azure Blob Storage container.

#>

# Define parameters for the script
param (
    [Parameter(Mandatory = $true)]
    [string] $LocalPath,        # Local folder to be synchronized
    [Parameter(Mandatory = $true)]
    [string] $ContainerURL,     # Azure Storage container URL
    [Parameter(Mandatory = $true)]
    [string] $SecretVault ,       # Name of the SecretVault containing the secret.
    [Parameter(Mandatory = $true)]
    [string] $SecretName,       # Name of the secret containing Service Principal details
    [Parameter(Mandatory = $true)]
    [string] $TenantId          # Tenantid of the Entra ID tenant where Azure Storage, SPN are created.
)
# Retrieve the SPN details from the secret vault
$securePasswordPath = '{Path}\passwd.xml'
$password = Import-CliXml -Path $securePasswordPath
Unlock-SecretStore -Password $password

# Get Vault name
$Vault = Get-SecretVault -Name $SecretVault

# Get the secret stored in the local vault
$Secret = Get-Secret -Vault $Vault.Name -Name $SecretName -AsPlainText

# Check if the secret was found
if ($null -eq $Secret) {
    Write-Host "Error: Secret '$SecretName' not found in vault '$($Vault.Name)'."
    exit 1
}

# Validate that the secret contains the necessary properties
if (-not $Secret.ContainsKey("ServicePrincipalId") -or -not $Secret.ContainsKey("ServicePrincipalSecret")) {
    Write-Host "Error: The secret does not contain all the required properties (ServicePrincipalId, ServicePrincipalSecret)."
    exit 1
}

# Set the variables for the SPN details
$ServicePrincipalId = $Secret["ServicePrincipalId"]
$ServicePrincipalSecret = $Secret["ServicePrincipalSecret"]

# Log in to Azcopy using Auto-login with the Service Principal credentials
$env:AZCOPY_AUTO_LOGIN_TYPE= "SPN"
$env:AZCOPY_SPA_APPLICATION_ID= $ServicePrincipalId
$env:AZCOPY_SPA_CLIENT_SECRET= $ServicePrincipalSecret
$env:AZCOPY_TENANT_ID= $TenantId

# Set the arguments for the AzCopy command
$AzCopyArgs = @(
    "sync",                 # Synchronize files command
    $LocalPath,             # Local folder to be synchronized
    $ContainerURL,          # Azure Storage container URL
    "--compare-hash=MD5",   # Compare files using MD5 hash
    "--put-md5",            # Set the MD5 hash of the file as the Content-MD5 property of the blob
    "--recursive"           # Synchronize subdirectories recursively
)

# Build the AzCopy command
$azCopyCommand = "azcopy " + ($AzCopyArgs -join " ")

# Execute the AzCopy command
Invoke-Expression $azCopyCommand

# Remove the SPN details from the environment variables
Remove-Item env:AZCOPY_AUTO_LOGIN_TYPE
Remove-Item env:AZCOPY_SPA_APPLICATION_ID
Remove-Item env:AZCOPY_SPA_CLIENT_SECRET
Remove-Item env:AZCOPY_TENANT_ID