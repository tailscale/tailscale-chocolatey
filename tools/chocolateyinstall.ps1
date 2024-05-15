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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.3-arm64.msi'
    Checksum     = 'f7439330033c282b4950c210f6852dca87913d5decf1cc0e0eb313d55b59e539'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.3-x86.msi'
    Checksum       = '80da625f60c07d42fd529ec4ef82ba3bf021f4b5721a55bf7be5224ae339556d'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.66.3-amd64.msi'
    Checksum64     = '0b8ba11b52ff94006c62482fab42f159e442c5650c74a0f8503045b91d7ad7fe'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
