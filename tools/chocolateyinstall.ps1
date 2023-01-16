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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.34.2-arm64.msi'
    Checksum     = '41bd41724075059fbac5b460081dd8535265444cc2db1c32b68aa16e5f0514cd'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.34.2-x86.msi'
    Checksum       = '9e9868fed2823f8e16f0f2f858a863d4a4b8ba31e9dfe95d9ca5d556c52858cc'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.34.2-amd64.msi'
    Checksum64     = 'cf065a8700bb9b4543a8aca1cb377378cd7c7115f68a65ea7a9d44d4346081ff'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
