#!/bin/bash

set -e

source /usr/share/makepkg/util/message.sh
colorize
# Patches the Android source tree recursively with the patches folder.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SUBDIR=20
if [ -n "$ANDROID_BUILD_TOP" ]; then
    TOP="$ANDROID_BUILD_TOP"
else
    TOP="$(realpath "$SCRIPT_DIR/../")"
fi

# Apply patches
msg "AOSP source tree: $TOP"
msg "Applying patches..."

find "$SCRIPT_DIR/$SUBDIR" -type f -name "*.patch" | while read patch; do
    relative="$(realpath --relative-to="$SCRIPT_DIR/$SUBDIR" "$patch")"
    dir="$(dirname "$relative")"
    msg "Applying $relative to $dir"
    output="$(patch -Np1 -d "$TOP/$dir" --dry-run < "$patch" || true)"
    if ! grep -q "hunks\? FAILED" <<< "$output"; then
        # no hunk FAILED
        if grep -q "hunks\? ignored" <<< "$output"; then
            # some or all hunks are ignored
            warning "Some/All hunks are ignored when trying to applying $relative, skiping this patch"
        else
            git -C "$TOP/$dir" am < "$patch"
        fi
    else
        # Some hunks failed
        error "failed to apply $patch!"
        echo "$output"
    fi
done
