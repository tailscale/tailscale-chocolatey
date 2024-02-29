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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.60.1-arm64.msi'
    Checksum     = 'a799fa6c423059857e70c10d3cec3fa3251ebf2e1bf270ffb0f7f34afee9cb40'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.60.1-x86.msi'
    Checksum       = 'f8cd131cb98cff0cba7731bbf2ffcae733e7e87c02965d91ecbdbf503c0ba6f4'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.60.1-amd64.msi'
    Checksum64     = 'd885bf3683ad387e60b764bec8c23117896efaffccadcf3cd9ed51a8bd1645f6'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
