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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.76.6-arm64.msi'
    Checksum     = '5788026dfa0541ddb64b660ccb011c70053a39eb8d60b346c6de3338c708c85d'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.76.6-x86.msi'
    Checksum       = '649d4fefd752fda36dafab2a92dbce3ed410de6a0704ad3033dfe00536c90336'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.76.6-amd64.msi'
    Checksum64     = '7e070bf2aaafd2dbae1642d128600dc05d14467428dd40bbb0ab8b6578d78d59'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
