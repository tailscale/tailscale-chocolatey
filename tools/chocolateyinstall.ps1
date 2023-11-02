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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.52.1-arm64.msi'
    Checksum     = 'd6dac2486b2324441b79f7d3104d7bfe1cfb4178cc71442a04797462565ddfdc'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.52.1-x86.msi'
    Checksum       = '65c985d5da0aab8074b7ac632fb54b6ea420d678cc575c9971b86b2d5d00397e'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.52.1-amd64.msi'
    Checksum64     = '78f3da14f77185608374b3b70ca3e43d39d4c58f073ba8e22e4347c2f6a746ae'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
