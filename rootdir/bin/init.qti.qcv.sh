#! /vendor/bin/sh
#=============================================================================
# Copyright (c) 2020, 2021 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

soc_id=`cat /sys/devices/soc0/soc_id` 2> /dev/null
chip_id=`cat /sys/devices/soc0/chip_id` 2> /dev/null

# Store soc_id in ro.vendor.qti.soc_id
setprop ro.vendor.qti.soc_id $soc_id

# Store chip_id in ro.vendor.qti.soc_model
setprop ro.vendor.qti.soc_model $chip_id

# For chipsets in QCV family, convert soc_id to soc_name
# and store it in ro.vendor.qti.soc_name.
if [ "$soc_id" -eq 707 ] || [ "$soc_id" -eq 708 ] ; then
    setprop ro.vendor.qti.soc_name art
elif [ "$soc_id" -eq 660 ] || [ "$soc_id" -eq 661 ] || [ "$soc_id" -eq 704 ]; then
    setprop ro.vendor.qti.soc_name canoe
    setprop ro.vendor.media_performance_class 35
elif [ "$soc_id" -eq 685 ] || [ "$soc_id" -eq 727 ]; then
    setprop ro.vendor.qti.soc_name alor
    setprop ro.vendor.media_performance_class 35
elif [ "$soc_id" -eq 618 ] || [ "$soc_id" -eq 639 ]; then
    setprop ro.vendor.qti.soc_name sun
    setprop ro.vendor.media_performance_class 35
elif [ "$soc_id" -eq 557 ] || [ "$soc_id" -eq 577 ]; then
    setprop ro.vendor.qti.soc_name pineapple
    setprop ro.vendor.media_performance_class 34
elif [ "$soc_id" -eq 475 ] || [ "$soc_id" -eq 499 ] ||
     [ "$soc_id" -eq 497 ] || [ "$soc_id" -eq 498 ] ||
     [ "$soc_id" -eq 515 ]; then
    setprop ro.vendor.qti.soc_name yupik
    setprop ro.vendor.qti.soc_model SM7325
elif [ "$soc_id" -eq 575 ]; then
    setprop ro.vendor.qti.soc_name yupik
    setprop ro.vendor.qti.soc_model QCS5430
elif [ "$soc_id" -eq 576 ]; then
    setprop ro.vendor.qti.soc_name yupik
    setprop ro.vendor.qti.soc_model QCM5430
fi
