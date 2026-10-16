#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/infinix/X6728',
    'hardware/mediatek',
    'hardware/mediatek/libmtkperf_client',
    'hardware/mediatek/libaedv',
    'hardware/mediatek/libion_mtk',
    'hardware/millennium',
    'hardware/millennium/libtranlog',
    'vendor/mediatek/ims',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

def lib_fixup_formatter(lib: str, *args, **kwargs):
    # AOSP ships a host-only Rust module named libformatter, which disables our
    # prebuilt of the same name. Ships as libformatter.so via the stem.
    return 'libformatter_mtk'

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'libtflite_mtk',
        'libneuron_graph_delegate.mtk',
        'vendor.mediatek.hardware.apuware.apusys@2.0',
        'vendor.mediatek.hardware.apuware.apusys@2.1',
        'vendor.mediatek.hardware.apuware.hmp@1.0',
        'vendor.mediatek.hardware.apuware.utils@2.0',
    ): lib_fixup_vendor_suffix,
    'libformatter': lib_fixup_formatter,
}

blob_fixups: blob_fixups_user_type = {
    'vendor/lib64/hw/hwcomposer.mt6768.so': blob_fixup()
        .patchelf_version('0_17_2')
        .add_needed('libprocessgroup_shim.so'),
    'vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so': blob_fixup()
        .add_needed('libcamera_metadata_shim.so'),
    (
        'vendor/bin/mnld',
        'vendor/lib64/libaalservice.so',
    ): blob_fixup()
        .replace_needed('libsensorndkbridge.so', 'android.hardware.sensors@1.0-convert-shared.so'),
    # None of these reference the sensors AIDL symbols they link, and the
    # platform's sensorservice stub reexports v3, so a module graph with both
    # versions of the interface fails to build.
    (
        'vendor/bin/mnld',
        'vendor/lib64/libaalservice.so',
        'vendor/lib64/libcam.utils.sensorprovider.so',
    ): blob_fixup()
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V3-ndk.so'),
    # MTK links the development version of camera.common, which a release
    # branch build refuses to use. It references no symbol from it, and the
    # platform already puts the frozen v1 in the module graph through
    # camera.device v3.
    'vendor/lib64/libmtkcam_hal_aidl_common.so': blob_fixup()
        .replace_needed('android.hardware.camera.common-V2-ndk.so', 'android.hardware.camera.common-V1-ndk.so'),
    # The platform's graphics stubs reexport common v7 and its bluetooth audio
    # session library reexports audio v6, so a module graph holding the older
    # version next to them fails to build. Same fix as the official MTK and
    # Qualcomm trees on this branch.
    (
        'vendor/bin/hw/android.hardware.graphics.allocator-V2-service-mediatek',
        'vendor/lib64/hw/android.hardware.graphics.allocator-V2-mediatek.so',
        'vendor/lib64/hw/mapper.mediatek.so',
        'vendor/lib64/egl/libGLES_mali.so',
        'vendor/lib64/libaimemc.so',
        'vendor/lib64/libcodec2_fsr.so',
        'vendor/lib64/libgpud.so',
        'vendor/lib64/libmtkcam_grallocutils.so',
        'vendor/lib64/vendor.mediatek.hardware.camera.isphal-V1-ndk.so',
        'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V2-ndk.so',
        'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V4-ndk.so',
        'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V8-ndk.so',
    ): blob_fixup()
        .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
    (
        'vendor/bin/hw/android.hardware.audio.service-aidl.mediatek',
        'vendor/lib64/android.hardware.audio.core-impl-mediatek.so',
        'vendor/lib64/android.hardware.bluetooth.audio-impl-mediatek.so',
        'vendor/lib64/hw/audio.bluetooth.default.so',
        'vendor/lib64/hw/vendor.mediatek.hardware.bluetooth.audio@2.1-impl.so',
        'vendor/lib64/hw/vendor.mediatek.hardware.bluetooth.audio@2.2-impl.so',
        'vendor/lib64/libbluetooth_audio_session_aidl_mtk.so',
        'vendor/lib64/libpowerhal.so',
    ): blob_fixup()
        .replace_needed('android.hardware.bluetooth.audio-V4-ndk.so', 'android.hardware.bluetooth.audio-V6-ndk.so'),
    # The vendor audio blobs were built against the platform's aidl conversion
    # library from an older branch, which the current platform replaces with a
    # version reexporting audio.common.types v5. Their soundtrigger3 v2 import
    # chain pins types v3, so the two versions meet in one module graph and the
    # build refuses it. Ship the stock library under a private name instead, as
    # the official MTK trees on this branch do.
    (
        'vendor/bin/hw/android.hardware.audio.service-aidl.mediatek',
        'vendor/lib64/android.hardware.audio.core-impl-mediatek.so',
        'vendor/lib64/hw/android.hardware.soundtrigger3-impl.so',
    ): blob_fixup()
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),
    (
        'vendor/lib64/libnvram.so',
        'vendor/lib64/libsysenv.so',
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'X6728',
    'infinix',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
