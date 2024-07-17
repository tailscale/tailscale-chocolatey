$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  SoftwareName   = 'Tailscale'
  PackageName    = $env:ChocolateyPackageName
  UnzipLocation  = $toolsDir
  FileType       = 'msi'

  SilentArgs     = '/quiet'
  ValidExitCodes = @(0)
}

if ($env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')) {
  # Windows on ARM
  $packageArgs += @{
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.70.0-arm64.msi'
    Checksum     = 'f36a4e19cb7c2ab74fc5ca0f98f24b6841a4c185e7d1aeb4a2ec62abc7692cd5'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.70.0-x86.msi'
    Checksum       = '1685793a95b19d57f79b87d007837d308b66fd2d5e89dd049f9f76f94378245d'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.70.0-amd64.msi'
    Checksum64     = '040b0c462976c2897fa75ae2a5966fb4be1f0a5493d8868f14184dca7825a044'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
