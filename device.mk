#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Inherit generic_ramdisk product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Some MTK prebuilts are only 4K-page aligned
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Enable UFFD GC on GKI 6.6
PRODUCT_ENABLE_UFFD_GC := true

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_PACKAGES += \
    create_pl_dev \
    create_pl_dev.recovery

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio.common-util \
    android.hardware.audio.common@5.0 \
    android.hardware.audio.common@6.0 \
    android.hardware.audio.common@6.0-util \
    android.hardware.audio.effect@6.0 \
    android.hardware.audio@6.0 \
    audio.primary.default \
    audio.bluetooth.default \
    audio_policy.stub \
    audio.r_submix.default \
    audio.usb.default \
    libalsautilsv2 \
    libaudioaidlcommon \
    libaudioutils \
    libtinyalsa \
    libtinyalsav2

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
    libhapticgeneratoraidl \
    libloudnessenhanceraidl \
    libnssw \
    libpreprocessingaidl \
    libpresetreverbsw \
    libreverbaidl \
    libspatializersw \
    libvirtualizersw \
    libvisualizeraidl \
    libvolumesw \
    libextensioneffect

PRODUCT_PACKAGES += \
    MtkInCallService

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.microphone.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.microphone.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    $(LOCAL_PATH)/configs/permissions/com.mediatek.hardware.vow.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.mediatek.hardware.vow.xml

$(call soong_config_set_bool,android_hardware_audio,skip_speaker_layout_channel_mask_field,true)

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth-service.mediatek \
    android.hardware.bluetooth.audio@2.0 \
    android.hardware.bluetooth.audio@2.1 \
    libbluetooth_audio_session_aidl

PRODUCT_PACKAGES += \
    android.hardware.bluetooth_le.prebuilt.xml \
    android.hardware.bluetooth.prebuilt.xml

# Boot
PRODUCT_PACKAGES += \
    android.hardware.boot-service.mediatek \
    android.hardware.boot-service.mediatek_recovery \
    android.hardware.boot-V1-ndk \
    android.hardware.boot@1.0 \
    android.hardware.boot@1.1

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.common-V1-ndk \
    android.hardware.camera.common@1.0 \
    android.hardware.camera.device-V3-ndk \
    android.hardware.camera.device@1.0 \
    android.hardware.camera.device@3.2 \
    android.hardware.camera.device@3.3 \
    android.hardware.camera.device@3.4 \
    android.hardware.camera.device@3.5 \
    android.hardware.camera.device@3.6 \
    android.hardware.camera.metadata-V3-ndk \
    android.hardware.camera.provider-V3-ndk \
    android.hardware.camera.provider@2.4 \
    android.hardware.camera.provider@2.5 \
    android.hardware.camera.provider@2.6 \
    libcamera_metadata

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml

# Chipinfo
PRODUCT_PACKAGES += \
    chipinfo

# Common
PRODUCT_PACKAGES += \
    android.hardware.common-V2-ndk \
    android.hardware.common.fmq-V1-ndk

# Contexthub
PRODUCT_PACKAGES += \
    android.hardware.contexthub-service.tinysys \
    chre_atoms_log \
    chremetrics-cpp

# Display
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1600

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V2-ndk \
    android.hardware.graphics.allocator@2.0 \
    android.hardware.graphics.allocator@3.0 \
    android.hardware.graphics.allocator@4.0 \
    android.hardware.graphics.bufferqueue@1.0 \
    android.hardware.graphics.bufferqueue@2.0 \
    android.hardware.graphics.common-V7-ndk \
    android.hardware.graphics.common@1.0 \
    android.hardware.graphics.common@1.1 \
    android.hardware.graphics.common@1.2 \
    android.hardware.graphics.composer3-V3-ndk \
    android.hardware.graphics.mapper@2.0 \
    android.hardware.graphics.mapper@2.1 \
    android.hardware.graphics.mapper@3.0 \
    android.hardware.graphics.mapper@4.0 \
    android.hardware.memtrack-V1-ndk \
    android.hardware.memtrack-service.mediatek \
    libgralloctypes \
    libgrallocusage

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

PRODUCT_PACKAGES += \
    android.hardware.vulkan.compute-0.prebuilt.xml \
    android.hardware.vulkan.level-1.prebuilt.xml \
    android.hardware.vulkan.version-1_3.prebuilt.xml \
    android.software.opengles.deqp.level-2024-03-01.prebuilt.xml \
    android.software.vulkan.deqp.level-2024-03-01.prebuilt.xml

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey \
    android.hardware.drm-V1-ndk \
    libdrm

PRODUCT_VENDOR_LINKER_CONFIG_FRAGMENTS += \
    $(LOCAL_PATH)/configs/linker/linker.config.json

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

PRODUCT_PACKAGES += \
    android.hardware.fastboot-service.example_recovery \
    fastbootd

