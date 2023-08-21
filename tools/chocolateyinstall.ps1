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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.1-arm64.msi'
    Checksum     = 'b67010fee1c92839023ca633886ddda23d5e66762571c270723a38ff911dbf07'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.1-x86.msi'
    Checksum       = 'c542e95eff1079afc2df31db14b2954a07acfe0c62abebebd5e8648c50e437c7'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.1-amd64.msi'
    Checksum64     = 'cf10ec1f07b54bd3b456e750e13f24313f8b27186f651d35546844e383104b54'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
