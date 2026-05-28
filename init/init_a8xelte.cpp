/*
 * Copyright (C) 2024 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdlib>
#include <fstream>
#include <string>
#include <vector>

#include <android-base/properties.h>
#include <android-base/strings.h>
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;
using android::base::SetProperty;
using android::base::Split;
using android::base::Trim;
using android::init::property_set;

static void property_override(char const prop[], char const value[], bool add = true) {
    auto pi = const_cast<prop_info*>(__system_property_find(prop));
    if (pi != nullptr) {
        __system_property_update(pi, value, strlen(value));
    } else if (add) {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

static void load_dalvik() {
    // 3GB RAM device
    property_set("dalvik.vm.heapstartsize", "8m");
    property_set("dalvik.vm.heapgrowthlimit", "192m");
    property_set("dalvik.vm.heapsize", "512m");
    property_set("dalvik.vm.heaptargetutilization", "0.75");
    property_set("dalvik.vm.heapminfree", "512k");
    property_set("dalvik.vm.heapmaxfree", "8m");
}

static void set_model_props() {
    // Determine model based on bootloader or other properties
    std::string bootloader = GetProperty("ro.bootloader", "");

    if (bootloader.find("A810S") != std::string::npos) {
        property_override("ro.product.model", "SM-A810S");
        property_override("ro.product.device", "a8xelte");
        property_override("ro.build.product", "a8xelte");
        property_override("ro.product.name", "a8xelteskt");
    } else if (bootloader.find("A810K") != std::string::npos) {
        property_override("ro.product.model", "SM-A810K");
        property_override("ro.product.device", "a8xelte");
        property_override("ro.build.product", "a8xelte");
        property_override("ro.product.name", "a8xeltektt");
    } else if (bootloader.find("A810L") != std::string::npos) {
        property_override("ro.product.model", "SM-A810L");
        property_override("ro.product.device", "a8xelte");
        property_override("ro.build.product", "a8xelte");
        property_override("ro.product.name", "a8xeltelgt");
    } else if (bootloader.find("A810F") != std::string::npos) {
        property_override("ro.product.model", "SM-A810F");
        property_override("ro.product.device", "a8xelte");
        property_override("ro.build.product", "a8xelte");
        property_override("ro.product.name", "a8xeltejt");
    } else if (bootloader.find("A8100") != std::string::npos) {
        property_override("ro.product.model", "SM-A8100");
        property_override("ro.product.device", "a8xelte");
        property_override("ro.build.product", "a8xelte");
        property_override("ro.product.name", "a8xeltezh");
    } else if (bootloader.find("A810Y") != std::string::npos) {
        property_override("ro.product.model", "SM-A810Y");
        property_override("ro.product.device", "a8xelte");
        property_override("ro.build.product", "a8xelte");
        property_override("ro.product.name", "a8xeltesea");
    } else {
        // Default to A810S
        property_override("ro.product.model", "SM-A810S");
        property_override("ro.product.device", "a8xelte");
        property_override("ro.build.product", "a8xelte");
        property_override("ro.product.name", "a8xelteskt");
    }
}

void vendor_load_properties() {
    load_dalvik();
    set_model_props();
}
