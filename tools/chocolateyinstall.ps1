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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.1-arm64.msi'
    Checksum     = 'ef0318882b02219f1c73990dcb59d9edb726410a49e4479167a0cdce95416373'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.1-x86.msi'
    Checksum       = '17a1f2c4ae2a5173bd0c21c1463cacb0ec05cf26c761ee1c5f4f704611a5fa69'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.1-amd64.msi'
    Checksum64     = '816827b4857e3bab0f4df6f522b9a7e0291eb13882a11f556fbddef8d30b4281'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
