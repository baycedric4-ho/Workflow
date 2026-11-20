#!/bin/sh -e

# SPDX-FileCopyrightText: Copyright 2025 Eden Emulator Project
# SPDX-License-Identifier: GPL-3.0-or-later

sudo apt-get update -y
sudo apt-get install apksigner glslang-tools libvulkan-dev python3-requests -y

SDKMANAGER="${ANDROID_HOME:-$ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager"
if [ -x "$SDKMANAGER" ]; then
    yes | "$SDKMANAGER" --licenses >/dev/null || true
    "$SDKMANAGER" "cmake;3.31.6" "ndk;30.0.16248370"
fi