# External / Runtime Libraries
PRODUCT_PACKAGES += \
    android.frameworks.stats-V1-ndk \
    android.frameworks.stats-V2-ndk \
    android.hardware.gatekeeper-V1-ndk \
    android.hardware.keymaster-V4-ndk \
    android.hardware.renderscript@1.0 \
    android.hardware.secure_element-V1-ndk \
    android.hardware.security.keymint-V1-ndk \
    android.hardware.security.keymint-V3-ndk \
    android.hardware.security.rkp-V3-ndk \
    android.hardware.security.secureclock-V1-ndk \
    android.hardware.security.sharedsecret-V1-ndk \
    android.hardware.soundtrigger3-V1-ndk \
    android.hardware.soundtrigger3-V2-ndk \
    android.hidl.memory.token@1.0 \
    android.hidl.memory@1.0 \
    android.hidl.safe_union@1.0 \
    android.hidl.token@1.0 \
    android.hidl.token@1.0-utils \
    android.media.audio.common.types-V2-ndk \
    android.media.audio.common.types-V3-ndk \
    android.media.soundtrigger.types-V1-ndk \
    android.media.soundtrigger.types-V2-ndk \
    android.system.keystore2-V1-ndk \
    android.system.suspend-V1-ndk \
    dmabuf_dump \
    features_com.android.virt.xml \
    libRSCpuRef \
    libRSDriver \
    libRS_internal \
    libaconfig_storage_read_api_cc \
    libavservices_minijail \
    libbase \
    libbcinfo \
    libbinderdebug \
    libblas \
    libcap \
    libcodec2 \
    libcodec2_aidl \
    libcodec2_hal_common \
    libcodec2_hidl@1.0 \
    libcodec2_hidl@1.1 \
    libcodec2_hidl@1.2 \
    libcodec2_soft_common \
    libcodec2_vndk \
    libcompiler_rt \
    libcrypto \
    libcurl \
    libdmabufheap \
    libdumpstateutil \
    libexif \
    libexpat \
    libflatbuffers-cpp \
    libfmq \
    libhardware \
    libhardware_legacy \
    libhidlbase \
    libhidlmemory \
    libhidltransport \
    libhwbinder \
    libion \
    libjpeg \
    libjsoncpp \
    liblzma \
    libmedia_helper \
    libmediautils_vendor \
    libmeminfo \
    libmemunreachable \
    libminijail \
    libnetutils \
    libnl \
    libpcap \
    libpng \
    libprocessgroup \
    libprocinfo \
    libsfplugin_ccodec_utils \
    libspeexresampler \
    libsqlite \
    libssl \
    libstagefright_aidl_bufferpool2 \
    libstagefright_bufferpool@2.0.1 \
    libstagefright_bufferqueue_helper \
    libstagefright_foundation \
    libsysutils \
    libtinyxml2 \
    libtrusty \
    libui \
    libunwindstack \
    libutils \
    libutilscallstack \
    libvibratorutils \
    libxml2 \
    libz \
    server_configurable_flags

# FM Radio
PRODUCT_PACKAGES += \
    FMRadio

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.common-V3-ndk \
    android.hardware.biometrics.common.thread \
    android.hardware.biometrics.fingerprint-V3-ndk \
    android.hardware.fingerprint.prebuilt.xml

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss-V4-ndk \
    android.hardware.location.gps.prebuilt.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery \
    android.hardware.health-V1-ndk \
    android.hardware.health-V3-ndk

# IR
PRODUCT_PACKAGES += \
    android.hardware.ir-V1-ndk

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

# Keymint
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore_V3.xml

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage \
    android.hardware.light-V1-ndk \
    android.hardware.light-V2-ndk

# Media
PRODUCT_PACKAGES += \
    android.hardware.media.bufferpool2-V2-ndk \
    android.hardware.media.bufferpool@2.0 \
    android.hardware.media.c2-V1-ndk \
    android.hardware.media.c2@1.0 \
    android.hardware.media.c2@1.1 \
    android.hardware.media.c2@1.2 \
    android.hardware.media.omx@1.0 \
    android.hardware.media@1.0

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_codecs_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_c2.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Modules
PRODUCT_PACKAGES += \
    init.insmod.sh

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.nxp \
    android.hardware.nfc-V1-ndk \
    android.hardware.se.omapi.uicc.prebuilt.xml \
    com.android.nfc_extras \
    Tag \
    vendor.nxp.nxpese@1.0 \
    vendor.nxp.nxpnfc_aidl-V1-ndk

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

# Overlays
$(call inherit-product, hardware/mediatek/overlay/mssi.mk)

PRODUCT_PACKAGES += \
    CarrierConfigX6728 \
    FrameworkResOverlayX6728 \
    SystemUIOverlayX6728 \
    WifiResOverlayX6728

PRODUCT_PACKAGES += \
    ApertureOverlayX6728 \
    LineageSettingsOverlayX6728 \
    LineageSystemUIOverlayX6728 \
    NcmTetheringOverlay

# Platform
TARGET_BOARD_PLATFORM := mt6768

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr \
    libaedv \
    libladder \
    libmtkperf_client \
    libmtkperf_client_vendor \
    libperfctl_vendor \
    libpowerhalwrap \
    libpowerhalwrap_vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

