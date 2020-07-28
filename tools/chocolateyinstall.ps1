$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$url        = 'https://pkgs.tailscale.com/stable/tailscale-ipn-setup-0.100.0-107.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url

  softwareName  = 'Tailscale IPN'

  checksum      = 'cae3f6c4d01d7a0b06de6b688b1417c12a54b4cdef10fd04347e631865371f1b'
  checksumType  = 'sha256'

  silentArgs   = '/S'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs










    








