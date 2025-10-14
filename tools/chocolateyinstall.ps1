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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.4-arm64.msi'
    Checksum     = '41fc03342bc32e405139de04357276020600e4d1d74c52da0efba5ceafaa8e87'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.4-x86.msi'
    Checksum       = 'f49ee146d78f2d1208026981db79100eb8b709f0ad4a335cd21dba3810cf38a0'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.4-amd64.msi'
    Checksum64     = 'aa01543e3bb1c8da8be83cbc6adff1b308b190e9d2c926144513b7089e6727b7'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
