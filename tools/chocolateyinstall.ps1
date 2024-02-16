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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.60.0-arm64.msi'
    Checksum     = 'f9007efe9715360f79571aaf4b0e3899016c852f51184888e27310c09bc3ce98'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.60.0-x86.msi'
    Checksum       = 'de226f647132b6143f22470a9ba671fae0c0a2cde8dc32151673f0e19f5b8dcd'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.60.0-amd64.msi'
    Checksum64     = '2e0fb12311de10c8d06207e075e1a074e16eecb632c193b77c4b22e1f5c2eb53'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
