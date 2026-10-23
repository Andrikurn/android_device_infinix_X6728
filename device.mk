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

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-V1-ndk.vendor:64 \
    android.hardware.health-V3-ndk.vendor:64 \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery \
    charger_res_images_vendor

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0:64 \
    android.hidl.allocator@1.0:64 \
    android.hidl.base@1.0.vendor:64 \
    android.hidl.allocator@1.0.vendor:64 \
    libhidltransport:64 \
    libhidlmemory.vendor:64 \
    libhidltransport.vendor:64 \
    libhwbinder:64 \
    libhwbinder.vendor:64

# IMS
$(call inherit-product, vendor/mediatek/ims/ims.mk)

# IR
# X6728 ships AOSP's example IR HAL as a prebuilt service, so only the AIDL
# interface is built here.
PRODUCT_PACKAGES += \
    android.hardware.ir-V1-ndk.vendor:64

# Init files
PRODUCT_PACKAGES += \
    fstab.mt6768 \
    fstab.mt6768.vendor_ramdisk \
    init_connectivity.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init.insmod.sh \
    init.insmod.mt6768.cfg \
    init.modem.rc \
    init.mt6768.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.recovery.usb.rc \
    init.sensor_1_0.rc \
    ueventd.mt6768.rc

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-V1-ndk.vendor:64 \
    android.hardware.light-V2-ndk.vendor:64 \
    android.hardware.lights-service.millennium

# Enable DM file pre-opting to reduce first boot time
PRODUCT_DEX_PREOPT_GENERATE_DM_FILES := true

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster-V4-ndk.vendor:64

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-V1-ndk.vendor:64 \
    android.hardware.security.keymint-V3-ndk.vendor:64 \
    android.hardware.security.secureclock-V1-ndk.vendor:64 \
    android.hardware.security.sharedsecret-V1-ndk.vendor:64 \
    android.hardware.security.rkp-V3-ndk.vendor \
    libcppbor_external.vendor:64

# Keystore
PRODUCT_PACKAGES += \
    android.system.keystore2-V1-ndk.vendor:64

# Linker
PRODUCT_VENDOR_LINKER_CONFIG_FRAGMENTS += \
    $(LOCAL_PATH)/configs/linker.config.json

# Media
$(call soong_config_set_bool,android_hardware_mediatek_codec2,link_v33_libstagefright_foundation,true)
PRODUCT_PACKAGES += \
    android.hardware.cas@1.2-service-lazy \
    android.hardware.media.bufferpool2-V2-ndk.vendor:64 \
    android.hardware.media.c2-V1-ndk.vendor:64 \
    android.hardware.media.c2-mtk-service \
    libcodec2_vndk.vendor:64 \
    libcodec2_aidl.vendor:64 \
    libcodec2_hidl@1.0.vendor:64 \
    libcodec2_hidl@1.1.vendor:64 \
    libcodec2_hidl@1.2.vendor:64 \
    libcodec2_hidl_plugin:64 \
    libeffects:64 \
    libeffectsconfig.vendor:64 \
    libavservices_minijail_vendor:64 \
    libstagefright_softomx_plugin.vendor:64 \
    libsfplugin_ccodec_utils.vendor:64 \
    libcodec2_soft_common.vendor:64 \
    libcodec2.vendor:64 \
    libstagefright_bufferpool@2.0.1.vendor:64 \
    libmediautils_vendor.vendor:64 \
    libflatbuffers-cpp.vendor:64

PRODUCT_PACKAGES += \
    libchrome.vendor:64 \
    libminijail:64 \
    libminijail.vendor:64

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/media,$(TARGET_COPY_OUT_VENDOR)/etc)

# Memory
# Stock ships libmeminfo's dmabuf debug tool; the platform provides it.
PRODUCT_PACKAGES += \
    dmabuf_dump.vendor:64

# Neural networks
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks@1.0.vendor:64 \
    android.hardware.neuralnetworks@1.3.vendor:64 \
    libtextclassifier_hash.vendor:64

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-V1-ndk.vendor:64 \
    android.hardware.nfc-service.nxp \
    com.android.nfc_extras \
    Tag \
    vendor.nxp.nxpese@1.0.vendor:64 \
    vendor.nxp.nxpnfc_aidl-V1-ndk.vendor:64

# Overlays
$(call inherit-product, hardware/mediatek/overlay/mssi.mk)
PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    FrameworkResOverlayX6728 \
    SettingsResOverlayX6728 \
    SettingsProviderOverlayX6728 \
    SystemUIResOverlayX6728

PRODUCT_PACKAGES += \
    NcmTetheringOverlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2024-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2024-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr

PRODUCT_PACKAGES += \
    android.hardware.power-V4-ndk.vendor:64 \
    android.hardware.power-V5-ndk.vendor:64 \
    android.system.suspend-V1-ndk.vendor:64 \
    vendor.mediatek.hardware.mtkpower@1.2-service.stub:64 \
    vendor.mediatek.hardware.mtkpower@1.0.vendor:64 \
    vendor.mediatek.hardware.mtkpower@1.1.vendor:64 \
    vendor.mediatek.hardware.mtkpower@1.2.vendor:64 \
    vendor.mediatek.hardware.mtkpower-V1-ndk.vendor:64 \
    vendor.mediatek.hardware.mtkpower-V2-ndk.vendor:64

PRODUCT_PACKAGES += \
    android.hardware.power@1.3.vendor:64

# Power
PRODUCT_PACKAGES += \
    libmtkperf_client_vendor:64 \
    libmtkperf_client:64 \
    libpower.vendor:64

# Power configurations
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/power/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Properties
include $(LOCAL_PATH)/vendor_logtag.mk

# Protobuf
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full.vendor:64 \
    libprotobuf-cpp-lite.vendor:64 \
    libprotobuf-cpp-lite-21.12-vendorcompat:64 \
    libprotobuf-cpp-full-3.9.1-vendorcompat:64 \
    libprotobuf-cpp-lite-3.9.1-vendorcompat:64
