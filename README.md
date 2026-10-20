# OnePlus Nord 2T 5G (karen) Device Tree

Device tree for the OnePlus Nord 2T 5G (codename: `karen`) targeting LineageOS 23.2 (Android 14) with forward compatibility for Android 15/16.

## Device Specifications

| Property | Value |
|----------|-------|
| **Codename** | `karen` |
| **Device Name** | OP557AL1 (OnePlus Nord 2T 5G) |
| **Model Variants** | CPH2399 (Global/EU), CPH2401 (India) |
| **SoC** | MediaTek MT6893 (Dimensity 1300 5G, 6 nm) |
| **CPU** | Octa-core (1×3.0 GHz Cortex-A78 + 3×2.6 GHz Cortex-A78 + 4×2.0 GHz Cortex-A55) |
| **GPU** | Mali-G77 MC9 |
| **Memory** | 8 GB / 12 GB LPDDR4X |
| **Storage** | 128 GB / 256 GB UFS 3.1 |
| **Shipped OS** | Android 12.1 (OxygenOS 12.1) |
| **Battery** | 4500 mAh Li-Po, non-removable, 80W wired charging |
| **Display** | 6.43" AMOLED, 1080×2400, 90 Hz, HDR10+, 20:9 (~409 ppi) |
| **Rear Camera** | 50 MP f/1.8 (OIS) + 8 MP f/2.2 (ultrawide, 120°) + 2 MP f/2.2 (monochrome) |
| **Front Camera** | 32 MP f/2.4 |
| **Fingerprint** | Under-display optical (UDFPS) |
| **Alert Slider** | 3-position hardware slider |

## Source Dependencies

### Required Repositories

Add the following to `.repo/local_manifests/karen.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <!-- Device Tree -->
  <project path="device/oneplus/karen" name="Jackson4Rocks/android_device_oneplus_karen" remote="github" revision="lineage-23.2" />

  <!-- Common Device Tree (mt6893) -->
  <project path="device/oplus/mt6893-common" name="mt6893-development/android_device_oplus_mt6893-common" remote="github" revision="lineage-23.2" />

  <!-- Kernel -->
  <project path="kernel/oneplus/karen" name="mt6893-development/android_kernel_oplus_mt6893" remote="github" revision="lineage-23.2" />
  <project path="kernel/oplus/mt6893" name="mt6893-development/android_kernel_oplus_mt6893" remote="github" revision="lineage-23.2" />

  <!-- Vendor Blobs -->
  <project path="vendor/oplus/mt6893-common" name="mt6893-development/proprietary_vendor_oplus_mt6893-common" remote="github" revision="lineage-23.2" />
  <project path="vendor/oplus/op6893" name="mt6893-development/proprietary_vendor_oplus_op6893" remote="github" revision="lineage-23.2" />

  <!-- Hardware HALs -->
  <project path="hardware/mediatek" name="LineageOS/android_hardware_mediatek" remote="github" revision="lineage-23.2" />
  <project path="hardware/oplus" name="LineageOS/android_hardware_oplus" remote="github" revision="lineage-23.2" />

  <!-- SEPolicy -->
  <project path="device/mediatek/sepolicy_vndr" name="LineageOS/android_device_mediatek_sepolicy_vndr" remote="github" revision="lineage-23.2" />
</manifest>
```

### Repository Index

| Repository | Path | Branch |
|------------|------|--------|
| Jackson4Rocks/android_device_oneplus_karen | `device/oneplus/karen` | lineage-23.2 |
| mt6893-development/android_device_oplus_mt6893-common | `device/oplus/mt6893-common` | lineage-23.2 |
| mt6893-development/android_kernel_oplus_mt6893 | `kernel/oneplus/karen` | lineage-23.2 |
| mt6893-development/android_kernel_oplus_mt6893 | `kernel/oplus/mt6893` | lineage-23.2 |
| mt6893-development/proprietary_vendor_oplus_mt6893-common | `vendor/oplus/mt6893-common` | lineage-23.2 |
| mt6893-development/proprietary_vendor_oplus_op6893 | `vendor/oplus/op6893` | lineage-23.2 |
| LineageOS/android_hardware_mediatek | `hardware/mediatek` | lineage-23.2 |
| LineageOS/android_hardware_oplus | `hardware/oplus` | lineage-23.2 |
| LineageOS/android_device_mediatek_sepolicy_vndr | `device/mediatek/sepolicy_vndr` | lineage-23.2 |

