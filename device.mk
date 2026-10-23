#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
$(call soong_config_set,update_engine,map_vabc_in_recovery,true)

AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    dtbo \
    init_boot \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot \
    vendor_dlkm \
    system_dlkm

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=$(BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE) \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=$(BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE) \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    otapreopt_script \
    checkpoint_gc

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

PRODUCT_PACKAGES += \
    create_pl_dev \
    create_pl_dev.recovery

# AIDL
# The prebuilt HALs link AIDL support libraries that the platform provides.
PRODUCT_PACKAGES += \
    android.frameworks.stats-V1-ndk.vendor:64 \
    android.frameworks.stats-V2-ndk.vendor:64 \
    android.hardware.common-V2-ndk.vendor:64 \
    android.hardware.common.fmq-V1-ndk.vendor:64

# Audio
$(call soong_config_set,android_hardware_audio,run_64bit,true)
$(call soong_config_set_bool,android_hardware_audio,skip_speaker_layout_channel_mask_field,true)

# X6728 ships the AIDL audio HAL: the service
# (vendor/bin/hw/android.hardware.audio.service-aidl.mediatek) and its impls are
# prebuilts, so here we only provide the AIDL interfaces.
PRODUCT_PACKAGES += \
    android.hardware.audio.core-V2-ndk.vendor:64 \
    android.hardware.audio.core.sounddose-V2-ndk.vendor:64 \
    android.hardware.audio.common-V3-ndk.vendor:64 \
    android.hardware.audio.common-V5-ndk.vendor:64 \
    android.hardware.audio.effect-V2-ndk.vendor:64 \
    android.hardware.audio.effect-V4-ndk.vendor:64 \
    android.hardware.soundtrigger3-V1-ndk.vendor:64 \
    android.hardware.soundtrigger3-V2-ndk.vendor:64 \
    android.hardware.bluetooth.audio-V4-ndk.vendor:64 \
    android.hardware.bluetooth.audio-V6-ndk.vendor:64 \
    android.media.audio.common.types-V2-ndk.vendor:64 \
    android.media.audio.common.types-V3-ndk.vendor:64 \
    android.media.audio.common.types-V5-ndk.vendor:64 \
    android.media.soundtrigger.types-V1-ndk.vendor:64 \
    android.media.soundtrigger.types-V2-ndk.vendor:64 \
    vendor.mediatek.hardware.audio-V1-ndk.vendor:64

# The AOSP effect implementations are built from source, like the reference
# MTK trees on this branch do. The stock blobs would shadow the platform
# modules and drag in the AIDL versions they were built against.
PRODUCT_PACKAGES += \
    libaecsw \
    libagc1sw \
    libagc2sw \
    libbassboostsw \
    libbundleaidl \
    libdownmixaidl \
    libdynamicsprocessingaidl \
    libenvreverbsw \
    libequalizersw \
    libextensioneffect \
    libhapticgeneratoraidl \
    libloudnessenhanceraidl \
    libnssw \
    libpreprocessingaidl \
    libpresetreverbsw \
    libreverbaidl \
    libvirtualizersw \
    libvisualizeraidl \
    libvolumesw \
    libaudioaidlcommon.vendor:64 \
    libaudio_aidl_conversion_common_ndk.vendor:64

PRODUCT_PACKAGES += \
    audio.r_submix.default:64 \
    audio.usb.default:64

PRODUCT_PACKAGES += \
    audio_policy.stub:64 \
    libopus.vendor:64 \
    audioclient-types-aidl-cpp.vendor:64 \
    libaudioroute.vendor:64 \
    libaudiofoundation.vendor:64 \
    libbundlewrapper:64 \
    libbluetooth_audio_session:64 \
    libbluetooth_audio_session_aidl.vendor:64 \
    libaudiopreprocessing:64 \
    libalsautils:64 \
    libdownmix:64 \
    libeffectproxy:64 \
    libnbaio_mono:64 \
    libtinycompress:64 \
    libtinyalsa.vendor:64 \
    android.hardware.audio.common-util.vendor:64 \
    android.hardware.audio.common@6.0-util.vendor:64 \
    libdynproc:64 \
    libhapticgenerator:64 \
    libldnhncr:64 \
    libreverbwrapper:64 \
    libvisualizer:64 \
    libprocessgroup.vendor:64

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml

