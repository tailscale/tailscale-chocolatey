$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$packageArgs = @{
  SoftwareName   = 'Tailscale'
  PackageName    = $env:ChocolateyPackageName
  UnzipLocation  = $toolsDir
  FileType       = 'msi'

  silentArgs     = '/quiet'
  validExitCodes = @(0)
}

if ($env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')) {
  # Windows on ARM
  $packageArgs += @{
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.2-arm64.msi'
    Checksum     = 'f1ad8bc33cb942c6a39a9e0771e256892b5f8511aaba934fe8d9b6429ce96ed3'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.2-x86.msi'
    Checksum       = '31b6b57acc40de1c72d5cde32e93b30a9d99c6baeea16c16c71fd73db6ca9e1d'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.2-amd64.msi'
    Checksum64     = '2ee3f08cbaa108574d44f820484fb9d8fb21eeae80e0cef2e1fbbe4e55db92bd'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
