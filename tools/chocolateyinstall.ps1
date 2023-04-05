$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$packageArgs = @{
  SoftwareName   = 'Tailscale'
  PackageName    = $env:ChocolateyPackageName
  UnzipLocation  = $toolsDir
  FileType       = 'msi'

  silentArgs     = '/quiet'
  validExitCodes = @(0)
}

if ($env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')) {
  # Windows on ARM
  $packageArgs += @{
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.4-arm64.msi'
    Checksum     = '37e60882da493a94828119281cac13d97c73d09322e2a1d796702cafd6167f0a'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.4-x86.msi'
    Checksum       = 'fd32450cc264374e11baf533e963eb413498cf4acc97ab392b83c4dc028af9b8'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.4-amd64.msi'
    Checksum64     = 'e5b4acb075f4e6c58fdb37696d5edff30d21a61aaf8b74c84b1212cb246788d2'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
