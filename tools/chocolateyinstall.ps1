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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.64.0-arm64.msi'
    Checksum     = '2113a42904168ea49d49a5fec34fb0e84d043e3e7ed227fc4a842f62874fd544'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.64.0-x86.msi'
    Checksum       = 'f6bdac3aa1f65341f988a667ec3cb5122df4f190fd72582020109a073b7b8d62'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.64.0-amd64.msi'
    Checksum64     = '46e61cd7037887f7049373545f07ba31dafaaf213299ae35fc8a5073332cfcc8'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
