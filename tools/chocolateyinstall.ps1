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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.1-arm64.msi'
    Checksum     = '7df99466c3ded47b61e3e78490ee398d58d0add5e1eb55d534ebe10ec464da36'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.1-x86.msi'
    Checksum       = 'c14064a2dc561f7e9e554e61e6a5acad6f787c55252c89c6bb80ca6d2cc2ea70'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.1-amd64.msi'
    Checksum64     = '874426d7b89b242d8c64a2e82cb5e339838429ae4d003dd1bedf5bd2c91790d6'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
