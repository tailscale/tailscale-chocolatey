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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.62.0-arm64.msi'
    Checksum     = '94afa16940f335ef52bb640725765ce6bf3c5afb7ece13aa0c0eff0d68454638'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.62.0-x86.msi'
    Checksum       = '053df7b1c302a111a387c5c3e7fca403673b80a090a17b667b338720fff94abc'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.62.0-amd64.msi'
    Checksum64     = 'e677b660697f2d5a34b09582636c4c2e2a8f2ba16a2dfd4582868177244bb732'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
