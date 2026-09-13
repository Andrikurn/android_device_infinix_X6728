#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/infinix/X6728/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

BOARD_VENDOR := Infinix
PRODUCT_NAME := lineage_X6728
PRODUCT_DEVICE := X6728
PRODUCT_MANUFACTURER := infinix
PRODUCT_BRAND := Infinix
PRODUCT_MODEL := Infinix X6728

PRODUCT_GMS_CLIENTID_BASE := android-transsion

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceName=X6728 \
    BuildFingerprint=Infinix/X6728-OP/Infinix-X6728:15/AP3A.240905.015.A2/165001:user/release-keys

# Time
LINEAGE_VERSION_APPEND_TIME_OF_DAY := true