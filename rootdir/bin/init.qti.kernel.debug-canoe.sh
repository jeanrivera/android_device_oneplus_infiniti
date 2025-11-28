#=============================================================================
#  Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
#  All rights reserved.
#  Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

create_instance()
{
    local instance_dir=$1
    if [ ! -d $instance_dir ]; then
        mkdir $instance_dir
    fi
}

enable_rproc_events()
{
    if [ "$debug_build" = false ]; then
        return
    fi

    local instance=/sys/kernel/tracing/instances/rproc_qcom
    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    if [ -d $instance/events/rproc_qcom ]; then
      echo 1 > $instance/events/rproc_qcom/enable
      echo 1 > $instance/tracing_on
    fi
}

enable_fastrpc_events()
{
    if [ "$debug_build" = false ]; then
        return
    fi

    local instance=/sys/kernel/tracing/instances/fastrpc
    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    if [ -d $instance/events/fastrpc ]; then
      echo 1 > $instance/events/fastrpc/enable
      echo 1 > $instance/tracing_on
    fi
}

enable_extra_ftrace_events()
{
    if [ "$debug_build" = false ]; then
        return
    fi

    local instance=/sys/kernel/tracing/instances/main
    create_instance $instance
    echo 1 > $instance/tracing_on

    # turn on global trace for trace_prink
    echo 1 > /sys/kernel/tracing/tracing_on
}

# function to disable SF tracing on perf config
sf_tracing_disablement()
{
    if [ "$debug_build" = false ]; then
        setprop debug.sf.enable_transaction_tracing 0
    fi
}

enable_buses_and_interconnect_tracefs_debug()
{
    tracefs=/sys/kernel/tracing

    # enable tracing for consolidate/debug builds, where debug_build is set true
    if [ "$debug_build" = true ]; then
        setprop persist.vendor.tracing.enabled 1
    fi

    if [ -d $tracefs ] && [ "$(getprop persist.vendor.tracing.enabled)" -eq "1" ]; then
        create_instance $tracefs/instances/hsuart
        #UART
        echo 800 > $tracefs/instances/hsuart/buffer_size_kb
        echo 1 > $tracefs/instances/hsuart/events/serial/enable
        echo 1 > $tracefs/instances/hsuart/tracing_on

        #SPI
        create_instance $tracefs/instances/spi_qup
        echo 20 > $tracefs/instances/spi_qup/buffer_size_kb
        echo 1 > $tracefs/instances/spi_qup/events/qup_spi_trace/enable
        echo 1 > $tracefs/instances/spi_qup/tracing_on

        #Q2SPI
        create_instance $tracefs/instances/q2spi
        echo 800 > $tracefs/instances/q2spi/buffer_size_kb
        echo 1 > $tracefs/instances/q2spi/events/q2spi_trace/enable
        echo 1 > $tracefs/instances/q2spi/tracing_on

        #I2C
        create_instance $tracefs/instances/i2c_qup
        echo 20 > $tracefs/instances/i2c_qup/buffer_size_kb
        echo 1 > $tracefs/instances/i2c_qup/events/qup_i2c_trace/enable
        echo 1 > $tracefs/instances/i2c_qup/tracing_on

        #I3C
        create_instance $tracefs/instances/i3c_qup
        echo 20 > $tracefs/instances/i3c_qup/buffer_size_kb
        echo 1 > $tracefs/instances/i3c_qup/events/qup_i3c_trace/enable
        echo 1 > $tracefs/instances/i3c_qup/tracing_on

        #SLIMBUS
        create_instance $tracefs/instances/slimbus
        echo 1 > $tracefs/instances/slimbus/events/slimbus/slimbus_dbg/enable
        echo 1 > $tracefs/instances/slimbus/tracing_on
    fi
}

config_dcc_timer()
{
    echo 0x16801000 2 > $DCC_PATH/config
}

enable_dcc()
{
    DCC_PATH="/sys/bus/platform/devices/100ff000.dcc"
    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo 1 > $DCC_PATH/config_reset
    echo 4 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 1 > $DCC_PATH/ap_ns_qad_override_en
    config_dcc_timer

    echo  1 > $DCC_PATH/enable
}

enable_cpuss_register()
{
    if [ ! -d /sys/kernel/debug/dynamic_mem_dump/cpuss_reg ]; then
        return
    fi

    cpuss_enable = `cat /sys/kernel/debug/dynamic_mem_dump/cpuss_reg/enable`
    if [ "$cpuss_enable" != "1"]; then
        return
    fi

    echo 1 > /sys/bus/platform/devices/soc:mem_dump/register_reset
}

