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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.54.0-arm64.msi'
    Checksum     = 'e4bc373591f08dda14c7d33719414a0585869ce636b6db5e7d9daae5b9c3e0ba'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.54.0-x86.msi'
    Checksum       = '3b5b9b1bc831a02c26336cfe9286b4e7c4bc05fdb35426a6122760874c377e63'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.54.0-amd64.msi'
    Checksum64     = 'd932e2db675d71cd483e5a29706af33ee93886b91092a612c7cec32a39e8bf16'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
