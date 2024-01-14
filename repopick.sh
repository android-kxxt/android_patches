#!/bin/bash

set -e
source "build/envsetup.sh";
source "vendor/lineage/build/envsetup.sh";

# frameworks/av
changes=(
351261 # SessionConfigurationUtils: Allow privileged camera apps to create raw streams for raw capable cameras

342860 # codec2: Use numClientBuffers to control the pipeline
342861 # CCodec: Control the inputs to avoid pipeline overflow
342862 # [WA] Codec2: queue a empty work to HAL to wake up allocation thread
342863 # CCodec: Use pipelineRoom only for HW decoder
342864 # codec2: Change a Info print into Verbose
)
repopick -P frameworks/av ${changes[@]}&

# frameworks/base
changes=(
351262 # Camera: Expose aux camera if packagename is null

#334343 # Alter model name to avoid SafetyNet HW attestation enforcement
#334344 # keystore: Block key attestation for SafetyNet
#349090 # AttestationHooks: Set shipping level to 32 for devices >=33
#353215 # Limit SafetyNet workarounds to unstable GMS process
#353216 # gmscompat: Apply the SafetyNet workaround to Play Store aswell
#353217 # gmscompat: Use Nexus 6P fingerprint for CTS/Integrity
#353218 # gmscompat: Make CTS/Play Integrity pass again
#373862 # gmscompat: Switch to asus X00HD fingeprint
)
#357510 # gmscompat: also spoof props for samsung/sec apps
#361101 # gmscompat: Use Pixel 2 fingerprint for CTS/Integrity
#365854 # gmscompat: Spoof user/release-keys build
repopick -f -P frameworks/base ${changes[@]}&

# frameworks/opt/telephony
changes=(
349338 # Disable proguard for CellularNetworkServiceProvider
349339 # Add provision to override CellularNetworkService
349340 # Make a few  members of DSM overridable and accessible
349341 # Reset data activity after traffic status poll stops
349342 # Start using inject framework support
349343 # Skip sending duplicate requests
349344 # Enable vendor Telephony plugin: MSIM Changes
)
repopick -P frameworks/opt/telephony ${changes[@]}&

# hardware/xiaomi
changes=(
352657 # Add dummy sensors sub HAL
352658 # sensors: Make sensor batch function virtual
352659 # sensors: Make sensor run function virtual
352660 # sensors: Make sensor flush function virtual
352661 # sensors: Make sensor set mode operation function virtual
352662 # sensors: Move one shot sensor out of main class
352663 # sensors: Fix locking around setOperationMode and activate
352664 # sensors: Add udfps long press sensor
352665 # sensors: Handle fod_pressed_state without coordinates
372459 # Import qti vibrator effect and rename
356442 # vibrator: effect: Read vibration fifo data from vendor
)
#356436 # vibrator: Import from LA.VENDOR.13.2.0.r1-15400-KAILUA.QSSI14.0
#356437 # vibrator: Rename to avoid conflicts
#356438 # vibrator: aidl: Simplify soc check and drop prop dep
#356439 # vibrator: Add support for aw8624_haptic input device
#356440 # vibrator: Add support for aw8697_haptic input device
#356441 # vibrator: Hook USE_EFFECT_STREAM up
#356442 # vibrator: effect: Read vibration fifo data from vendor
#356482 # vibrator: Don't support compose effects if primitve_duration node does not exist
repopick -P hardware/xiaomi ${changes[@]}&

# vendor/lineage
changes=(
367044 # android: merge_dtbs: Respect miboard-id while merging
)
repopick -P vendor/lineage ${changes[@]}&

wait
