$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$url = 'https://pkgs.tailscale.com/stable/tailscale-ipn-setup-1.16.1.exe'


$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url

  softwareName   = 'Tailscale'

  checksum       = '8c31c36d136975ce414ea6d743c98674b97a1f37932c6008068e9eee4b473ddb'
  checksumType   = 'sha256'

  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
