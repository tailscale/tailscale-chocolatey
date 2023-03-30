#!/usr/bin/env bash
set -euo pipefail

base_url="https://pkgs.tailscale.com/stable"

json_string=$(curl -s "$base_url/?mode=json&os=windows")
version=$(echo $json_string | jq -r .Version)

# replace <version>...</version> in nuspec file
sed -i "s/<version>[^<]*<\/version>/<version>$version<\/version>/g" tailscale.nuspec

# for each arch in the json
arches=($(echo $json_string | jq -r .MSIs | jq -r 'keys[]'))
for arch in "${arches[@]}"; do
    # url to download file
    url="$base_url/$(echo $json_string | jq -r .MSIs.$arch)"
    # get sha256 of file
    sha256=$(curl -s "$url.sha256")
    # replace url and sha256 in chocolateyinstall.ps1
    sed -i "s|https://pkgs.tailscale.com/stable/.*$arch.msi|$url|" ./tools/chocolateyinstall.ps1
    nextlineno=$((1+$(grep -n "$url" ./tools/chocolateyinstall.ps1 | cut -d: -f1)))
    sed -Ei "${nextlineno}s|[0-9a-fA-F]{64}|$sha256|" ./tools/chocolateyinstall.ps1
done

readarray -t files_modified < <(git diff --name-only HEAD)
if [[ ${#files_modified[@]} -gt 0 ]]; then
    git commit -a -m "Update to version $version"

    echo "Package files have been updated to version $version. Update has been committed and is ready to push. Displaying diff..."
    git diff HEAD~1 HEAD
else
    echo "No files have been updated. No commit has been made."
fi
