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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.40.1-arm64.msi'
    Checksum     = 'bea04884185fe6c1bd123e96d8c18520eb7e15a5a69f441fa06a3acdaae2307d'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.40.1-x86.msi'
    Checksum       = 'defbd3a6c1b2c32e038c9d063ba12f93145c8838511d4e71090ed377847adb2b'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.40.1-amd64.msi'
    Checksum64     = '9e0d7c96b68be11e1c237c7dbc07435c3a8a89033a5f11ee6d54cbb4493c8a41'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
