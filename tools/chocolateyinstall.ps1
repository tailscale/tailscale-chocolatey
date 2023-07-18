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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.44.2-arm64.msi'
    Checksum     = 'a588edd5dbf50142510cc09bd251d3136a6ffbc6fd6caadaaa8307b499e4f63e'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.44.2-x86.msi'
    Checksum       = '371f1457d128778346677759fc0a75f35b56df13de8b8c999a708ad1d4f73810'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.44.2-amd64.msi'
    Checksum64     = 'cbc28207340c8de0f435fd6dfa1d6991c8e5d71efe5b3ac7431ed7d681aee7a7'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
