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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.56.0-arm64.msi'
    Checksum     = '5ef5a50b170714ecbdb6ae3beafdff3cc8897dbe943a8510211373c7368c14c7'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.56.0-x86.msi'
    Checksum       = '3fcba1b5ea39a139de7865e71b0136b582de68e3007ad36c2f5be7924df1e95b'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.56.0-amd64.msi'
    Checksum64     = '53e09990a2b3d3e326f58b0220a4377034c4793a3d3d21c283d535ac86ec8a7b'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
