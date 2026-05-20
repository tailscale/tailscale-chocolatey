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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.2-arm64.msi'
    Checksum     = 'caa77b70367cfe8f99513c72f43a4c768d83255ba1b1408d95b462635eb132e0'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.2-x86.msi'
    Checksum       = 'ae94db837124c8f83351a04d31e6ed3de7d5d64f3c5e3641904acf05da6d9600'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.2-amd64.msi'
    Checksum64     = '89eb44e18f1af3e6e4aa998ec161d3996158fe3e0c0b9f1bf745c74eb420f84e'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
