# Samsung Galaxy A8 2016 (SM-A810S) — LineageOS 20.0 Port

Device tree for building LineageOS 20.0 (Android 13) for the Samsung Galaxy A8 2016 (codename: `a8xelte`).

## Device Specifications

| Property | Value |
|---|---|
| SoC | Samsung Exynos 7 Octa 7420 (14nm) |
| CPU | 4x 2.1 GHz Cortex-A57 + 4x 1.5 GHz Cortex-A53 |
| GPU | ARM Mali-T760 MP8 @ 772 MHz |
| RAM | 3 GB LPDDR4 |
| Display | 5.7" Super AMOLED, 1080x1920 |
| Storage | 32/64 GB UFS |
| Battery | 3300 mAh (non-removable) |
| Camera | 16 MP rear, 8 MP front |
| Kernel | Linux 3.10 |

## Supported Variants

| Model | Region | Carrier |
|---|---|---|
| SM-A810S | Korea | SK Telecom |
| SM-A810K | Korea | KT |
| SM-A810L | Korea | LG U+ |
| SM-A810F | International | — |
| SM-A810YZ | Taiwan | — |
| SM-A8100 | China | — |

## Build Instructions

### Prerequisites

- Ubuntu 20.04+ (or WSL2 on Windows)
- 16 GB+ RAM
- 250 GB+ free disk space
- Good internet connection

### Step 1: Set up build environment

```bash
# Install build dependencies
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk git gnupg flex bison gperf build-essential \
    zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
    lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
    libgl1-mesa-dev libxml2-utils xsltproc unzip python3

# Install repo tool
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# Configure git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Step 2: Initialize LineageOS 20.0 source

```bash
mkdir -p ~/los-20 && cd ~/los-20
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
```

### Step 3: Add local manifest

```bash
mkdir -p .repo/local_manifests
# Copy the a8xelte.xml manifest from this repo
cp /path/to/a810sporttest/local_manifests/a8xelte.xml .repo/local_manifests/
```

### Step 4: Clone the 7420 patches and apply them

```bash
cd ~
git clone https://github.com/samsungexynos7420/7420_patches --branch lineage-20.0
cd ~/los-20
cp ~/7420_patches/apply.sh .
chmod +x apply.sh
./apply.sh
```

### Step 5: Sync source

```bash
cd ~/los-20
repo sync -j$(nproc)
```

### Step 6: Extract proprietary blobs

**Option A: From the physical device (recommended)**

```bash
# Boot the device into stock Oreo, enable USB debugging
# Connect via USB
adb root
adb remount
cd device/samsung/a8xelte
./extract-files.sh adb
```

**Option B: From firmware tar**

```bash
# Download SM-A810S Oreo firmware from sfirmware.com
# Extract the AP tar file
tar xvf A810SKSU2CRH1_A810SKSU2CRH1_SKC.tar.md5
# Mount system.img
mkdir /tmp/a810s_system
sudo mount -o ro,loop system.img /tmp/a810s_system
# Extract blobs
cd device/samsung/a8xelte
./extract-files.sh /tmp/a810s_system
```

### Step 7: Build

```bash
cd ~/los-20
source build/envsetup.sh
lunch lineage_a8xelte-userdebug
make bacon -j$(nproc)
```

The build output will be at `out/target/product/a8xelte/lineage-20.0-*.zip`.

### Step 8: Flash

1. Flash TWRP via Odin (use the SM-A810F TWRP 3.1.0-1 as a starting point)
2. Boot to TWRP recovery
3. Wipe system, data, cache, dalvik
4. Flash the LineageOS zip
5. Flash GApps (use MindTheGapps Legacy from samsungexynos7420 org)
6. Reboot

## Known Issues / TODO

- [ ] Display panel: Need to verify correct panel driver for 1080p panel
- [ ] Camera: Front camera sensor may differ from S6, needs testing
- [ ] Audio: mixer_paths.xml needs to be extracted from stock firmware
- [ ] Thermal config: Needs to be calibrated for A8 2016 thermal characteristics
- [ ] Battery: Verify charging control paths
- [ ] Sensors: May need device-specific sensor HAL configuration
- [ ] NFC: Verify NFC chip compatibility
- [ ] RIL: Verify modem firmware compatibility with SK Telecom variant
- [ ] Kernel defconfig: Should be extracted from /proc/config.gz on stock device

## Credits

- [samsungexynos7420](https://github.com/samsungexynos7420) organization — common device tree, kernel, and vendor blobs
- [universal7420](https://github.com/universal7420) organization — original Exynos 7420 AOSP work
- [Exynos7420](https://github.com/Exynos7420) organization — early Exynos 7420 device trees
- LineageOS team

## License

Apache License 2.0
