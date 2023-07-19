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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.46.0-arm64.msi'
    Checksum     = '988456634795209304d554a9aa742cf6f0aabd37b3a52c786c56e4debd534865'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.46.0-x86.msi'
    Checksum       = 'f0e7061750d255a2a08fc510f8add2bf7e8a7bffaeb74823e8cbe691d84cd0d9'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.46.0-amd64.msi'
    Checksum64     = 'a60aab1dba7df7f9b574eadbe958549acf9c59dced4ff5f6cdd8270c4569be1e'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