# Keep declaring the HIDL HAL instances that the vendor stack still serves.
PRODUCT_PACKAGES += \
    X6728_compatibility_matrix_202404_extension

PRODUCT_PACKAGES += \
    MtkInCallService

PRODUCT_PACKAGES += \
   vendor.mediatek.hardware.bluetooth.audio@2.1.vendor:64 \
   vendor.mediatek.hardware.bluetooth.audio@2.2.vendor:64

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth-V1-ndk.vendor:64 \
    android.hardware.bluetooth.audio@2.0.vendor:64 \
    android.hardware.bluetooth.audio@2.1.vendor:64 \
    android.hardware.bluetooth-service.mediatek

# Boot animation
TARGET_SCREEN_HEIGHT := 1600
TARGET_SCREEN_WIDTH := 720

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot-V1-ndk.vendor:64 \
    android.hardware.boot-service.mediatek \
    android.hardware.boot-service.mediatek_recovery

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.common@1.0.vendor:64 \
    android.hardware.camera.device@3.6.vendor:64 \
    android.hardware.camera.provider@2.4.vendor:64 \
    android.hardware.camera.provider@2.5.vendor:64 \
    android.hardware.camera.provider@2.6.vendor:64 \
    android.hardware.camera.common-V1-ndk.vendor:64 \
    android.hardware.camera.device-V3-ndk.vendor:64 \
    android.hardware.camera.metadata-V3-ndk.vendor:64 \
    android.hardware.camera.provider-V3-ndk.vendor:64

PRODUCT_PACKAGES += \
    libcamera_metadata_shim \
    libdng_sdk.vendor \
    libexif.vendor \
    libpiex \
    libpng.vendor

# Cgroup
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/cgroups.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Dalvik configs
PRODUCT_VENDOR_PROPERTIES += \
    dalvik.vm.heapstartsize=24m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.46 \
    dalvik.vm.heapminfree=8m \
    dalvik.vm.heapmaxfree=48m

# Display
# The composer (AIDL composer3, named android.hardware.graphics.composer@3.3-service)
# and the allocator are MediaTek prebuilts, so only memtrack is built here.
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service.mediatek

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V2-ndk.vendor:64 \
    android.hardware.graphics.common-V7-ndk.vendor:64 \
    android.hardware.graphics.composer3-V3-ndk.vendor:64 \
    android.hardware.graphics.mapper@4.0.vendor:64 \
    android.hardware.memtrack-V1-ndk.vendor:64 \
    android.frameworks.sensorservice@1.0.vendor:64 \
    libhwc2on1adapter:64 \
    libhwc2onfbadapter:64 \
    libdrm.vendor:64

PRODUCT_PACKAGES += \
    ANGLE

# DRM
PRODUCT_PACKAGES += \
    com.android.hardware.drm.clearkey

PRODUCT_PACKAGES += \
    android.hardware.drm@1.4.vendor \
    android.hardware.drm-V1-ndk.vendor:64

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# FastbootD
PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd:64

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.common-V3-ndk.vendor:64 \
    android.hardware.biometrics.fingerprint@2.1.vendor:64 \
    android.hardware.biometrics.fingerprint-V3-ndk.vendor:64

# Gatekeeper
# X6728 provides gatekeeper through the Trustonic service (prebuilt).
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper-V1-ndk.vendor:64

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss.measurement_corrections@1.1.vendor:64 \
    android.hardware.gnss.visibility_control@1.0.vendor:64 \
    android.hardware.gnss@1.1.vendor:64 \
    android.hardware.gnss@2.1.vendor:64 \
    android.hardware.gnss-V1-ndk.vendor:64 \
    android.hardware.gnss-V4-ndk.vendor:64

PRODUCT_PACKAGES += \
    libcurl.vendor:64 \
    libmnl.vendor:64
