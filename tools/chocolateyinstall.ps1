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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.58.0-arm64.msi'
    Checksum     = '297d42e83dd976ea39a75e331b8e4738c4778c647fa6e733e402123a02dc5e44'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.58.0-x86.msi'
    Checksum       = 'c246cf7669177dd2fdad4c9c6985bb92b27924518ff1b783ecfad62e9efe5a03'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.58.0-amd64.msi'
    Checksum64     = '6864741b6da73f9e8b739a43874a7822b9c23158ebffab30eabe4bf1652692cf'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
