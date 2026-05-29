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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.4-arm64.msi'
    Checksum     = '1005335109e43a430fa8ebc0e598270cb77da5fe356b52b1ea476dc8e5db7d94'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.4-x86.msi'
    Checksum       = '42ab5af3a91a7d8f23c0dcf3f022a890e9489cc2412c747686cd460838f50e13'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.98.4-amd64.msi'
    Checksum64     = '95fa8601a7195411f5d0685bb650f239b2831d9939456c8d3ae8e286c85b1746'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
