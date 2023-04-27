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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.40.0-arm64.msi'
    Checksum     = 'f5de3388fae970ab1aa3f4e02ccce60a44e4546f926584b03264b9f432682f0c'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.40.0-x86.msi'
    Checksum       = '67501c884b93715506d35362d2cf1b645f8bd65c6f411aee3c9818819efe4002'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.40.0-amd64.msi'
    Checksum64     = '1a87465347e1d32cd6dda6e660653ec03f944cac69f50e35670183e87e394d80'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
