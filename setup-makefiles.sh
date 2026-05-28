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

# This script is kept for reference only.
# The vendor makefiles are now maintained in the separate repo:
#   RedHatOnTop/proprietary_vendor_samsung_a8xelte
#
# During crave.io builds, the vendor repo is cloned by .craverc.
# Run this script only if you need to regenerate vendor makefiles locally.

DEVICE=a8xelte
VENDOR=samsung
DEVICE_ROOT=vendor/$VENDOR/$DEVICE

if [ -d "$DEVICE_ROOT" ] && [ -f "$DEVICE_ROOT/$DEVICE-vendor.mk" ]; then
    echo "Vendor makefiles already exist at $DEVICE_ROOT/"
    echo "They are maintained in RedHatOnTop/proprietary_vendor_samsung_a8xelte"
    exit 0
fi

echo "WARNING: Vendor makefiles not found at $DEVICE_ROOT/"
echo "The vendor tree should come from the proprietary_vendor_samsung_a8xelte repo."
echo "For local development, clone it:"
echo "  git clone https://github.com/RedHatOnTop/proprietary_vendor_samsung_a8xelte -b lineage-20.0 $DEVICE_ROOT"
