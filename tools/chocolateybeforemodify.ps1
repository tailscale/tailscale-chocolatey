# This runs in 0.9.10+ before upgrade and uninstall.
# Use this file to do things like stop services prior to upgrade or uninstall.

# This script is currently best-effort; don't abort if it fails.
$ErrorActionPreference = 'Continue';

# Remove device driver certificate (which was installed by older versions of this package).
Get-ChildItem Cert:\LocalMachine\TrustedPublisher | Where-Object { $_.thumbprint -eq 'DEE8D4EF882C2C255D879EF109C1DB9CF743476E' } | Remove-Item
