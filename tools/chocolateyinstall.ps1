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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.3-arm64.msi'
    Checksum     = '3423db4c365a9b034b08c43e766ee81a01577f2a2634f612f242d9f06e055de4'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.3-x86.msi'
    Checksum       = '029b25037a03c7db1fdc68c8aa5a495283a0e34aec9d20563896e4e6e2421698'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.88.3-amd64.msi'
    Checksum64     = 'b7ba47d32e336e8b58a3ce528d8726e0067494c7216aa86c35ca3076364272c5'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
