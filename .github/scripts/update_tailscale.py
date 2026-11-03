#!/usr/bin/env python3
"""Update Chocolatey metadata using Tailscale's *stable Windows* package feed.
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from urllib.request import Request, urlopen
from xml.etree import ElementTree

ROOT = Path(__file__).resolve().parents[2]
BASE_URL = "https://pkgs.tailscale.com/stable/"
METADATA_URL = BASE_URL + "?mode=json&os=windows"
ARCHITECTURES = ("arm64", "x86", "amd64")
VERSION_RE = re.compile(r"[0-9]+\.[0-9]+\.[0-9]+\Z")
NUSPEC_RE = re.compile(rb"(<version>)([0-9]+\.[0-9]+\.[0-9]+)(</version>)")

# Require each installer URL to be followed directly by its SHA256 checksum.
# Matching field names and architectures prevents accidental incorrect pairings.
INSTALLER_RE = re.compile(
    rb"(?P<url_prefix>^[ \t]*(?P<url_key>Url(?:64Bit)?)[ \t]*=[ \t]*')"
    rb"(?P<old_url>https://pkgs\.tailscale\.com/stable/tailscale-setup-"
    rb"[0-9]+\.[0-9]+\.[0-9]+-(?P<arch>arm64|x86|amd64)\.msi)"
    rb"(?P<separator>'[ \t]*\r?\n)"
    rb"(?P<checksum_prefix>[ \t]*(?P<checksum_key>Checksum(?:64)?)[ \t]*=[ \t]*')"
    rb"(?P<old_checksum>[0-9a-fA-F]{64})"
    rb"(?P<suffix>')",
    re.MULTILINE,
)


def fetch(url: str) -> bytes:
    if not url.startswith(BASE_URL):
        raise ValueError(f"Unexpected download source: {url}")
    request = Request(url, headers={"User-Agent": "tailscale-chocolatey-version-updater"})
    with urlopen(request, timeout=45) as response:
        payload = response.read(131073)
    if len(payload) > 131072:
        raise ValueError(f"Oversized metadata response: {url}")
    return payload


def parse_metadata(payload: bytes) -> tuple[str, dict[str, str]]:
    metadata = json.loads(payload)
    version = metadata.get("Version")
    if not isinstance(version, str) or not VERSION_RE.fullmatch(version):
        raise ValueError(f"Invalid stable Windows version: {version!r}")
    msis = metadata.get("MSIs")
    if not isinstance(msis, dict):
        raise ValueError("Stable Windows metadata does not contain an MSIs object")
    filenames = {}
    for arch in ARCHITECTURES:
        filename = msis.get(arch)
        expected = f"tailscale-setup-{version}-{arch}.msi"
        if filename != expected:
            raise ValueError(f"Unexpected MSI for {arch}: {filename!r}; expected {expected}")
        filenames[arch] = filename
    return version, filenames


def parse_checksum(payload: bytes, filename: str) -> str:
    value = payload.decode("ascii").strip()
    fields = value.split()
    if not fields or not re.fullmatch(r"[0-9a-fA-F]{64}", fields[0]):
        raise ValueError(f"Invalid SHA256 response for {filename}")
    if len(fields) > 2 or (len(fields) == 2 and fields[1].lstrip("*") != filename):
        raise ValueError(f"Unexpected checksum filename for {filename}")
    return fields[0].lower()


def nuspec_version(data: bytes) -> str:
    if b"<id>tailscale</id>" not in data:
        raise ValueError("Expected Chocolatey package id 'tailscale'")
    matches = list(NUSPEC_RE.finditer(data))
    if len(matches) != 1:
        raise ValueError(f"Expected one version in nuspec; found {len(matches)}")
    ElementTree.fromstring(data)  # Reject malformed XML before editing.
    return matches[0].group(2).decode("ascii")


def update_nuspec(data: bytes, version: str) -> bytes:
    nuspec_version(data)
    updated = NUSPEC_RE.sub(lambda m: m.group(1) + version.encode() + m.group(3), data, count=1)
    ElementTree.fromstring(updated)
    return updated


def update_installer(data: bytes, version: str, checksums: dict[str, str]) -> bytes:
    seen: set[str] = set()

    def replace(match: re.Match[bytes]) -> bytes:
        arch = match.group("arch").decode("ascii")
        url_key = match.group("url_key").decode("ascii")
        checksum_key = match.group("checksum_key").decode("ascii")
        expected_keys = ("Url64Bit", "Checksum64") if arch == "amd64" else ("Url", "Checksum")
        if (url_key, checksum_key) != expected_keys:
            raise ValueError(f"Field mismatch for {arch}: {url_key}/{checksum_key}")
        if arch in seen:
            raise ValueError(f"Duplicate installer architecture: {arch}")
        seen.add(arch)
        url = BASE_URL + f"tailscale-setup-{version}-{arch}.msi"
        return (
            match.group("url_prefix")
            + url.encode("ascii")
            + match.group("separator")
            + match.group("checksum_prefix")
            + checksums[arch].encode("ascii")
            + match.group("suffix")
        )

    updated, count = INSTALLER_RE.subn(replace, data)
    if count != 3 or seen != set(ARCHITECTURES):
        raise ValueError(f"Expected exactly arm64, x86, amd64 installer pairs; found {sorted(seen)}")
    return updated


def main() -> None:
    version, filenames = parse_metadata(fetch(METADATA_URL))
    nuspec_path = ROOT / "tailscale.nuspec"
    installer_path = ROOT / "tools" / "chocolateyinstall.ps1"
    old_nuspec = nuspec_path.read_bytes()
    old_version = nuspec_version(old_nuspec)
    if tuple(map(int, version.split("."))) < tuple(map(int, old_version.split("."))):
        raise ValueError(f"Refusing downgrade from {old_version} to {version}")
    if old_version == version:
        print(f"Already current: Tailscale Windows stable {version}")
        return

    checksums = {
        arch: parse_checksum(fetch(BASE_URL + filename + ".sha256"), filename)
        for arch, filename in filenames.items()
    }
    old_installer = installer_path.read_bytes()
    new_nuspec = update_nuspec(old_nuspec, version)
    new_installer = update_installer(old_installer, version, checksums)
    # Validate everything before writing either file.
    if new_nuspec == old_nuspec or new_installer == old_installer:
        raise ValueError("Expected both nuspec and installer to change")
    nuspec_path.write_bytes(new_nuspec)
    installer_path.write_bytes(new_installer)
    print(f"Updated Tailscale Chocolatey metadata: {old_version} -> {version}")
    print("Downloaded three SHA256 checksums from the official Tailscale stable feed.")


if __name__ == "__main__":
    main()
