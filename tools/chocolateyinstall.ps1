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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.8-arm64.msi'
    Checksum     = '1692cbaf4b0668b1a4fbbeeb50639dbc7c67b3d56652829eca8b127a1899ce4e'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.8-x86.msi'
    Checksum       = '36b47e4df15ec04969297300da81cca87254ecc5e79fae8360b2cfc90868640e'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.8-amd64.msi'
    Checksum64     = '37416900f4990abb0e85b9cc26c7c7f96f8f181294cbee1eeb568ec3f355e87d'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
