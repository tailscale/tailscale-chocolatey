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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.86.2-arm64.msi'
    Checksum     = '4f2d9d7b07c9d56558dc0c5ee84be9440f08799713fe699c01b3b26bf0aa10b1'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.86.2-x86.msi'
    Checksum       = 'fbcda6ef77132b92c5795e8d0f93366f3b5204cf8228db2411931f1c3d123211'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.86.2-amd64.msi'
    Checksum64     = 'a6a8c0d376280e1e2864ab2453d6ce94262f1a6a0b64dd716018c4787d58cf19'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
