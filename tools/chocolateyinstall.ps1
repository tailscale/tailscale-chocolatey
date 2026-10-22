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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.104.5-arm64.msi'
    Checksum     = '609982de4dfe70b67a02e2a93c9c5c1dfa20addceb33a7d3b144f1d34d98f5fc'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.104.5-x86.msi'
    Checksum       = '078edb90cdab6a4fc67f79721cb2d2b48828b108cf5d656a3d9fd94b859a54d2'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.104.5-amd64.msi'
    Checksum64     = '3c41318c83c5d95d0b017b1baa08ba7c99fd5334166122bbb1931e55af99839c'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
