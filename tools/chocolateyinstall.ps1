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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.92.5-arm64.msi'
    Checksum     = 'a6ce57fb42aee96385468b487df5d8d49020ee4e8f7937f267f541a5a0e4af28'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.92.5-x86.msi'
    Checksum       = 'dd91420d7874173bc053b87ceaaa188d121d6fc169a67c2dcdbeb1eb1a0e3581'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.92.5-amd64.msi'
    Checksum64     = '7180fa0b6bdfc129445ded5762cfd71226fbf471ecae3c5e332ea2dc3cbb9d78'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
