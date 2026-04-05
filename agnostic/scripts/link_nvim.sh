#!/bin/bash

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

rm "$REPO_ROOT/linux/home/.config/nvim/init.lua" "$REPO_ROOT/linux/home/.config/nvim/colors/citra.lua"
rm "$REPO_ROOT/macos/home/.config/nvim/init.lua" "$REPO_ROOT/macos/home/.config/nvim/colors/citra.lua"

ln "$REPO_ROOT/agnostic/nvim/init.lua" "$REPO_ROOT/linux/home/.config/nvim/init.lua"
ln "$REPO_ROOT/agnostic/nvim/colors/citra.lua" "$REPO_ROOT/linux/home/.config/nvim/colors/citra.lua"
ln "$REPO_ROOT/agnostic/nvim/init.lua" "$REPO_ROOT/macos/home/.config/nvim/init.lua"
ln "$REPO_ROOT/agnostic/nvim/colors/citra.lua" "$REPO_ROOT/macos/home/.config/nvim/colors/citra.lua"
