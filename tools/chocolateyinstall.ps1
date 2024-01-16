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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.56.1-arm64.msi'
    Checksum     = '8998ae34f7cee24883c3565549e11039c1562b6d2bc0762c95f3b1f26c8c580c'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.56.1-x86.msi'
    Checksum       = 'ec6dfdd32b999fe7de9dbab2a49c92f477d0f385d90d4301dad0ad1dd62271c4'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.56.1-amd64.msi'
    Checksum64     = '5728ce86291e5b69207209ff18755597a7c67ef02d2260b4fc1d53a6f77a1384'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
