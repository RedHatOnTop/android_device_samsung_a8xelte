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

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# inherit from universal7420-common
include device/samsung/universal7420-common/BoardConfigCommon.mk

DEVICE_PATH := device/samsung/a8xelte

# Assert
TARGET_OTA_ASSERT_DEVICE := a8xelte,a8xeltejt,a8xelteskt,a8xeltelgt,a8xeltektt

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Fingerprint-shims
TARGET_LD_SHIM_LIBS += \
	/vendor/lib/libbauthserver.so|/vendor/lib/libbauthtzcommon_shim.so \
	/vendor/lib64/libbauthserver.so|/vendor/lib64/libbauthtzcommon_shim.so

# Include path (commented out - $(DEVICE_PATH)/include does not exist yet)
# TARGET_SPECIFIC_HEADER_PATH += $(DEVICE_PATH)/include

# Init (enables multi-variant boot detection for S/K/L/F/0/Y variants)
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_a8xelte

# Kernel (use a8xelteskt defconfig from samsungexynos7420 kernel repo)
TARGET_KERNEL_CONFIG := exynos7420-a8xelteskt_defconfig

# DTB handling - use stock DTBs from firmware
BOARD_MKBOOTIMG_ARGS := --second_offset 0x00F00000

# Manifest
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# inherit from the proprietary version
include vendor/samsung/a8xelte/BoardConfigVendor.mk
