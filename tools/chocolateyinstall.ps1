$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$url = 'https://pkgs.tailscale.com/stable/tailscale-ipn-setup-1.8.0.exe'


$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url

  softwareName   = 'Tailscale'

  checksum       = '4a6666bb8369e99f8e8fb73ba7a9d1b8c758628452dee3e0bfb3f255be0e7533'
  checksumType   = 'sha256'

  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
