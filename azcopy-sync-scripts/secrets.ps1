# Secret Management
# https://learn.microsoft.com/en-us/powershell/utility-modules/secretmanagement/overview?view=ps-modules
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.secretmanagement/?view=ps-modules 
# Requirement: Powershell 7 (SecretStore uses .NET Core cryptographic APIs to encrypt file contents)

#Install SecretManagement & SecretStore
Install-Module -Name Microsoft.PowerShell.SecretManagement -Repository PSGallery
Install-Module -Name Microsoft.PowerShell.SecretStore -Repository PSGallery

# Get Help 
# Get-Command -Module Microsoft.PowerShell.SecretManagement
# Get-Command -Module Microsoft.PowerShell.SecretStore

# Load the PowerShell modules for SecretManagement and SecretStore
Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Microsoft.PowerShell.SecretStore

# Prompt the user to enter a username and password for the secure store
$credential = Get-Credential -UserName 'SecureStore'

# Set the path to the file where the secure password will be stored
$securePasswordPath = '{Path}\passwd.xml'

# Export the password to a secure XML file
$credential.Password | Export-Clixml -Path $securePasswordPath

# Register a master password for storing secrets securely
$parameters = @{
    Name = 'BlobVault'                                       # The name of the vault to be registered
    ModuleName = 'Microsoft.PowerShell.SecretStore'     # The name of the module that provides the vault implementation
    DefaultVault = $true                                # Indicates whether this vault should be the default vault for the current user
    AllowClobber = $true                                # Indicates whether to overwrite an existing vault with the same name
    Description = 'This vault is registered to store BlobVault credentials'  # A description of the vault
    Confirm = $false                                    # Indicates whether to prompt the user for confirmation before executing the command
}
Register-SecretVault @parameters

$password = Import-CliXml -Path $securePasswordPath
Unlock-SecretStore -Password $password

# Create secrets to store SPN details for AzCopy

# Define the SPN client ID and secret
$SPNClientId = "{EntraID Service Principal Application ID}"
$SPNSecret = "{EntraID Service Principal Secret}"

# Create a JSON object containing both SPN details
$SPNDetails = @{
    "ServicePrincipalId" = $SPNClientId
    "ServicePrincipalSecret" = $SPNSecret
}

# Get Vault name
$Vault = Get-SecretVault -Name BlobVault

# Set the secret in the vault
Set-Secret -Vault $Vault.Name -Name "StorageSPN" -Secret $SPNDetails


