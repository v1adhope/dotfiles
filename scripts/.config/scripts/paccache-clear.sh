#!/bin/sh

# The location of the cache for your aur helper
AUR_CACHE_DIR=$HOME/.cache/paru/clone

# Get all cache directories for AUR helper
AUR_CACHE_REMOVED="$(find "$AUR_CACHE_DIR" -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
# Remove everything for uninstalled AUR packages
AUR_REMOVED=$(/usr/bin/paccache -ruvk0 $AUR_CACHE_REMOVED | sed '/\.cache/!d' | cut -d \' -f2 | rev | cut -d / -f2- | rev)
[ -z "$AUR_REMOVED" ] || rm -rf $AUR_REMOVED

# Keep latest version for uninstalled native packages, keep two latest versions for installed packages
# Get all cache directories for AUR helper (without removed packages)
AUR_CACHE="$(find "$AUR_CACHE_DIR" -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
/usr/bin/paccache -qruk1
/usr/bin/paccache -qrk2 -c /var/cache/pacman/pkg $AUR_CACHE
