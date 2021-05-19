$channel = "https://pkgs.tailscale.com/stable/"

$url = $channel + ((Invoke-WebRequest $channel).links | where-object { $_.href -like "*.exe" }).href

$url -match "\d*\.\d*\.\d*"
$version = $Matches[0]

$hash = (Get-FileHash -Algorithm SHA256 -InputStream ([System.Net.WebClient]::new().OpenRead($url))).Hash.ToLower()

# Update the nuspec
$nuspec = New-Object xml
$nuspec.Load("./tailscale.nuspec")
$nuspec.package.metadata.version = $version
$nuspec.Save("./tailscale.nuspec")

# Update the installer script
$installer = Get-Content "./tools/chocolateyinstall.ps1"
$installer = $installer -replace "https:\/\/pkgs.tailscale.com\/.*\.exe", $url
$installer = $installer -replace "[0-9a-f]{64}", $hash
$installer | Out-File "./tools/chocolateyinstall.ps1"