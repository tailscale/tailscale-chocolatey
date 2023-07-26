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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.46.1-arm64.msi'
    Checksum     = '9c95de1e4fd13d7ffe89f606685020698a6059d2924efd0097f10b80d4d46181'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.46.1-x86.msi'
    Checksum       = '95e045af1c106837c7c34601677a05422322e3a4bd0e971c1937081b9d1824bf'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.46.1-amd64.msi'
    Checksum64     = '6fd93bdf3007cfcf4a23aac726bfae437d7ed5fd4db4d99d7e678ce4bde575ef'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
