$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$url = 'https://pkgs.tailscale.com/stable/tailscale-ipn-setup-1.4.5.exe'

$packageArgs = @{
  packageName      = $env:ChocolateyPackageName
  unzipLocation    = $toolsDir
  fileType         = 'exe'
  url              = $url

  softwareName     = 'Tailscale'

  checksum         = 'bd3f96c36d767bede49ecb9eb7bfc78b42f2304058e3faf92e60f0d647197fb4'
  checksumType     = 'sha256'

  silentArgs       = '/S'
  umvalidExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
