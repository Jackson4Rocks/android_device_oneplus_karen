# Device tree for the OnePlus Nord 2T 5G (karen)

| Basic | Spec Sheet |
| --- | --- |
| Codename | `karen` |
| Device name | `OP557AL1` (OnePlus Nord 2T 5G) |
| Model names | `CPH2399` "EU" global model `CPH2401` India model |
| CPU | Octa-core |
| Chipset | MediaTek MT6893 Dimensity 1300 5G (6 nm) (MT6893Z_Z/CZA) |
| GPU | Mali-G77 MC9 |
| Memory | 8/12 GB RAM |
| Shipped Android Version | Android 12.1 (OxygenOS 12.1) |
| Storage | 128/256 GB |
| Battery | Li-Po 4500 mAh, non-removable |
| Display | AMOLED, 90Hz, HDR10+ 1080 x 2400 pixels, 20:9 ratio (~409 ppi density) |
| Camera (Back)(Main) | 50 MP, f/1.8, 24mm (wide), 1/1.56", 1.0µm, PDAF, OIS 8 MP, f/2.2, 120˚ (ultrawide) 2 MP, f/2.2, (monochrome) |
| Camera (Front) | 32 MP, f/2.4, (wide), 1/2.8", 0.8µm |

![OnePlus Nord 2T 5G](https://fdn2.gsmarena.com/vv/pics/oneplus/oneplus-nord-2t-5g-1.jpg)

## Building

First init LineageOS.

```
repo init -u https://github.com/LineageOS/android.git -b lineage-23.2
```

Add the file `.repo/local_manifests/local_manifest.xml`

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <!-- Device Tree -->
  <project path="device/oneplus/karen" name="Jackson4Rocks/android_device_oneplus_karen.git" remote="github" revision="lineage-23.2" />

  <!-- Common Device Tree -->
  <project path="device/oplus/mt6893-common" name="mt6893-development/android_device_oplus_mt6893-common.git" remote="github" revision="lineage-23.2" />

  <!-- Kernel -->
  <project path="kernel/oneplus/karen" name="mt6893-development/android_kernel_oplus_mt6893.git" remote="github" revision="lineage-23.2" />
  <project path="kernel/oplus/mt6893" name="mt6893-development/android_kernel_oplus_mt6893.git" remote="github" revision="lineage-23.2" />

  <!-- Vendor blobs -->
  <project path="vendor/oplus/mt6893-common" name="mt6893-development/proprietary_vendor_oplus_mt6893-common.git" remote="github" revision="lineage-23.2" />
  <project path="vendor/oplus/op6893" name="mt6893-development/proprietary_vendor_oplus_op6893.git" remote="github" revision="lineage-23.2" />

  <!-- Hardware -->
  <project path="hardware/mediatek" name="LineageOS/android_hardware_mediatek.git" remote="github" revision="lineage-23.2" />
  <project path="hardware/oplus" name="LineageOS/android_hardware_oplus.git" remote="github" revision="lineage-23.2" />

  <!-- Mediatek SEPolicy -->
  <project path="device/mediatek/sepolicy_vndr" name="LineageOS/android_device_mediatek_sepolicy_vndr.git" remote="github" revision="lineage-23.2" />
</manifest>
```

And then... see you 160GiB later!

```
repo sync -j5 --current-branch --no-clone-bundle --no-tags
```

Welcome back. Still OK? Good, now you can build.

```
source build/envsetup.sh; breakfast karen
croot && brunch karen
```

## Required Repositories

| Repository | Path | Branch |
|------------|------|--------|
| Jackson4Rocks/android_device_oneplus_karen | device/oneplus/karen | lineage-23.2 |
| mt6893-development/android_device_oplus_mt6893-common | device/oplus/mt6893-common | lineage-23.2 |
| mt6893-development/android_kernel_oplus_mt6893 | kernel/oneplus/karen | lineage-23.2 |
| mt6893-development/android_kernel_oplus_mt6893 | kernel/oplus/mt6893 | lineage-23.2 |
| mt6893-development/proprietary_vendor_oplus_mt6893-common | vendor/oplus/mt6893-common | lineage-23.2 |
| mt6893-development/proprietary_vendor_oplus_op6893 | vendor/oplus/op6893 | lineage-23.2 |
| LineageOS/android_hardware_mediatek | hardware/mediatek | lineage-23.2 |
| LineageOS/android_hardware_oplus | hardware/oplus | lineage-23.2 |
| LineageOS/android_device_mediatek_sepolicy_vndr | device/mediatek/sepolicy_vndr | lineage-23.2 |

## Credits

- LineageOS Project
- MediaTek mt6893 common maintainers (mt6893-development)
- oneplus-karen-roms for original device tree
- OnePlus Nord 2T community