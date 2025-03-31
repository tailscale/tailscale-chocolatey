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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.82.0-arm64.msi'
    Checksum     = '88bc19c311de33b19df9b98e2a30d6413f003dc6db1168df85ec094cdbdef3f1'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.82.0-x86.msi'
    Checksum       = '48b1a37bfdc93e6cd9101cdb0433cfba0f66579506127dc0a8ccbf5b3cc4120b'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.82.0-amd64.msi'
    Checksum64     = '32b8ad3ca2202d090bebe8e2d8108bcdd8c9371d4840ebf7c03288a9af133715'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
