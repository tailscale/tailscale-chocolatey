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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.44.0-arm64.msi'
    Checksum     = '06bfc7caceceafaaf31b69e1885eb58b00b5deeaeb26b68e2e6e5c109c2625ad'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.44.0-x86.msi'
    Checksum       = '5a4e6838acbc18baf095f49a640b92b9a6b7923041cd3ff3ce8557029f99b4ba'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.44.0-amd64.msi'
    Checksum64     = 'd9d4daeeb0e92a3bcdfed71f2d1c8b54510fd564d1c5fbc54b2ccc2f977751d3'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
