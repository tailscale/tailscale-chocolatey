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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.50.0-arm64.msi'
    Checksum     = '52ff2a37123fdccc8d5a9b4a11f183b724e404c295160451382c7f38834037d7'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.50.0-x86.msi'
    Checksum       = '605e12d89c4bec2c41d9fd44e1d4840ef4afd14d5efa729d85c661836bf36c45'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.50.0-amd64.msi'
    Checksum64     = 'ce25b55b12407eace15ea80e9dae39f15512ebd6b876ceb6746689afcbca0372'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