PRODUCT_PACKAGES += \
    vendor.mediatek.hardware.mtkpower@1.0.vendor \
    vendor.mediatek.hardware.mtkpower@1.1 \
    vendor.mediatek.hardware.mtkpower@1.2

# Properties
include hardware/mediatek/configs/properties/vendor_logtag.mk

# Radio
ENABLE_VENDOR_RIL_SERVICE := true

$(call inherit-product, vendor/mediatek/ims/ims.mk)
$(call inherit-product, hardware/lineage/compat/frameworks/compat.mk)
$(call inherit-product, hardware/mediatek/frameworks/mediatek-frameworks.mk)

PRODUCT_PACKAGES += \
    android.hardware.radio-V3-ndk \
    android.hardware.radio.config-V3-ndk \
    android.hardware.radio.config@1.1 \
    android.hardware.radio.config@1.2 \
    android.hardware.radio.config@1.3 \
    android.hardware.radio.data-V3-ndk \
    android.hardware.radio.ims-V2-ndk \
    android.hardware.radio.messaging-V3-ndk \
    android.hardware.radio.modem-V3-ndk \
    android.hardware.radio.network-V3-ndk \
    android.hardware.radio.sap-V1-ndk \
    android.hardware.radio.sim-V3-ndk \
    android.hardware.radio.voice-V3-ndk \
    android.hardware.radio@1.0 \
    android.hardware.radio@1.1 \
    android.hardware.radio@1.5 \
    android.hardware.radio@1.6 \
    mdota_symlink

PRODUCT_PACKAGES += \
    android.software.ipsec_tunnels.prebuilt.xml

PRODUCT_PACKAGES += \
    android.hardware.telephony.gsm.prebuilt.xml \
    android.hardware.telephony.ims.prebuilt.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-com.mediatek.telephony.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.mediatek.telephony.xml

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.enableswap \
    fstab.mt6768 \
    fstab.mt6768.vendor_ramdisk \
    init.cgroup.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init.modem.rc \
    init.mt6768.aosp.rc \
    init.mt6768.rc \
    init.mt6768.usb.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.sensor_1_0.rc \
    init_connectivity.rc \
    ueventd.mt6768.rc

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.recovery.mt6768.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt6768.rc

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice-V1-ndk \
    android.frameworks.sensorservice@1.0 \
    android.hardware.sensors-service.multihal \
    android.hardware.sensors-V3-ndk \
    android.hardware.sensors@1.0 \
    android.hardware.sensors@2.0 \
    android.hardware.sensors@2.0-ScopedWakelock \
    android.hardware.sensors@2.0-subhal-impl-1.0 \
    android.hardware.sensors@2.1 \
    sensors.dynamic_sensor_hal

PRODUCT_PACKAGES += \
    android.hardware.sensor.accelerometer.prebuilt.xml \
    android.hardware.sensor.compass.prebuilt.xml \
    android.hardware.sensor.dynamic.head_tracker.prebuilt.xml \
    android.hardware.sensor.gyroscope.prebuilt.xml \
    android.hardware.sensor.light.prebuilt.xml \
    android.hardware.sensor.proximity.prebuilt.xml \
    android.hardware.sensor.stepcounter.prebuilt.xml \
    android.hardware.sensor.stepdetector.prebuilt.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Shims
PRODUCT_PACKAGES += \
    libaudioutils_shim \
    libtinyxml2-v34

# Shipping API Level
BOARD_SHIPPING_API_LEVEL := 202404
PRODUCT_SHIPPING_API_LEVEL := 35

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/interfaces \
    hardware/google/pixel \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/mediatek \
    hardware/mediatek/libmtkperf_client

# SPL
BOOT_SECURITY_PATCH := 2026-09-05
INIT_BOOT_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)
VENDOR_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.mediatek

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

# Touch
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml

PRODUCT_PACKAGES += \
    android.hardware.faketouch.prebuilt.xml

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.mediatek \
    android.hardware.usb-V1-ndk \
    android.hardware.usb.gadget-service.mediatek \
    android.hardware.usb.gadget-V1-ndk

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

$(call soong_config_set_bool,android_hardware_mediatek_usb,audio_accessory_supported,true)

# Verified Boot
PRODUCT_PACKAGES += \
    android.software.verified_boot.prebuilt.xml

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.mediatek \
    android.hardware.vibrator-V2-ndk

# VNDK
PRODUCT_PACKAGES += \
    vndservicemanager

# Wi-Fi
$(call soong_config_set_bool,mediatek_wifi_hal,use_pre_baklava_qpr0_struct,true)

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    libkeystore-engine-wifi-hidl \
    libkeystore-wifi-hidl \
    libwifi-hal-wrapper \
    wlan_assistant \
    wpa_supplicant

PRODUCT_PACKAGES += \
    android.hardware.wifi.direct.prebuilt.xml \
    android.hardware.wifi.passpoint.prebuilt.xml \
    android.hardware.wifi.prebuilt.xml

# Inherit the proprietary files
$(call inherit-product, vendor/infinix/X6728/X6728-vendor.mk)