cpuss_spr_setup()
{
    if [ ! -d /sys/kernel/debug/dynamic_mem_dump/spr ]; then
        return
    fi

    spr_enable = `cat /sys/kernel/debug/dynamic_mem_dump/spr/enable`
    if [ "$spr_enable" != "1"]; then
        return
    fi

    echo 1 > /sys/bus/platform/devices/soc:mem_dump/sprs_register_reset
}

init_dynamic_mem_dump()
{
    if [ "$debug_build" != true ]
    then
        return
    fi

    if [ ! -d "/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump" ]
    then
        return
    fi

    echo cluster_cache >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
    echo cpu_cache >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
    echo cpucp >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
    echo cpuss_cluster >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
    echo cpuss_cpu >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
    echo spr >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
    echo cpuss_reg >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
    echo scandump_gpu >/sys/bus/platform/devices/soc:mem_dump/dynamic_mem_dump/enable
}

create_stp_policy()
{
    create_instance /config/stp-policy/stm0:p_ost.policy
    chmod 660 /config/stp-policy/stm0:p_ost.policy
    create_instance /config/stp-policy/stm0:p_ost.policy/default
    chmod 660 /config/stp-policy/stm0:p_ost.policy/default
    echo ftrace > /config/stp-policy/stm0:p_ost.policy/default/entity
}

adjust_permission()
{
    #add permission for block_size, mem_type, mem_size nodes to collect diag over QDSS by ODL
    #application by "oem_2902" group
    chown -h root.oem_2902 /sys/devices/platform/soc/10048000.tmc/tmc_etr0/block_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/tmc_etr0/block_size
    chown -h root.oem_2902 /sys/devices/platform/soc/10048000.tmc/tmc_etr0/buffer_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/tmc_etr0/buffer_size
    chmod 660 /sys/devices/platform/soc/10048000.tmc/tmc_etr0/out_mode
    chown -h root.oem_2902 /sys/devices/platform/soc/1004f000.tmc/tmc_etr1/block_size
    chmod 660 /sys/devices/platform/soc/1004f000.tmc/tmc_etr1/block_size
    chown -h root.oem_2902 /sys/devices/platform/soc/1004f000.tmc/tmc_etr1/buffer_size
    chmod 660 /sys/devices/platform/soc/1004f000.tmc/tmc_etr1/buffer_size
    chmod 660 /sys/devices/platform/soc/1004f000.tmc/tmc_etr1/out_mode

    chgrp shell /sys/bus/coresight/devices/*/enable_source
    chmod 660 /sys/bus/coresight/devices/*/enable_source
    chgrp shell /sys/bus/coresight/devices/*/enable_sink
    chmod 660 /sys/bus/coresight/devices/*/enable_sink
}

enable_cti_flush_for_etf()
{
    if [ "$debug_build" != true ]; then
        return
    fi

    echo 1 > /sys/bus/coresight/devices/tmc_etf0/stop_on_flush
    echo 1 > /sys/bus/coresight/devices/cti_swao/enable
    echo 0 24 > /sys/bus/coresight/devices/cti_swao/channels/trigin_attach
    echo 0 1 > /sys/bus/coresight/devices/cti_swao/channels/trigout_attach
}

find_build_type()
{
    linux_banner=`cat /proc/version`
    if [[ "$linux_banner" == *"-debug"* ]]; then
        debug_build=true
    fi
}

init_memshare_dynamic_size()
{
    echo 0x500000 > /sys/kernel/memshare_diag/dynamic_size
}

enable_cnss_uwb_bt_traces()
{
    tracefs=/sys/kernel/tracing

    # enable tracing for consolidate/debug builds, where debug_build is set true
    if [ "$debug_build" = true ]; then
        setprop persist.vendor.tracing.enabled 1
    fi

    if [ -d $tracefs ] && [ "$(getprop persist.vendor.tracing.enabled)" -eq "1" ]; then
        create_instance $tracefs/instances/spi_cnss
        #SPI
        echo 800 > $tracefs/instances/spi_cnss/buffer_size_kb
        echo 1 > $tracefs/instances/spi_cnss/events/spi_cnss_trace/enable
        echo 1 > $tracefs/instances/spi_cnss/tracing_on

    fi
}

init_qpt()
{
    qptfs=/sys/class/powercap/qpt
    #enable power telemetry
    if [ -d $qptfs ]; then
       echo 1 > $qptfs/enabled
    fi
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
debug_build=false
enable_debug()
{
    find_build_type
    init_memshare_dynamic_size
    init_dynamic_mem_dump
    create_stp_policy
    adjust_permission
    enable_cti_flush_for_etf
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_rproc_events
        enable_fastrpc_events
        enable_extra_ftrace_events
        enable_buses_and_interconnect_tracefs_debug
        enable_cnss_uwb_bt_traces
    fi
    #enable_dcc
    enable_cpuss_register
    cpuss_spr_setup
    sf_tracing_disablement
    init_qpt
}

enable_debug
