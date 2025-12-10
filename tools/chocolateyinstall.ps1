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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.92.1-arm64.msi'
    Checksum     = '828ac8a688b251710c6bbcbbf620df5c9d26e13ae76a6291d5c4f27beeb1160b'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.92.1-x86.msi'
    Checksum       = 'd6c359f6a6fb1326561c175309bb95f6bad41d3c2928e2ad4390c72769cecfad'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.92.1-amd64.msi'
    Checksum64     = '90f51d4849a906b3759fb5a56e957fdca16e31b1200a5de808fd36f588093279'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
