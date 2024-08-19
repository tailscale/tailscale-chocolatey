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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.72.0-arm64.msi'
    Checksum     = 'd939e63be7eca3d90df84f1fdc629767fb0b7df1c7e78eb37ce434152ae3093a'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.72.0-x86.msi'
    Checksum       = 'e8cd569eb64296cd496e7265044f6c14e5180bfe341894551c1e23b3c1562e69'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.72.0-amd64.msi'
    Checksum64     = 'ed11a0dd7fa4a55ec23672131db0527e9100100a9a8dad1cc9cdfa34a4edfb44'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
