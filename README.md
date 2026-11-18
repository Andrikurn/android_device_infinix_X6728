# Device tree for the Infinix HOT 60i (X6728)

## Device specifications

| Basic                   | Spec                                                        |
| ----------------------- | :---------------------------------------------------------- |
| SoC                     | MediaTek Helio G81 (MT6768, 12 nm)                          |
| CPU                     | Octa-core (2x2.0 GHz Cortex-A75 & 6x1.8 GHz Cortex-A55)     |
| GPU                     | Mali-G52 MC2                                                |
| Memory                  | 4 / 6 / 8 GB                                                |
| Shipped Android version | 15 (XOS 15)                                                 |
| Storage                 | 128 / 256 GB                                                |
| MicroSD                 | microSDXC                                                   |
| Battery                 | Non-removable Li-Po 5160 mAh                                |
| Display                 | 720 x 1600 pixels, 6.7 inches, 120 Hz IPS LCD               |
| Rear Camera             | 50 MP                                                       |
| Front Camera            | 8 MP                                                        |

## GMS variants

The default build is vanilla LineageOS. Optional variants are selected at lunch time:

- `WITH_GAPPS=true` inherits `vendor/gapps/arm64/arm64-vendor.mk`. Sync a GApps repo
  to `vendor/gapps` before enabling it.
- `WITH_MICROG=true` inherits `vendor/partner_gms/microg.mk` and adds that path to
  `PRODUCT_SOONG_NAMESPACES`. Sync `vendor/partner_gms` before enabling it.

Neither repo is in `lineage.dependencies`; both must be synced manually. Clear
`out/target/product/X6728` when switching variants.

## SystemUI shade patch

`vendorsetup.sh` applies `patches/systemui/0001-*.patch` to `frameworks/base` on every
envsetup by default (opt out with `PATCH_SHADE=0`). It is generated against a specific
upstream file revision; if upstream drifts the patch stops applying and the shade
performance handler becomes a no-op. See `patches/systemui/README.md`.
