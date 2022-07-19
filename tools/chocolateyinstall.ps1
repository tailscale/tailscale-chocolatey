$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$url = 'https://pkgs.tailscale.com/stable/tailscale-ipn-setup-1.28.0.exe'


$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url

  softwareName   = 'Tailscale'

  checksum       = '476c2d87a9450f9d1404e506e902bdad5694c2654c209f84d365545af3305241'
  checksumType   = 'sha256'

  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
