#!/bin/bash
set -e

source "build/envsetup.sh";
source "vendor/lineage/build/envsetup.sh";

# vendor/lineage
changes=(
367044 # android: merge_dtbs: Respect miboard-id while merging
)
repopick -P vendor/lineage ${changes[@]}&

wait

