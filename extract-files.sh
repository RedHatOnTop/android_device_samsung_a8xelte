#!/bin/bash
#
# Copyright (C) 2024 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Extract proprietary files from a Galaxy A8 2016 (SM-A810S) running stock Oreo
# Usage:
#   ./extract-files.sh /path/to/system/mount/point  (from a running device via adb)
#   ./extract-files.sh /path/to/extracted/system.img (from firmware tar)

DEVICE=a8xelte
VENDOR=samsung
DEVICE_ROOT=vendor/$VENDOR/$DEVICE

set -e

if [ $# -eq 0 ]; then
    SRC=adb
else
    SRC=$1
fi

# Clean old blobs
rm -rf "$DEVICE_ROOT"/*

echo "Extracting proprietary files from $SRC..."

# Helper function to pull a file
function pull() {
    local src="$1"
    local dst="$2"

    if [ "$SRC" = "adb" ]; then
        adb pull "$src" "$dst"
    else
        cp "$SRC/$src" "$dst" 2>/dev/null || true
    fi
}

# Create directories
mkdir -p "$DEVICE_ROOT/lib"
mkdir -p "$DEVICE_ROOT/lib64"
mkdir -p "$DEVICE_ROOT/bin"
mkdir -p "$DEVICE_ROOT/etc/firmware"
mkdir -p "$DEVICE_ROOT/etc/wifi"
mkdir -p "$DEVICE_ROOT/framework"
mkdir -p "$DEVICE_ROOT/vendor/etc"

# Read the blob list and extract
while IFS="|" read -r src dst; do
    # Skip comments and empty lines
    [[ "$src" =~ ^#.*$ ]] && continue
    [[ -z "$src" ]] && continue

    # Trim whitespace
    src=$(echo "$src" | xargs)
    dst=$(echo "$dst" | xargs)

    # Create destination directory
    mkdir -p "$(dirname "$DEVICE_ROOT/$dst")"

    echo "Pulling: $src -> $DEVICE_ROOT/$dst"
    pull "$src" "$DEVICE_ROOT/$dst"
done < proprietary-files.txt

echo "Done! Files extracted to $DEVICE_ROOT/"
echo ""
echo "IMPORTANT: Review the extracted files and remove any that are not needed."
echo "You may need to manually extract additional files from the stock firmware."
