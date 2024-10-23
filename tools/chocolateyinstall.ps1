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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.76.3-arm64.msi'
    Checksum     = '0c72a73544981562e1ac3c23d6c807537eb538085d30942a4f5404919929954b'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.76.3-x86.msi'
    Checksum       = '272c28457b0aa323817ff773bbe57e24dc94f781978c0b7e600925920f478d1a'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.76.3-amd64.msi'
    Checksum64     = '2aa71dd3867c6f975ecfa039595556dbbf7236517f5d497d539e47b797cb7764'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
