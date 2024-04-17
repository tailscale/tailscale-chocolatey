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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.64.2-arm64.msi'
    Checksum     = '5cfa0a982b834eb4c6a5f3892cda9920b06318638c349f64aab18bb9a0af47f9'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.64.2-x86.msi'
    Checksum       = 'f3d94d5b2f1a967371f6c957f9d2c78768c72baa0ec3d94441d9567e63f3587c'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.64.2-amd64.msi'
    Checksum64     = 'f44940a25327b0a90ee08d3b6f70d588aa80c66bf05e3f6d9ef8c82fe6832dd6'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
