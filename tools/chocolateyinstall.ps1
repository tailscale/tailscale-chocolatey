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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.68.1-arm64.msi'
    Checksum     = 'ac02d9b5a25b4982cfcc27ac5b99274cd3111359620d0859116c6b0464f89507'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.68.1-x86.msi'
    Checksum       = '6f5cdfe46139db02e162647d9032cf80088e7c478b5fff6ef73c2a61ee1aa78b'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.68.1-amd64.msi'
    Checksum64     = '76b29341f1809c0aa846810d56ad04535caa9a5351f3e71998f704d57366c954'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
