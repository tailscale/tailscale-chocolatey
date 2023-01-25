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
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.0-arm64.msi'
    Checksum     = '788eb8f8a8004eacfa41379961c3001b562d4db7b51a14e2235f980ec4051f11'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.0-x86.msi'
    Checksum       = '390613a481750908629778cace447b5caabce0ff03fa22db3a262e8b2222675c'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.36.0-amd64.msi'
    Checksum64     = '54540fdfc69178ee31e2fdbba379536ec2c4eee9990af65d5ab94b4e079c0a2e'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
