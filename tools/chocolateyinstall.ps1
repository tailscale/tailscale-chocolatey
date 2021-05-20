$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$url = 'https://pkgs.tailscale.com/stable/tailscale-ipn-setup-1.8.4.exe'


$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url

  softwareName   = 'Tailscale'

  checksum       = 'f50df526d2e71ee664aae708e710c7da3a59a043dda1c02df1f35825fb85a309'
  checksumType   = 'sha256'

  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
