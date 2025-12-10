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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.90.9-arm64.msi'
    Checksum     = 'B51E5F6766A351B1E10DB3C0E08415BD5CA3971CFD0EA72A108F10B24F700228'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.90.9-x86.msi'
    Checksum       = '9C0A26589D0C5A28ECB17816702ED7489B0D08D6BFD9677E1BC92CCCDBE98E28'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.90.9-amd64.msi'
    Checksum64     = 'D58E541773A9BE7A26B70FD01FC311D307E1531B735E8225ACCE3EECA7EA5AA4'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
