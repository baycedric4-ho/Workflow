#!/sh -e

# S'auto-attribuer les permissions d'exécution si nécessaire
if [ ! -x "$0" ]; then
    chmod +x "$0"
fi

# SPDX-FileCopyrightText: Copyright 2025 Eden Emulator Project
# SPDX-License-Identifier: GPL-3.0-or-later

sudo apt-get update -y
sudo apt-get install apksigner glslang-tools libvulkan-dev python3-requests -y
