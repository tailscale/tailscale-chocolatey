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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.0-arm64.msi'
    Checksum     = '43a0334da64e4797cf47947af08b696be04f49478b6c1b73f5117aaa43f600a4'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.0-x86.msi'
    Checksum       = '285cc55e2b31210351b4925cf91ba49de06aebf79bf6b881496586275c5ef2be'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.0-amd64.msi'
    Checksum64     = '1b44be2fd5329e31d03c30b30f044e4751eb33aa84f3a81b18a77c2649ddcafc'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
