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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.54.1-arm64.msi'
    Checksum     = '46e230549961842695d086a1975a13e3d16cf572cd09b70d8936973990c3aea9'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.54.1-x86.msi'
    Checksum       = 'b64f726e06c1d3bc8fb4cc3f1845b2851b42feddd137d3be1f17657827110910'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.54.1-amd64.msi'
    Checksum64     = '40a837e00664ddc9d6b4e686c9d7d8097e6d05452d2721c7e7bc0e138d11ba43'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
