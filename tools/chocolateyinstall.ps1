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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.1-arm64.msi'
    Checksum     = '39d35ded950284d87f5fd498b7f88494ae6139506abe62aae6f6469beaa9007f'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.1-x86.msi'
    Checksum       = '6507866c6aa8a7c1c981267836884ae390b01fba5f36d2a70c6c709845b1b9e1'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.1-amd64.msi'
    Checksum64     = 'cbb6452ad455a5dd7ac679a8ce83609faea836313968db60b1719e042251ebbc'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
