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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.0-arm64.msi'
    Checksum     = '52f72289d0301d4089e7b1195c81434e01868e074bbde0000db885227409c904'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.0-x86.msi'
    Checksum       = '03147613639be5f9332a170a19af1c0d6fc0aa7bc5493521f668ea6464fd6586'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.0-amd64.msi'
    Checksum64     = '8ddea12249c82939870f959eaf9e3962a022643ca7a4a50591b061ef9ac42098'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
