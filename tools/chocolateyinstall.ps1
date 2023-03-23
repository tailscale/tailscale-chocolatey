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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.2-arm64.msi'
    Checksum     = '9d397029a36167b3cf98680298a6ae716dcfe91ffc57cf96bd71d9d31bf572c1'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.2-x86.msi'
    Checksum       = '550a902f1a4fd880d9ce7d6800bfc62004804b43ad8ba552aa17e7322c630f9f'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.2-amd64.msi'
    Checksum64     = 'f5e1fbfe71ea1ad30dd210a4ea2952e9bf8d6fd00a41e5fcbe2f73568784ba94'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
