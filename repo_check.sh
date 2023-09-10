#!/bin/bash
set -e

# Compares local versions to the upstream package database

rm -rf repo
mkdir -p repo && cd repo
wget https://pkg.devkitpro.org/packages/linux/x86_64/dkp-linux.db.tar.gz
tar xf dkp-linux.db.tar.gz 2> /dev/null

getprop() {
    sed -n -e "/^%$2%$/{n;p}" "$1"
}

echo "Checking packages..."
for x in */desc; do
    repo_pkgname="$(getprop "$x" NAME)"
    repo_pkgver="$(getprop "$x" VERSION)"
    repo_pkgver="${repo_pkgver%%-*}"

    # Some packages are outdated in upstream...
    case "$repo_pkgname" in
        gamecube-tools) repo_pkgver=1.0.6 ;;
        gp32-tools) repo_pkgver=1.0.4 ;;
    esac

    pkgbuild="../$repo_pkgname/PKGBUILD"
    test ! -f "$pkgbuild" && continue
    ( source "$pkgbuild"
        if [ "$pkgver" != "$repo_pkgver" ]; then
            echo "Update: $repo_pkgname -> $repo_pkgver"
        fi
    )
done
