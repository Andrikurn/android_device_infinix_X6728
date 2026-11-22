#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import struct

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
]


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


def clear_symbol_versions_by_type(
    ctx,
    file,
    file_path: str,
    symbols: tuple[str, ...],
    *args,
    **kwargs,
):
    SHT_DYNSYM = 11
    SHT_GNU_VERSYM = 0x6FFFFFFF
    VER_NDX_GLOBAL = 1

    with open(file_path, 'r+b') as f:
        data = bytearray(f.read())
        if data[:5] != b'\x7fELF\x02':
            raise RuntimeError(f'{file_path}: not a 64-bit ELF')

        e_shoff = struct.unpack_from('<Q', data, 40)[0]
        e_shentsize, e_shnum = struct.unpack_from('<HH', data, 58)

        shdrs = []
        for i in range(e_shnum):
            off = e_shoff + i * e_shentsize
            sh_type = struct.unpack_from('<I', data, off + 4)[0]
            sh_offset, sh_size = struct.unpack_from('<QQ', data, off + 24)
            sh_link = struct.unpack_from('<I', data, off + 40)[0]
            sh_entsize = struct.unpack_from('<Q', data, off + 56)[0]
            shdrs.append((sh_type, sh_offset, sh_size, sh_link, sh_entsize))

        dynsym = next(s for s in shdrs if s[0] == SHT_DYNSYM)
        versym = next(s for s in shdrs if s[0] == SHT_GNU_VERSYM)
        dynstr = shdrs[dynsym[3]]

        sym_off, sym_sz, sym_ent = dynsym[1], dynsym[2], dynsym[4]
        str_off, str_sz = dynstr[1], dynstr[2]
        ver_off = versym[1]

        targets = set(symbols)
        cleared = set()
        for idx in range(sym_sz // sym_ent):
            st_name = struct.unpack_from('<I', data, sym_off + idx * sym_ent)[0]
            name_end = data.find(b'\x00', str_off + st_name, str_off + str_sz)
            name = data[str_off + st_name : name_end].decode('ascii', 'ignore')
            if name in targets:
                struct.pack_into('<H', data, ver_off + idx * 2, VER_NDX_GLOBAL)
                cleared.add(name)

        missing = targets - cleared
        if missing:
            raise RuntimeError(f'{file_path}: symbols not found: {sorted(missing)}')

        f.seek(0)
        f.write(data)


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'vendor.mediatek.hardware.videotelephony-V1-ndk',
    ): lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    'system_ext/bin/hw/android.hardware.audio.parameter_parser.service': blob_fixup()
        .replace_needed('av-audio-types-aidl-V1-ndk.so', 'av-audio-types-aidl-V3-ndk.so'),
    'system_ext/lib64/libimsma.so': blob_fixup()
        .replace_needed('libsink.so', 'libsink-mtk.so'),
    'system_ext/priv-app/ImsService/ImsService.apk': blob_fixup()
        .apktool_patch('blob-patches/ImsService'),
    (
        'vendor/bin/hw/android.hardware.audio.service-aidl.mediatek',
        'vendor/lib64/hw/android.hardware.soundtrigger3-impl.so',
    ): blob_fixup()
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),
    'vendor/bin/hw/camerahalserver': blob_fixup()
        .remove_needed('libudf.so'),
    'vendor/etc/init/tee.rc': blob_fixup()
        .regex_replace(r'(?s)\s*#USD: add \[paytrigger\].*?#USD: add \[paytrigger\][^\n]*\n', '\n')
        .regex_replace(r'(?s)\s*#USD:Create startPara.*?#USD:Create startPara[^\n]*\n', '\n'),
    'vendor/lib64/android.hardware.audio.core-impl-mediatek.so': blob_fixup()
        .add_needed('libaudioutils_shim.so')
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),
    (
        'vendor/bin/mnld',
        'vendor/lib64/libaalservice.so',
        'vendor/lib64/libcam.utils.sensorprovider.so',
    ): blob_fixup()
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V3-ndk.so'),
    (
        'vendor/bin/hw/android.hardware.graphics.allocator-V2-service-mediatek',
        'vendor/lib64/egl/libGLES_mali.so',
        'vendor/lib64/hw/android.hardware.graphics.allocator-V2-mediatek.so',
        'vendor/lib64/hw/mapper.mediatek.so',
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
        'vendor/lib64/hw/android.hardware.audio.effect.aidl-impl-mediatek.so',
        'vendor/lib64/hw/hwcomposer.mt6768.so',
        'vendor/lib64/hw/vendor.mediatek.hardware.pq_aidl-impl.so',
        'vendor/lib64/libpqxmlparser.so',
        'vendor/lib64/librt_extamp_intf.so',
        'vendor/lib64/libsilkybrightnesscore.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    'vendor/lib64/hw/audio.primary.mt6768.so': blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so')
        .binary_regex_replace(b'A2dpsuspendonly', b'A2dpSuspended\x00\x00')
        .binary_regex_replace(b'BTAudiosuspend', b'A2dpSuspended\x00'),
    'vendor/lib64/libmtkcam_hal_aidl_common.so': blob_fixup()
        .replace_needed('android.hardware.camera.common-V2-ndk.so', 'android.hardware.camera.common-V1-ndk.so'),
    'vendor/lib64/libtranssion_bodybeauty.so': blob_fixup()
        .call(
            clear_symbol_versions_by_type,
            (
                'AHardwareBuffer_allocate',
                'AHardwareBuffer_describe',
                'AHardwareBuffer_lockPlanes',
                'AHardwareBuffer_release',
                'AHardwareBuffer_unlock',
            ),
            need_tmp_dir=False,
        ),
    'vendor/lib64/libutinterface_custom_md.so': blob_fixup()
        .add_needed('libutinterface_md.so'),
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
