#!/bin/bash
set -e

source "build/envsetup.sh";
source "vendor/lineage/build/envsetup.sh";

# device/qcom/sepolicy_vndr/sm8450
changes=(
383884 # sepolicy_vndr: update sepolicy for health HAL service
)
repopick -P device/qcom/sepolicy_vndr/sm8450 ${changes[@]}&

# hardware/xiaomi
changes=(
385354 # vintf: Add fingerprint extension to common fcm
385355 # vintf: Add fpc and goodix 1.0 extensions to fcm
352657 # Add dummy sensors sub HAL
352658 # sensors: Make sensor batch function virtual
352659 # sensors: Make sensor run function virtual
352660 # sensors: Make sensor flush function virtual
352661 # sensors: Make sensor set mode operation function virtual
352662 # sensors: Move one shot sensor out of main class
352663 # sensors: Fix locking around setOperationMode and activate
352664 # sensors: Add udfps long press sensor
352665 # sensors: Handle fod_pressed_state without coordinates
)
repopick -P hardware/xiaomi ${changes[@]}&

# vendor/lineage
changes=(
367044 # android: merge_dtbs: Respect miboard-id while merging
)
repopick -P vendor/lineage ${changes[@]}&

repopick -P frameworks/base -f -t 21-snet

wait

cd hardware/qcom-caf/sm8450/display
git pull https://github.com/LineageOS/android_hardware_qcom_display refs/changes/99/384299/1
cd ../../../../
