#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

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

module = ExtractUtilsModule(
    'X6728',
    'infinix',
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
