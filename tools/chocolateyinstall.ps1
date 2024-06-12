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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.68.0-arm64.msi'
    Checksum     = '9e6e3184cde49ea3b8a7b1d397f13336bf4cd950d4d2a3696d393bf6c66a935e'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.68.0-x86.msi'
    Checksum       = '75f7068e090dce8c582df56cd0636d631f2d9d62d0fa811139c5f62985a6d0a8'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.68.0-amd64.msi'
    Checksum64     = 'bc785089af91127da0b3eea76ddef7c208d51876f7c3d27c5ce51895680cc855'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
