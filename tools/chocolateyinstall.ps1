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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.86.0-arm64.msi'
    Checksum     = '6bdf400870f1a6a0296572b1a5e4dd4e10a368ccc67cd192ac86d0658af76831'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.86.0-x86.msi'
    Checksum       = '8c50b2c02364939b431f66ec44456cd7127b9ad27fe49c1fe43160a7c26a8bd5'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.86.0-amd64.msi'
    Checksum64     = 'b1538379200f362eab3e432e6d4d50642cade8a1dca2c6e8d2642e70972aac83'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
