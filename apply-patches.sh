#!/bin/bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/lib/message.sh"
colorize
# Patches the Android source tree recursively with the patches folder.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$1" ]; then
    error "No subdir provided!"
    exit 1
fi
SUBDIR="$1"

if [ -n "$ANDROID_BUILD_TOP" ]; then
    TOP="$ANDROID_BUILD_TOP"
else
    TOP="$(realpath "$SCRIPT_DIR/../")"
fi

# Apply patches
msg "AOSP source tree: $TOP"
msg "Applying patches..."

# Apply the patch using git-am, 
# fallback to 3-way am if direct am fails.
# If 3-way am succeeded, notify user by issuing a warning.
function git_am() {
    if [[ $# -ne 2 ]]; then
        error ""
    fi
    local workdir="$1"
    local patch="$2"
    if ! git -C "$TOP/$dir" am < "$patch"; then
        msg2 "Direct am failed. Falling back to 3-way merge"
        git -C "$TOP/$dir" am --abort || true
        if git -C "$TOP/$dir" am -3 < "$patch"; then
            warning "3-way merge succeeded. Please review and refresh $patch"
        else
            error "3-way merge failed! Please manually resolve the conflict in $TOP/$dir"
            exit 2
        fi
    fi
}

find "$SCRIPT_DIR/$SUBDIR" -type f -name "*.patch" | while read patch; do
    relative="$(realpath --relative-to="$SCRIPT_DIR/$SUBDIR" "$patch")"
    dir="$(dirname "$relative")"
    msg "Applying $relative to $dir"
    output="$(patch -Np1 -d "$TOP/$dir" --dry-run < "$patch" || true)"
    if ! grep -q "hunks\? FAILED" <<< "$output"; then
        # no hunk FAILED
        if grep -q "hunks\? ignored" <<< "$output"; then
            # some or all hunks are ignored
            warning "Some/All hunks are ignored when trying to applying $relative, skipping this patch"
        else
            git_am "$TOP/$dir" "$patch"
        fi
    else
        # Some hunks failed
        error "failed to apply $patch!"
        echo "$output"
    fi
done
