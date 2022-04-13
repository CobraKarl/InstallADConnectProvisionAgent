#Install ProvisioningAgent in quiet mode
$pathToFile = Read-Host -Prompt "Paste Path To AAD File on HD without " " "
$installerProcess = Start-Process $pathToFile /quiet -NoNewWindow -PassThru 
$installerProcess.WaitForExit()

#Import the Provisioning Agent PS module
Import-Module "C:\Program Files\Microsoft Azure AD Connect Provisioning Agent\Microsoft.CloudSync.PowerShell.dll"

#Connect to Azure AD by using an account with the hybrid identity role
$enterPriceAdmin = Read-Host -Prompt "Enterprice Admin name"
$enterPriceAdminPw = Read-Host -Prompt "Password"
$hybridAdminPassword = ConvertTo-SecureString -String $enterPriceAdminPw -AsPlainText -Force 
$hybridAdminCreds = New-Object System.Management.Automation.PSCredential -ArgumentList ($enterPriceAdmin, $hybridAdminPassword) 
Connect-AADCloudSyncAzureAD -Credential $hybridAdminCreds

#Add the gMSA account, and provide credentials of the domain admin to create the default gMSA account
$domainAdminPw = Read-Host -Prompt "Domain admin Password"
$domainAdminCredentials = Read-Host -Prompt "Domain admin User"
$domainAdminPassword = ConvertTo-SecureString -String $domainAdminPw -AsPlainText -Force 
$domainAdminCreds = New-Object System.Management.Automation.PSCredential -ArgumentList ($domainAdminCredentials, $domainAdminPassword) 
Add-AADCloudSyncGMSA -Credential $domainAdminCreds

#Add the domain
$DomainAdminPassword = ConvertTo-SecureString -String $domainAdminPw -AsPlainText -Force 
$DomainAdminCreds = New-Object System.Management.Automation.PSCredential -ArgumentList ($domainAdminCredentials, $DomainAdminPassword) 
Add-AADCloudSyncADDomain -DomainName arthit.tech -Credential $DomainAdminCreds

#Restart the service
Restart-Service -Name AADConnectProvisioningAgent
