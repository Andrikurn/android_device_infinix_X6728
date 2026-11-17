#
# Copyright (C) 2023-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Camera variant for the soong_config srcs switch in vendor/infinix/X6728/Android.bp
# (libcameracustom). Must be set before device.mk so the build system sees it.
SOONG_CONFIG_NAMESPACES += tecno_camera
SOONG_CONFIG_tecno_camera += camera_variant
SOONG_CONFIG_tecno_camera_camera_variant := x6728

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/infinix/X6728/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_X6728
PRODUCT_DEVICE := X6728
PRODUCT_MANUFACTURER := Infinix
PRODUCT_BRAND := Infinix
PRODUCT_MODEL := Infinix X6728

PRODUCT_SYSTEM_NAME := Infinix-X6728
PRODUCT_SYSTEM_DEVICE := X6728

PRODUCT_GMS_CLIENTID_BASE := android-transsion

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sys_tssi_64_64only_infinix-user 15 AP3A.240905.015.A2 995662 dev-keys" \
    BuildFingerprint=Infinix/X6728-OP/Infinix-X6728:15/AP3A.240905.015.A2/260912V2641:user/release-keys \
    SystemModel="Infinix X6728" \
    SystemName=Infinix-X6728 \
    ProductModel="Infinix X6728" \
    DeviceProduct=X6728-OP
