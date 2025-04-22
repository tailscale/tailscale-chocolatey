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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.82.5-arm64.msi'
    Checksum     = '7409d1c9630ea953d3fb9802b666fb5055439ad81d76c9ae970573f5c75f7eb5'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.82.5-x86.msi'
    Checksum       = '0878e42e54d504f6f62a2fa654bfc99d4bdedbbb337ffe6df34ef57b5609ee9c'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.82.5-amd64.msi'
    Checksum64     = 'bc7b0698fc84ca98eb57f5c58fd94a76f6f66e9df39d2ddddb2d255c2b1e1da1'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
