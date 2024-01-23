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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.58.2-arm64.msi'
    Checksum     = '0c7be3d37b05aaf84b657673a63049c6564754e395853c16f29269f0fc417650'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.58.2-x86.msi'
    Checksum       = '1569686f2015f0b0bf13812de0e69ecb4b17d107a7a5024fae8266960dfd02f6'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.58.2-amd64.msi'
    Checksum64     = '54effc26f64873f5a67daaaa211e67a51b858767e5da5b7238220b8cb943c68a'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
