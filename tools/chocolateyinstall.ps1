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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.2-arm64.msi'
    Checksum     = 'afb4afbc896c3ccbf56fcd37c0b7e098eb1aaf5782138621d92b2d67ddd14400'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.2-x86.msi'
    Checksum       = 'dc992437a736802cf175970589817ff52c52d94d02f22696d026087194b2cc0b'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.48.2-amd64.msi'
    Checksum64     = '411c511f208bcaa7325b0ca23378a165c62a85786216f4fb0b89fe67e337348c'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
