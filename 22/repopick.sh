#!/bin/bash
set -e

source "build/envsetup.sh";
source "vendor/lineage/build/envsetup.sh";

# hardware/xiaomi
changes=(
352657 # Add dummy sensors sub HAL
352658 # sensors: Make sensor batch function virtual
352659 # sensors: Make sensor run function virtual
352660 # sensors: Make sensor flush function virtual
352661 # sensors: Make sensor set mode operation function virtual
352662 # sensors: Move one shot sensor out of main class
352663 # sensors: Fix locking around setOperationMode and activate
352664 # sensors: Create sysfs polling one shot sensor
392967 # sensors: Let the reading of poll fd be configurable
392968 # sensors: Add SysfsPollingOneShotSensor constructor without enable path
392969 # sensors: Add udfps long press sensor using SysfsPollingOneShotSensor
352665 # sensors: Handle fod_pressed_state without coordinates
363160 # hidl: biometrics: fingerprint: Add enroll methods to udfps handler
392965 # vibrator: effect: Create double click effect from click if necessary
392966 # vibrator: effect: Fallback to click if an effect is missing
)
repopick -P hardware/xiaomi ${changes[@]}&

# frameworks/base
changes=(
386158 # Add 5G Ultra Wideband icon carrier config keys
386159 # Fix default values for 5G Ultra Wideband icon carrier config keys
)
repopick -P frameworks/base ${changes[@]}&

# vendor/lineage
changes=(
367044 # android: merge_dtbs: Respect miboard-id while merging
)
repopick -P vendor/lineage ${changes[@]}&

wait

