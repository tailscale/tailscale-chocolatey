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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.90.4-arm64.msi'
    Checksum     = 'b649a349ebd7e27a1d0a9fb836c3f662d3d985d3586684a820949cb5a87db479'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.90.4-x86.msi'
    Checksum       = '4ed8eeecc5514ed1fcd8744db68739c4c30685466e53e8ae1b2c27e4d95c70c1'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.90.4-amd64.msi'
    Checksum64     = '0dc65cc01efa31580d5b26f7ec07dbdfe9ff60d4d6a1881c7f4453a54a8b766b'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
