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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.3-arm64.msi'
    Checksum     = '169de98dd1b29e67464ceeb4a93a998e4cad167d24312afa74170530dc98a50e'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.3-x86.msi'
    Checksum       = 'd2824b4b4deac7e64071d2557db4231f9c88aaa0ff6841e201923c0da87dd6ed'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.38.3-amd64.msi'
    Checksum64     = '88a23187f98fcda4194922b7bc79f026c976b9109ee740e5f1e58d8ccc7e13ec'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
