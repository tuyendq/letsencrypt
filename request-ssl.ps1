# Request SSL SAN Certificate from Let's Encrypt
# Install Posh-ACME
# https://github.com/rmbolger/Posh-ACME
# Minimum PowerShell version: 5.1

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# install for all users (requires elevated privs)
Install-Module -Name Posh-ACME

# install for current user
# Install-Module -Name Posh-ACME -Scope CurrentUser

# Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Force -Scope CurrentUser

# Open firewall port tcp:80 - Use for http-challange method
# netsh advfirewall firewall add rule name = HTTP dir = in protocol = tcp action = allow localport = 80 profile = PUBLIC

$pfxpass = "poshacme2020"
$contact_email = "contact_email"  # Change this
$domainname = "domain.com"  # Change this
$cn = "adfs.${domainname}"
$san1 = "sts.${domainname}"
$san2 = "enterpriseregistration.${domainname}"
$san3 = "certauth.adfs.${domainname}"

# New-PACertificate "*.${domainname}",$domainname -AcceptTOS -Contact $contact_email

# Request SSL Cert using Godaddy's API Key&Secret
# $gdSecret = Read-Host Secret -AsSecureString
$gdkey = "your-godaddy-api-key"  # Change this
$gdsecret = "your-godaddy-api-secret"  # Change this
$pArgs = @{GDKey=$gdkey;GDSecret=$gdsecret}

New-PACertificate $cn,$san1,$san2,$san3 -DnsPlugin GoDaddy -PluginArgs $pArgs -AcceptTOS -Contact $contact_email -PfxPass $pfxpass -Install

# Get SSl Cert
Get-PACertificate | Format-List
