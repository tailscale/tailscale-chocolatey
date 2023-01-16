function Get-RemoteSHA256 {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    (Get-FileHash -Algorithm SHA256 -InputStream ([System.Net.WebClient]::new().OpenRead($url))).Hash.ToLower()
}

$channel = "https://pkgs.tailscale.com/stable/"

$meta = Invoke-WebRequest ($channel + "?mode=json&os=windows") | ConvertFrom-Json

$version = $meta.Version

# Update the nuspec
$nuspec = New-Object xml
$nuspec.Load("$PSScriptRoot/tailscale.nuspec")
$nuspec.package.metadata.version = $version
$nuspec.Save("$PSScriptRoot/tailscale.nuspec")

# Update the installer script
$installer = Get-Content "./tools/chocolateyinstall.ps1"
$url = $channel + $meta.MSIs.arm64
$installer[19] = $installer[19] -replace "https:\/\/pkgs.tailscale.com\/.*\.msi", $url
$installer[20] = $installer[20] -replace "[0-9a-f]{64}", (Get-RemoteSHA256 $url)
$url = $channel + $meta.MSIs.x86
$installer[27] = $installer[27] -replace "https:\/\/pkgs.tailscale.com\/.*\.msi", $url
$installer[28] = $installer[28] -replace "[0-9a-f]{64}", (Get-RemoteSHA256 $url)
$url = $channel + $meta.MSIs.amd64
$installer[31] = $installer[31] -replace "https:\/\/pkgs.tailscale.com\/.*\.msi", $url
$installer[32] = $installer[32] -replace "[0-9a-f]{64}", (Get-RemoteSHA256 $url)
$installer | Out-File "./tools/chocolateyinstall.ps1"

# Check and see if files have been updated
$files_modified = $(git diff --name-only HEAD) -split '\n'
if ($files_modified.length -gt 0) {
    git commit -a -m "Update to version $version"

    Write-Host "Package files have been updated to version $version. Update has been committed and is ready to push. Displaying diff..."
    git diff HEAD~1 HEAD
}
else {
    Write-Host "No files have been updated. No commit has been made."
}