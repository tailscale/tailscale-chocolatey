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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.80.2-arm64.msi'
    Checksum     = '991dd6a5301dae186f4d74964909de0d7f802820eeaaf30eb5f8bf190e968003'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.80.2-x86.msi'
    Checksum       = 'f148ae1043e1c1bb6346e06f582724147b2e2d442fd27441c7356ac8328094c6'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.80.2-amd64.msi'
    Checksum64     = '72b0d39adb0c88ccf435875a0a5db6d809230a5f85d1447792d0fe091981beef'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
