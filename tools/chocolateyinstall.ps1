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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.78.1-arm64.msi'
    Checksum     = '235bc2634d7077231d215d349313653accba6d22cb00530f8a03ebe1e76238a7'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.78.1-x86.msi'
    Checksum       = '94e0975174cd83b45a6aceac735403a3823d1ca92f783bf5b1b43ea3693adbaa'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.78.1-amd64.msi'
    Checksum64     = '386ded1a56fdd3950250bbd8919dc39653a830c1a329faf8ea0669e9de66fd6d'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
