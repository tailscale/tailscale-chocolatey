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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.4-arm64.msi'
    Checksum     = '47f6d1ecf792d9078728a6d37ce137a809462d7cf70224a21288fc38c7801afb'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.4-x86.msi'
    Checksum       = '2ecf941970adad582d5bf2b16c359a0bfa519784a3e307b41cff42793f977a8f'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.4-amd64.msi'
    Checksum64     = '9dab4cc56a444ac350ad3dd92f6238eefa32f634c75aa8e2e7264b5ec8a96766'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
