$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  SoftwareName   = 'Tailscale'
  PackageName    = $env:ChocolateyPackageName
  UnzipLocation  = $toolsDir
  FileType       = 'msi'

  SilentArgs     = '/quiet'
  ValidExitCodes = @(0)
}

if ($env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')) {
  # Windows on ARM
  $packageArgs += @{
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.62.1-arm64.msi'
    Checksum     = 'c07ffeed23a891f459cb3fa475e5106e06e5e3a4a8dc963f47f52c45e9b4ca5d'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.62.1-x86.msi'
    Checksum       = '5cf9066b692f131927780ec16edbf0cfc4a02949782d349c3c1ee728c224dec7'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.62.1-amd64.msi'
    Checksum64     = 'f02c0c69c64c3df24ff59f7978523cc1b3c3c73d37019118a0aa197513e1c27e'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
