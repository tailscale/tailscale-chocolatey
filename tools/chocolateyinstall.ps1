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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.52.0-arm64.msi'
    Checksum     = '1122440211ca5e2722e7df891bd7816727d2e896740569d64175bd0b4e1006da'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.52.0-x86.msi'
    Checksum       = '1cae13792edd8051ea466ba964b4dc904dd049bdd445fdc67ecd91487337eeb6'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.52.0-amd64.msi'
    Checksum64     = 'f2faacc693e38a829cebde895b8a4c70a82b1324f4a1e7fb3ce0768ab1ca07bf'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
