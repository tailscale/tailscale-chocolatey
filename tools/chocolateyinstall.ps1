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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.42.0-arm64.msi'
    Checksum     = '211636186e09db8680a09bcf071d9e47a839c0a50207abd12ddc58aad907c733'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.42.0-x86.msi'
    Checksum       = 'dec82e79e914899633dd50e0041055d2d8c2ad257ae59d20b43d598fba8a0799'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.42.0-amd64.msi'
    Checksum64     = 'd782c948bb51992dc3855ef1d4640777411893e75447d5b24e2469dd59a94513'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
