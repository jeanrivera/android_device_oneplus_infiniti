#! /vendor/bin/sh
#==============================================================================
#       init.qti.media.sh
#
# Copyright (c) 2020-2022, Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2020, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#===============================================================================

# when module load check is removed in few Makena SPs, the loading of modules
# and running of the script are in async, due to this the soc id may not be
# populated while the script is run and soc_hwid is set to NULL. To resolve this
# issue, wait for a reasonable amount of time to avoid infinite wait case, and
# make sure soc_hwid is not null and the correct value is assigned.
max_retry=25
while [ $max_retry -gt 0 ]
do
    if [ -f /sys/devices/soc0/soc_id ]; then
        soc_hwid=`cat /sys/devices/soc0/soc_id` 2> /dev/null
    else
        soc_hwid=`cat /sys/devices/system/soc/soc0/id` 2> /dev/null
    fi
    if [ $soc_hwid -eq $null ]
    then
        ((max_retry--))
        usleep 10000
    else
        break
    fi
done
build_codename=`getprop vendor.media.system.build_codename`

target=`getprop ro.board.platform`
case "$target" in
    "niobe")
        setprop vendor.mm.target.enable.qcom_parser 0
        setprop vendor.media.target_variant "_niobe"
        ;;
    "anorak")
        setprop vendor.mm.target.enable.qcom_parser 0
        setprop vendor.media.target_variant "_anorak"
        ;;
    "kalama")
        setprop vendor.mm.target.enable.qcom_parser 0
        setprop vendor.media.target_variant "_kalama"
        ;;
    "pineapple")
        setprop vendor.mm.target.enable.qcom_parser 0
        setprop vendor.media.target_variant "_pineapple"
        ;;
    "sun")
        setprop vendor.mm.target.enable.qcom_parser 0
        setprop vendor.media.target_variant "_sun"
        if [ $build_codename -le "15" ]; then
            setprop vendor.netflix.bsp_rev "Q8750-39568-1"
        fi
        ;;
    "canoe")
        setprop vendor.mm.target.enable.qcom_parser 0
        if [ $build_codename -le "16" ]; then
            setprop vendor.netflix.bsp_rev "Q8850-41474-1"
        fi
        case "$soc_hwid" in
            660|661|704)
                hw_version=`cat /sys/devices/soc0/revision` 2> /dev/null
                case "$hw_version" in
                    "1.0")
                        setprop vendor.media.target_variant "_canoe_v1"
                        setprop vendor.netflix.bsp_rev 0
                        ;;
                    *)
                        setprop vendor.media.target_variant "_canoe_v2"
                        ;;
                esac
                sku_ver=`cat /sys/devices/platform/soc/2000000.qcom,vidc/sku_version` 2> /dev/null
                if [ $sku_ver -eq 1 ]; then
                    setprop vendor.media.target_variant "_canoe_sku1"
                fi
                if [ $sku_ver -eq 2 ]; then
                    setprop vendor.media.target_variant "_canoe_sku2"
                fi
                if [ $sku_ver -eq 3 ]; then
                    setprop vendor.media.target_variant "_canoe_sku3"
                fi
                ;;
            685|727)
                setprop vendor.media.target_variant "_canoe_sku3"
                ;;
            *)
                setprop vendor.media.target_variant "_canoe_v2"
                ;;
        esac
        ;;
    "seraph")
        setprop vendor.mm.target.enable.qcom_parser 0
        setprop vendor.media.target_variant "_seraph"
        ;;
    "taro")
        setprop vendor.mm.target.enable.qcom_parser 1040479
        case "$soc_hwid" in
            530|531|540)
                setprop vendor.media.target_variant "_cape"
                ;;
            *)
                setprop vendor.media.target_variant "_taro"
                ;;
        esac
        ;;
    "lahaina")
        case "$soc_hwid" in
            450)
                setprop vendor.media.target_variant "_shima_v3"
                setprop vendor.netflix.bsp_rev ""
                sku_ver=`cat /sys/devices/platform/soc/aa00000.qcom,vidc/sku_version` 2> /dev/null
                if [ $sku_ver -eq 1 ]; then
                    setprop vendor.media.target_variant "_shima_v1"
                elif [ $sku_ver -eq 2 ]; then
                    setprop vendor.media.target_variant "_shima_v2"
                fi
                ;;
            *)
                setprop vendor.media.target_variant "_lahaina"
                setprop vendor.netflix.bsp_rev "Q875-32408-1"
                ;;
        esac
        ;;
    "holi")
        setprop vendor.media.target_variant "_holi"
        ;;
    "msmnile")
        setprop vendor.media.target_variant "_lemans"
        case "$soc_hwid" in
            532)
                setprop vendor.media.target_variant "_lemans"
                ;;
        esac
        ;;
    "gen4")
        setprop vendor.media.target_variant "_lemans"
        case "$soc_hwid" in
            532)
                setprop vendor.media.target_variant "_lemans"
                ;;
        esac
        ;;
    "gen5")
        setprop vendor.media.target_variant "_nordau"
        ;;
esac
