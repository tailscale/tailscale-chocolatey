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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.74.0-arm64.msi'
    Checksum     = '48868f1587f2162f081d68e718e6f1579e68183c912f04f862b02978a3c8fed9'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.74.0-x86.msi'
    Checksum       = 'f8e19bf5e7759a6e4bee69fd48eee64255215b597cd30349d91752777c1b2272'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.74.0-amd64.msi'
    Checksum64     = '3b83eb00fb03551f661ae5528cca0e6e091ac7f089e5e418d1a527af0fa07060'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