## Building Instructions

### Prerequisites

- Ubuntu 22.04+ or equivalent Linux distribution
- Minimum 16 GB RAM (32 GB recommended)
- 200+ GB free disk space
- `repo` tool installed and in PATH

### Initialize Source

```bash
# Initialize LineageOS 23.2 (Android 14)
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs

# Sync sources (adjust -j for your CPU cores)
repo sync -j$(nproc) --current-branch --no-clone-bundle --no-tags --optimized-fetch --prune
```

### Build

```bash
# Setup build environment
source build/envsetup.sh

# Configure device
breakfast karen

# Build (use -j for parallel jobs)
croot && brunch karen
```

Output images will be located at `out/target/product/karen/`.

## Supported Features

| Feature | Status | Notes |
|---------|--------|-------|
| **Boot** | ✅ Working | Verified boot with AVB 2.0 |
| **Display** | ✅ Working | 90 Hz, HDR10+, DC dimming |
| **Audio** | ✅ Working | Primary HAL, A2DP, USB audio |
| **Camera** | ✅ Working | All lenses, CameraGo included |
| **Fingerprint (UDFPS)** | ✅ Working | Optical, with screen-off FOD |
| **Alert Slider** | ✅ Working | 3-position hardware slider |
| **Double Tap to Wake** | ✅ Working | Configurable via Settings |
| **Pocket Mode** | ✅ Working | Proximity-based screen blocking |
| **NFC** | ✅ Working | NXP controller, Secure Element |
| **Wi-Fi** | ✅ Working | 2.4/5 GHz, Wi-Fi Direct |
| **Bluetooth** | ✅ Working | aptX/aptX HD, A2DP |
| **Mobile Data** | ✅ Working | 5G/4G/3G, VoLTE, ViLTE, WiFi Calling |
| **Sensors** | ✅ Working | Accelerometer, gyro, proximity, light |
| **Vibrator** | ✅ Working | QTI haptic driver |
| **SELinux** | ✅ Enforcing | Custom policy for vendor services |
| **Encryption** | ✅ Working | FBE + metadata encryption |
| **DTBO/Recovery** | ✅ Working | Prebuilt DTBO, recovery-as-boot |
| **OTA Updates** | ✅ Working | A/B (dynamic partitions) |

## Known Limitations

- **Widevine L1**: Dependent on vendor blobs; may require extraction from stock firmware
- **DRM Protected Content**: Streaming quality may vary by app implementation
- **Kernel Version**: Based on 5.4.x; upstream updates from MediaTek required for newer kernel features

## Forward Compatibility

This device tree includes forward-compatibility provisions for Android 15 (API 35) and Android 16 (API 36):

- `PRODUCT_EXTRA_VNDK_VERSIONS := 33 34 35 36`
- Target SDK version 36 for all privileged apps
- Modern Clang toolchain (`TARGET_KERNEL_CLANG_VERSION := r547379`)
- ART profile-guided compilation enabled
- APEX flattening enabled

## SEPolicy Notes

Custom SEPolicy rules are defined in:
- `sepolicy/vendor/` — Vendor domain types and macros
- `sepolicy/private/` — Private domain transitions and permissions
- `sepolicy/public/` — Public sysfs types for platform apps

All vendor services run in dedicated domains with minimal required permissions.

## License

```
Copyright (C) 2026 The LineageOS Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Credits

- **LineageOS Project** — Base framework and build system
- **mt6893-development** — MediaTek mt6893 common device tree, kernel, and vendor blobs
- **oneplus-karen-roms** — Original device tree reference
- **OnePlus Nord 2T Community** — Testing and feedback

## Maintainer

- **Jackson4Rocks** — Device tree maintenance and LineageOS integration

---

For issues, feature requests, or contributions, please refer to the project repository issue tracker.