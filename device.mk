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

LOCAL_PATH := device/samsung/a8xelte

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Audio
# Stock firmware uses /vendor/etc/mixer_paths.xml (HIDL audio HAL 2.0)
# The mixer_paths.xml includes /system/etc/mixer_gains.xml
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_0.xml \
	$(LOCAL_PATH)/configs/audio/mixer_gains.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/mixer_gains.xml

# Livedisplay
PRODUCT_PACKAGES += \
	vendor.lineage.livedisplay@2.1-service.zero

# Thermal config
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/configs/thermal/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

# Wi-Fi
PRODUCT_PACKAGES += \
	WifiOverlay
# WiFi firmware and config are handled via proprietary-files.txt vendor blobs
# Kernel defconfig uses: CONFIG_BCMDHD_FW_PATH="/vendor/etc/wifi/bcmdhd_sta.bin"

# Inherit from universal7420-common
$(call inherit-product, device/samsung/universal7420-common/device-common.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

# Call the proprietary
$(call inherit-product, vendor/samsung/a8xelte/a8xelte-vendor.mk)
