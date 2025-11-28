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
    echo 0x17811000 2 > $DCC_PATH/config
}

config_dcc_qup()
{
    echo 0x19C0008 1  > $DCC_PATH/config
    echo 0x19C0100 3 > $DCC_PATH/config
    echo 0x19C0110 1  > $DCC_PATH/config
    echo 0x19C0120 2 > $DCC_PATH/config
    echo 0x19C1000 3 > $DCC_PATH/config
    echo 0x19C1100 3 > $DCC_PATH/config
    echo 0x19C1200 3 > $DCC_PATH/config
    echo 0x19C1300 3 > $DCC_PATH/config
    echo 0x19C1400 3 > $DCC_PATH/config
    echo 0x19C1500 3 > $DCC_PATH/config
    echo 0x19C1600 3 > $DCC_PATH/config
    echo 0x19C1700 3 > $DCC_PATH/config
    echo 0x8C0008 1  > $DCC_PATH/config
    echo 0x8C0100 3 > $DCC_PATH/config
    echo 0x8C0110 1  > $DCC_PATH/config
    echo 0x8C0120 2 > $DCC_PATH/config
    echo 0x8C1000 3 > $DCC_PATH/config
    echo 0x8C1100 3 > $DCC_PATH/config
    echo 0x8C1200 3 > $DCC_PATH/config
    echo 0x8C1300 3 > $DCC_PATH/config
    echo 0x8C1400 3 > $DCC_PATH/config
    echo 0x8C1500 3 > $DCC_PATH/config
    echo 0x8C1600 3 > $DCC_PATH/config
    echo 0x8C170 1  > $DCC_PATH/config
    echo 0x8C1700 2 > $DCC_PATH/config
    echo 0xAC0008 1  > $DCC_PATH/config
    echo 0xAC0100 3 > $DCC_PATH/config
    echo 0xAC0110 1  > $DCC_PATH/config
    echo 0xAC0120 2 > $DCC_PATH/config
    echo 0xAC1000 3 > $DCC_PATH/config
    echo 0xAC1100 3 > $DCC_PATH/config
    echo 0xAC1200 3 > $DCC_PATH/config
    echo 0xAC1300 3 > $DCC_PATH/config
    echo 0xAC1400 3 > $DCC_PATH/config
    echo 0xAC1500 3 > $DCC_PATH/config
    echo 0xAC1600 3 > $DCC_PATH/config
    echo 0xAC1700 3 > $DCC_PATH/config
}

config_dcc_smmu()
{
    echo 0x03da0010 1  > $DCC_PATH/config
    echo 0x03da0410 1  > $DCC_PATH/config
    echo 0x03da22fc 3 > $DCC_PATH/config
    echo 0x03da2634 1  > $DCC_PATH/config
    echo 0x03de0010 1  > $DCC_PATH/config
    echo 0x03de0038 1  > $DCC_PATH/config
    echo 0x03de004 1  > $DCC_PATH/config
    echo 0x03de8008 1  > $DCC_PATH/config
    echo 0x03de8020 1  > $DCC_PATH/config
    echo 0x15000000 1  > $DCC_PATH/config
    echo 0x15000000 2 > $DCC_PATH/config
    echo 0x15000010 1  > $DCC_PATH/config
    echo 0x15000010 1  > $DCC_PATH/config
    echo 0x15000020 1  > $DCC_PATH/config
    echo 0x15000020 2 > $DCC_PATH/config
    echo 0x15000024 2 > $DCC_PATH/config
    echo 0x15000028 1  > $DCC_PATH/config
    echo 0x1500003c 1  > $DCC_PATH/config
    echo 0x1500003c 2 > $DCC_PATH/config
    echo 0x15000040 2 > $DCC_PATH/config
    echo 0x15000044 2 > $DCC_PATH/config
    echo 0x15000048 2 > $DCC_PATH/config
    echo 0x1500004c 2 > $DCC_PATH/config
    echo 0x15000050 2 > $DCC_PATH/config
    echo 0x15000054 1  > $DCC_PATH/config
    echo 0x15000060 5 > $DCC_PATH/config
    echo 0x15000070 2 > $DCC_PATH/config
    echo 0x15000074 2 > $DCC_PATH/config
    echo 0x15000088 2 > $DCC_PATH/config
    echo 0x150000a0 10 > $DCC_PATH/config
    echo 0x15000400 1  > $DCC_PATH/config
    echo 0x15000410 1  > $DCC_PATH/config
    echo 0x15000440 6 > $DCC_PATH/config
    echo 0x15000470 2 > $DCC_PATH/config
    echo 0x15000800 192 > $DCC_PATH/config
    echo 0x15000c00 192 > $DCC_PATH/config
    echo 0x15000fd0 124 > $DCC_PATH/config
    echo 0x15002000 4 > $DCC_PATH/config
    echo 0x15002200 2 > $DCC_PATH/config
    echo 0x150022f8 4 > $DCC_PATH/config
    echo 0x15002524 1  > $DCC_PATH/config
    echo 0x15002564 1  > $DCC_PATH/config
    echo 0x15002584 1  > $DCC_PATH/config
    echo 0x150025e4 2 > $DCC_PATH/config
    echo 0x15002648 1  > $DCC_PATH/config
    echo 0x15080000 1  > $DCC_PATH/config
    echo 0x15081000 1  > $DCC_PATH/config
    echo 0x15082000 1  > $DCC_PATH/config
    echo 0x15083000 1  > $DCC_PATH/config
    echo 0x15084000 1  > $DCC_PATH/config
    echo 0x15085000 1  > $DCC_PATH/config
    echo 0x15086000 1  > $DCC_PATH/config
    echo 0x15087000 1  > $DCC_PATH/config
    echo 0x15088000 1  > $DCC_PATH/config
    echo 0x15089000 1  > $DCC_PATH/config
    echo 0x1508a000 1  > $DCC_PATH/config
    echo 0x1508b000 1  > $DCC_PATH/config
    echo 0x1508c000 1  > $DCC_PATH/config
    echo 0x1508d000 1  > $DCC_PATH/config
    echo 0x1508e000 1  > $DCC_PATH/config
    echo 0x1508f000 1  > $DCC_PATH/config
    echo 0x15090000 1  > $DCC_PATH/config
    echo 0x15091000 1  > $DCC_PATH/config
    echo 0x15092000 1  > $DCC_PATH/config
    echo 0x15093000 1  > $DCC_PATH/config
    echo 0x15094000 1  > $DCC_PATH/config
    echo 0x15095000 1  > $DCC_PATH/config
    echo 0x15096000 1  > $DCC_PATH/config
    echo 0x15097000 1  > $DCC_PATH/config
    echo 0x15098000 1  > $DCC_PATH/config
    echo 0x15099000 1  > $DCC_PATH/config
    echo 0x1509a000 1  > $DCC_PATH/config
    echo 0x1509b000 1  > $DCC_PATH/config
    echo 0x1509c000 1  > $DCC_PATH/config
    echo 0x1509d000 1  > $DCC_PATH/config
    echo 0x1509e000 1  > $DCC_PATH/config
    echo 0x1509f000 1  > $DCC_PATH/config
    echo 0x150a0000 1  > $DCC_PATH/config
    echo 0x150a1000 1  > $DCC_PATH/config
    echo 0x150a2000 1  > $DCC_PATH/config
    echo 0x150a3000 1  > $DCC_PATH/config
    echo 0x150a4000 1  > $DCC_PATH/config
    echo 0x150a5000 1  > $DCC_PATH/config
    echo 0x150a6000 1  > $DCC_PATH/config
    echo 0x150a7000 1  > $DCC_PATH/config
    echo 0x150a8000 1  > $DCC_PATH/config
    echo 0x150a9000 1  > $DCC_PATH/config
    echo 0x150aa000 1  > $DCC_PATH/config
    echo 0x150ab000 1  > $DCC_PATH/config
    echo 0x150ac000 1  > $DCC_PATH/config
    echo 0x150ad000 1  > $DCC_PATH/config
    echo 0x150ae000 1  > $DCC_PATH/config
    echo 0x150af000 1  > $DCC_PATH/config
    echo 0x150b0000 1  > $DCC_PATH/config
    echo 0x150b1000 1  > $DCC_PATH/config
    echo 0x150b2000 1  > $DCC_PATH/config
    echo 0x150b3000 1  > $DCC_PATH/config
    echo 0x150b4000 1  > $DCC_PATH/config
    echo 0x150b5000 1  > $DCC_PATH/config
    echo 0x150b6000 1  > $DCC_PATH/config
    echo 0x150b7000 1  > $DCC_PATH/config
    echo 0x150b8000 1  > $DCC_PATH/config
    echo 0x150b9000 1  > $DCC_PATH/config
    echo 0x150ba000 1  > $DCC_PATH/config
    echo 0x150bb000 1  > $DCC_PATH/config
    echo 0x150bc000 1  > $DCC_PATH/config
    echo 0x150bd000 1  > $DCC_PATH/config
    echo 0x150be000 1  > $DCC_PATH/config
    echo 0x150bf000 1  > $DCC_PATH/config
    echo 0x150c0000 1  > $DCC_PATH/config
    echo 0x150c1000 1  > $DCC_PATH/config
    echo 0x150c2000 1  > $DCC_PATH/config
    echo 0x150c3000 1  > $DCC_PATH/config
    echo 0x150c4000 1  > $DCC_PATH/config
    echo 0x150c5000 1  > $DCC_PATH/config
    echo 0x150c6000 1  > $DCC_PATH/config
    echo 0x150c7000 1  > $DCC_PATH/config
    echo 0x150c8000 1  > $DCC_PATH/config
    echo 0x150c9000 1  > $DCC_PATH/config
    echo 0x150ca000 1  > $DCC_PATH/config
    echo 0x150cb000 1  > $DCC_PATH/config
    echo 0x150cc000 1  > $DCC_PATH/config
    echo 0x150cd000 1  > $DCC_PATH/config
    echo 0x150ce000 1  > $DCC_PATH/config
    echo 0x150cf000 1  > $DCC_PATH/config
    echo 0x150d0000 1  > $DCC_PATH/config
    echo 0x150d1000 1  > $DCC_PATH/config
    echo 0x150d2000 1  > $DCC_PATH/config
    echo 0x150d3000 1  > $DCC_PATH/config
    echo 0x150d4000 1  > $DCC_PATH/config
    echo 0x150d5000 1  > $DCC_PATH/config
    echo 0x150d6000 1  > $DCC_PATH/config
    echo 0x150d7000 1  > $DCC_PATH/config
    echo 0x150d8000 1  > $DCC_PATH/config
    echo 0x150d9000 1  > $DCC_PATH/config
    echo 0x150da000 1  > $DCC_PATH/config
    echo 0x150db000 1  > $DCC_PATH/config
    echo 0x150dc000 1  > $DCC_PATH/config
    echo 0x150dd000 1  > $DCC_PATH/config
    echo 0x150de000 1  > $DCC_PATH/config
    echo 0x150df000 1  > $DCC_PATH/config
    echo 0x150e0000 1  > $DCC_PATH/config
    echo 0x150e1000 1  > $DCC_PATH/config
    echo 0x150e2000 1  > $DCC_PATH/config
    echo 0x150e3000 1  > $DCC_PATH/config
    echo 0x150e4000 1  > $DCC_PATH/config
    echo 0x150e5000 1  > $DCC_PATH/config
    echo 0x150e6000 1  > $DCC_PATH/config
    echo 0x150e7000 1  > $DCC_PATH/config
    echo 0x150e8000 1  > $DCC_PATH/config
    echo 0x150e9000 1  > $DCC_PATH/config
    echo 0x150ea000 1  > $DCC_PATH/config
    echo 0x150eb000 1  > $DCC_PATH/config
    echo 0x150ec000 1  > $DCC_PATH/config
    echo 0x150ed000 1  > $DCC_PATH/config
    echo 0x150ee000 1  > $DCC_PATH/config
    echo 0x150ef000 1  > $DCC_PATH/config
    echo 0x151fc010 1  > $DCC_PATH/config
    echo 0x151fc030 1  > $DCC_PATH/config
    echo 0x151fc038 1  > $DCC_PATH/config
    echo 0x151fc040 1  > $DCC_PATH/config
    echo 0x151fc048 1  > $DCC_PATH/config
    echo 0x151fc050 1  > $DCC_PATH/config
    echo 0x151fc058 1  > $DCC_PATH/config
    echo 0x151fc060 1  > $DCC_PATH/config
    echo 0x151fc068 1  > $DCC_PATH/config
    echo 0x151fc080 1  > $DCC_PATH/config
    echo 0x151fc088 1  > $DCC_PATH/config
    echo 0x151fc090 1  > $DCC_PATH/config
    echo 0x151fc098 1  > $DCC_PATH/config
    echo 0x151fc0a0 1  > $DCC_PATH/config
    echo 0x151fc0a8 1  > $DCC_PATH/config
    echo 0x151fc0b0 1  > $DCC_PATH/config
    echo 0x151fc0b8 1  > $DCC_PATH/config
}

config_dcc_eva()
{
    echo 0x13202C > $DCC_PATH/config
    echo 0x132040 > $DCC_PATH/config
    echo 0x2400050 > $DCC_PATH/config
    echo 0x241F004 > $DCC_PATH/config
    echo 0x24A0018 > $DCC_PATH/config
    echo 0x24A004C > $DCC_PATH/config
    echo 0x24A0150 > $DCC_PATH/config
    echo 0x24B000C > $DCC_PATH/config
    echo 0x24B0050 5 > $DCC_PATH/config
    echo 0x24B0088 > $DCC_PATH/config
    echo 0x24C0010 2 > $DCC_PATH/config
    echo 0x24E0008 2 > $DCC_PATH/config
    echo 0x24E001C > $DCC_PATH/config
    echo 0x24E0024 2 > $DCC_PATH/config
    echo 0x24F8034 > $DCC_PATH/config
    echo 0x24F804C > $DCC_PATH/config
    echo 0x24F8068 > $DCC_PATH/config
    echo 0x24F807C > $DCC_PATH/config
    echo 0x24A0048 9 > $DCC_PATH/config
    echo 0x24A0038 2 > $DCC_PATH/config
    echo 0x24C0020 > $DCC_PATH/config
    echo 0x24E0014 > $DCC_PATH/config
    echo 0x24E0024 > $DCC_PATH/config
    echo 0x24E001C > $DCC_PATH/config
    echo 0x24E002C 2 > $DCC_PATH/config
    echo 0x24F80A4 > $DCC_PATH/config
    echo 0x19F004 2 > $DCC_PATH/config
    echo 0x19F01C > $DCC_PATH/config
    echo 0x24F808C > $DCC_PATH/config
    echo 0x24F805C > $DCC_PATH/config
    echo 0x24F80E4 > $DCC_PATH/config
    echo 0x24F9F24 > $DCC_PATH/config
    echo 0x24B0000 > $DCC_PATH/config
    echo 0x24C0000 > $DCC_PATH/config
    echo 0x24C0010 3 > $DCC_PATH/config
    echo 0x24C0020 > $DCC_PATH/config
    echo 0x24C1000 > $DCC_PATH/config
    echo 0x24C1020 8 > $DCC_PATH/config
    echo 0x24C2100 10 > $DCC_PATH/config
    echo 0x2400090 > $DCC_PATH/config
    echo 0x2400094 > $DCC_PATH/config
}


config_dcc_ddr_nonsecure()
{
    echo 0x31076008 1  > $DCC_PATH/config
    echo 0x310760b4 1  > $DCC_PATH/config
    echo 0x31076100 16 > $DCC_PATH/config
    echo 0x31076948 1  > $DCC_PATH/config
    echo 0x31076b00 2 > $DCC_PATH/config
    echo 0x31076b0c 2 > $DCC_PATH/config
    echo 0x31076b18 2 > $DCC_PATH/config
    echo 0x31076b24 2 > $DCC_PATH/config
    echo 0x31076b30 2 > $DCC_PATH/config
    echo 0x31076b3c 2 > $DCC_PATH/config
    echo 0x31076b48 2 > $DCC_PATH/config
    echo 0x31076b54 2 > $DCC_PATH/config
    echo 0x31076b60 2 > $DCC_PATH/config
    echo 0x31076b6c 2 > $DCC_PATH/config
    echo 0x31076b78 2 > $DCC_PATH/config
    echo 0x31076b84 2 > $DCC_PATH/config
    echo 0x31076b90 2 > $DCC_PATH/config
    echo 0x31076b9c 2 > $DCC_PATH/config
    echo 0x31076ba8 2 > $DCC_PATH/config
    echo 0x31076bb4 2 > $DCC_PATH/config
    echo 0x31076bc0 2 > $DCC_PATH/config
    echo 0x31076bcc 2 > $DCC_PATH/config
    echo 0x31076bd8 2 > $DCC_PATH/config
    echo 0x31076be4 2 > $DCC_PATH/config
    echo 0x31076bf0 2 > $DCC_PATH/config
    echo 0x31076bfc 2 > $DCC_PATH/config
    echo 0x31076c08 2 > $DCC_PATH/config
    echo 0x31076c14 2 > $DCC_PATH/config
    echo 0x31076c20 2 > $DCC_PATH/config
    echo 0x31076c2c 2 > $DCC_PATH/config
    echo 0x31076c38 2 > $DCC_PATH/config
    echo 0x31076c44 2 > $DCC_PATH/config
    echo 0x31076c50 2 > $DCC_PATH/config
    echo 0x31076c5c 2 > $DCC_PATH/config
    echo 0x31076c68 2 > $DCC_PATH/config
    echo 0x31076c74 2 > $DCC_PATH/config
    echo 0x31076d00 2 > $DCC_PATH/config
    echo 0x31076d0c 2 > $DCC_PATH/config
    echo 0x31076d18 2 > $DCC_PATH/config
    echo 0x31076d24 2 > $DCC_PATH/config
    echo 0x31076d30 2 > $DCC_PATH/config
    echo 0x31076d3c 2 > $DCC_PATH/config
    echo 0x31076d48 2 > $DCC_PATH/config
    echo 0x31076d54 2 > $DCC_PATH/config
    echo 0x31076d60 2 > $DCC_PATH/config
    echo 0x31076d6c 2 > $DCC_PATH/config
    echo 0x31076d78 2 > $DCC_PATH/config
    echo 0x31076d84 2 > $DCC_PATH/config
    echo 0x31076d90 2 > $DCC_PATH/config
    echo 0x31076d9c 2 > $DCC_PATH/config
    echo 0x31076da8 2 > $DCC_PATH/config
    echo 0x31076db4 2 > $DCC_PATH/config
    echo 0x31076dc0 2 > $DCC_PATH/config
    echo 0x31076dcc 2 > $DCC_PATH/config
    echo 0x31076dd8 2 > $DCC_PATH/config
    echo 0x31076de4 2 > $DCC_PATH/config
    echo 0x31076df0 2 > $DCC_PATH/config
    echo 0x31076dfc 2 > $DCC_PATH/config
    echo 0x31076e08 2 > $DCC_PATH/config
    echo 0x31076e14 2 > $DCC_PATH/config
    echo 0x31076e20 2 > $DCC_PATH/config
    echo 0x31076e2c 2 > $DCC_PATH/config
    echo 0x31076e38 2 > $DCC_PATH/config
    echo 0x31076e44 2 > $DCC_PATH/config
    echo 0x31076e50 2 > $DCC_PATH/config
    echo 0x31076e5c 2 > $DCC_PATH/config
    echo 0x31076e68 2 > $DCC_PATH/config
    echo 0x31076e74 2 > $DCC_PATH/config
    echo 0x31080058 2 > $DCC_PATH/config
    echo 0x310800c8 1  > $DCC_PATH/config
    echo 0x31080104 1  > $DCC_PATH/config
    echo 0x31080110 1  > $DCC_PATH/config
    echo 0x310801b0 2 > $DCC_PATH/config
    echo 0x3108020c 1  > $DCC_PATH/config
    echo 0x31080214 1  > $DCC_PATH/config
    echo 0x31080224 1  > $DCC_PATH/config
    echo 0x31080254 1  > $DCC_PATH/config
    echo 0x310802c0 12 > $DCC_PATH/config
    echo 0x310A8090 1  > $DCC_PATH/config
    echo 0x310A817C 1  > $DCC_PATH/config
    echo 0x310a8018 21 > $DCC_PATH/config
    echo 0x310a8070 5 > $DCC_PATH/config
    echo 0x310a8088 2 > $DCC_PATH/config
    echo 0x310a8094 7 > $DCC_PATH/config
    echo 0x310a80b4 5 > $DCC_PATH/config
    echo 0x310a80cc 9 > $DCC_PATH/config
    echo 0x310a8118 2 > $DCC_PATH/config
    echo 0x310a8130 3 > $DCC_PATH/config
    echo 0x310a8144 9 > $DCC_PATH/config
    echo 0x310a816c 4 > $DCC_PATH/config
    echo 0x310a8180 1  > $DCC_PATH/config
    echo 0x310a8188 1  > $DCC_PATH/config
    echo 0x310a8190 2 > $DCC_PATH/config
    echo 0x310a81a4 1  > $DCC_PATH/config
    echo 0x310a81ac 16 > $DCC_PATH/config
    echo 0x310a82bc 3 > $DCC_PATH/config
    echo 0x310a82d4 1  > $DCC_PATH/config
    echo 0x310a82dc 16 > $DCC_PATH/config
    echo 0x310a83ec 18 > $DCC_PATH/config
    echo 0x310a9000 2 > $DCC_PATH/config
    echo 0x310a9010 2 > $DCC_PATH/config
    echo 0x310a9020 3 > $DCC_PATH/config
    echo 0x310a9034 2 > $DCC_PATH/config
    echo 0x310a9120 2 > $DCC_PATH/config
    echo 0x310a9130 6 > $DCC_PATH/config
    echo 0x310a914c 5 > $DCC_PATH/config
    echo 0x310a9164 9 > $DCC_PATH/config
    echo 0x310a91a4 2 > $DCC_PATH/config
    echo 0x310a91b4 4 > $DCC_PATH/config
    echo 0x310a91c8 2 > $DCC_PATH/config
    echo 0x310a9204 6 > $DCC_PATH/config
    echo 0x310a9220 8 > $DCC_PATH/config
    echo 0x310a9244 9 > $DCC_PATH/config
    echo 0x310a9280 2 > $DCC_PATH/config
    echo 0x310a9294 7 > $DCC_PATH/config
    echo 0x310a92b4 5 > $DCC_PATH/config
    echo 0x310a92d0 3 > $DCC_PATH/config
    echo 0x310a92ec 5 > $DCC_PATH/config
    echo 0x310a930c 1  > $DCC_PATH/config
    echo 0x310ab000 16 > $DCC_PATH/config
    echo 0x310ba050 1  > $DCC_PATH/config
    echo 0x310ba280 1  > $DCC_PATH/config
    echo 0x310ba288 8 > $DCC_PATH/config
    echo 0x310ba2c0 2 > $DCC_PATH/config
    echo 0x31203410 1  > $DCC_PATH/config
    echo 0x31800004 1  > $DCC_PATH/config
    echo 0x31801004 1  > $DCC_PATH/config
    echo 0x31802004 1  > $DCC_PATH/config
    echo 0x31803004 1  > $DCC_PATH/config
    echo 0x31804004 1  > $DCC_PATH/config
    echo 0x31805004 1  > $DCC_PATH/config
    echo 0x31806004 1  > $DCC_PATH/config
    echo 0x31807004 1  > $DCC_PATH/config
    echo 0x31808004 1  > $DCC_PATH/config
    echo 0x31809004 1  > $DCC_PATH/config
    echo 0x3180a004 1  > $DCC_PATH/config
    echo 0x3180b004 1  > $DCC_PATH/config
    echo 0x3180c004 1  > $DCC_PATH/config
    echo 0x3180d004 1  > $DCC_PATH/config
    echo 0x3180e004 1  > $DCC_PATH/config
    echo 0x3180f004 1  > $DCC_PATH/config
    echo 0x31810004 1  > $DCC_PATH/config
    echo 0x31811004 1  > $DCC_PATH/config
    echo 0x31812004 1  > $DCC_PATH/config
    echo 0x31813004 1  > $DCC_PATH/config
    echo 0x31814004 1  > $DCC_PATH/config
    echo 0x31815004 1  > $DCC_PATH/config
    echo 0x31816004 1  > $DCC_PATH/config
    echo 0x31817004 1  > $DCC_PATH/config
    echo 0x31818004 1  > $DCC_PATH/config
    echo 0x31819004 1  > $DCC_PATH/config
    echo 0x3181a004 1  > $DCC_PATH/config
    echo 0x3181b004 1  > $DCC_PATH/config
    echo 0x3181c004 1  > $DCC_PATH/config
    echo 0x3181d004 1  > $DCC_PATH/config
    echo 0x3181e004 1  > $DCC_PATH/config
    echo 0x3181f004 1  > $DCC_PATH/config
    echo 0x31820004 1  > $DCC_PATH/config
    echo 0x31821004 1  > $DCC_PATH/config
    echo 0x31822004 1  > $DCC_PATH/config
    echo 0x31823004 1  > $DCC_PATH/config
    echo 0x31843350 2 > $DCC_PATH/config
    echo 0x318433f4 50 > $DCC_PATH/config
    echo 0x318434c0 6 > $DCC_PATH/config
    echo 0x31843600 1  > $DCC_PATH/config
    echo 0x3184360c 1  > $DCC_PATH/config
    echo 0x31845040 1  > $DCC_PATH/config
    echo 0x31845048 1  > $DCC_PATH/config
    echo 0x31845050 1  > $DCC_PATH/config
    echo 0x31845058 1  > $DCC_PATH/config
    echo 0x31845060 1  > $DCC_PATH/config
    echo 0x31845068 1  > $DCC_PATH/config
    echo 0x31845070 4 > $DCC_PATH/config
    echo 0x31845240 1  > $DCC_PATH/config
    echo 0x318452a0 1  > $DCC_PATH/config
    echo 0x31845300 1  > $DCC_PATH/config
    echo 0x31845310 1  > $DCC_PATH/config
    echo 0x31845320 1  > $DCC_PATH/config
    echo 0x31847404 1  > $DCC_PATH/config
    echo 0x3184740c 3 > $DCC_PATH/config
    echo 0x31847448 1  > $DCC_PATH/config
    echo 0x31847450 1  > $DCC_PATH/config
    echo 0x31847458 2 > $DCC_PATH/config
    echo 0x31847600 1  > $DCC_PATH/config
    echo 0x31849000 1  > $DCC_PATH/config
    echo 0x31849010 1  > $DCC_PATH/config
    echo 0x3184b010 1  > $DCC_PATH/config
    echo 0x3184c010 1  > $DCC_PATH/config
    echo 0x3184d010 1  > $DCC_PATH/config
    echo 0x3184e010 1  > $DCC_PATH/config
    echo 0x3184f010 1  > $DCC_PATH/config
    echo 0x31850010 1  > $DCC_PATH/config
    echo 0x31851010 1  > $DCC_PATH/config
    echo 0x3186400c 2 > $DCC_PATH/config
    echo 0x31864020 1  > $DCC_PATH/config
    echo 0x31864030 1  > $DCC_PATH/config
    echo 0x31864040 1  > $DCC_PATH/config
    echo 0x31864220 1  > $DCC_PATH/config
    echo 0x31864228 1  > $DCC_PATH/config
    echo 0x31864230 1  > $DCC_PATH/config
    echo 0x31864238 1  > $DCC_PATH/config
    echo 0x318650a4 4 > $DCC_PATH/config
    echo 0x318650b8 4 > $DCC_PATH/config
    echo 0x3186801c 8 > $DCC_PATH/config
    echo 0x31868050 1  > $DCC_PATH/config
    echo 0x31868060 1  > $DCC_PATH/config
    echo 0x31868100 7 > $DCC_PATH/config
    echo 0x31868120 5 > $DCC_PATH/config
    echo 0x31868204 2 > $DCC_PATH/config
    echo 0x31868218 1  > $DCC_PATH/config
    echo 0x318690fc 1  > $DCC_PATH/config
    echo 0x3186c004 1  > $DCC_PATH/config
    echo 0x3186c014 1  > $DCC_PATH/config
    echo 0x3186c05c 3 > $DCC_PATH/config
    echo 0x3186c088 1  > $DCC_PATH/config
    echo 0x3186c0d0 1  > $DCC_PATH/config
    echo 0x3186c0f0 1  > $DCC_PATH/config
    echo 0x3186c100 1  > $DCC_PATH/config
    echo 0x3186c114 1  > $DCC_PATH/config
    echo 0x3186c134 1  > $DCC_PATH/config
    echo 0x3186c160 2 > $DCC_PATH/config
    echo 0x3186d064 1  > $DCC_PATH/config
    echo 0x31870008 6 > $DCC_PATH/config
    echo 0x31870028 5 > $DCC_PATH/config
    echo 0x31870040 1  > $DCC_PATH/config
    echo 0x31870048 5 > $DCC_PATH/config
    echo 0x31870060 2 > $DCC_PATH/config
    echo 0x31870070 8 > $DCC_PATH/config
    echo 0x3187203c 14 > $DCC_PATH/config
    echo 0x3187208c 1  > $DCC_PATH/config
    echo 0x31872098 1  > $DCC_PATH/config
    echo 0x318720b8 3 > $DCC_PATH/config
    echo 0x318720f4 9 > $DCC_PATH/config
    echo 0x31872324 14 > $DCC_PATH/config
    echo 0x31872410 1  > $DCC_PATH/config
    echo 0x31872444 1  > $DCC_PATH/config
    echo 0x318730a8 1  > $DCC_PATH/config
    echo 0x31874038 4 > $DCC_PATH/config
    echo 0x31874060 7 > $DCC_PATH/config
    echo 0x31878004 7 > $DCC_PATH/config
    echo 0x31878024 1  > $DCC_PATH/config
    echo 0x31878040 1  > $DCC_PATH/config
    echo 0x31878048 1  > $DCC_PATH/config
    echo 0x31878050 1  > $DCC_PATH/config
    echo 0x31879064 1  > $DCC_PATH/config
    echo 0x3187c030 8 > $DCC_PATH/config
    echo 0x3187c054 2 > $DCC_PATH/config
    echo 0x3187c078 1  > $DCC_PATH/config
    echo 0x3187c108 2 > $DCC_PATH/config
    echo 0x31880020 1  > $DCC_PATH/config
    echo 0x31882044 2 > $DCC_PATH/config
    echo 0x31882090 1  > $DCC_PATH/config
    echo 0x318820f4 2 > $DCC_PATH/config
    echo 0x31882150 1  > $DCC_PATH/config
    echo 0x318a600c 1  > $DCC_PATH/config
    echo 0x318a6014 1  > $DCC_PATH/config
    echo 0x318a6020 3 > $DCC_PATH/config
    echo 0x318a6034 2 > $DCC_PATH/config
    echo 0x318a6040 1  > $DCC_PATH/config
    echo 0x318a6050 1  > $DCC_PATH/config
    echo 0x318a6058 1  > $DCC_PATH/config
    echo 0x318a6060 1  > $DCC_PATH/config
    echo 0x318a6068 2 > $DCC_PATH/config
    echo 0x318a6120 1  > $DCC_PATH/config
    echo 0x318a6200 1  > $DCC_PATH/config
    echo 0x318a6214 1  > $DCC_PATH/config
    echo 0x318a7020 1  > $DCC_PATH/config
    echo 0x318a7030 2 > $DCC_PATH/config
    echo 0x318a7078 2 > $DCC_PATH/config
    echo 0x318a7084 1  > $DCC_PATH/config
    echo 0x318a7090 5 > $DCC_PATH/config
    echo 0x318a718c 1  > $DCC_PATH/config
    echo 0x318a71b0 1  > $DCC_PATH/config
    echo 0x318a7204 5 > $DCC_PATH/config
    echo 0x3190009c 1  > $DCC_PATH/config
    echo 0x31900168 1  > $DCC_PATH/config
    echo 0x31A02744 4 > $DCC_PATH/config
    echo 0x31BC0010 6 > $DCC_PATH/config
    echo 0x31BC002C 7 > $DCC_PATH/config
    echo 0x31C68204 2 > $DCC_PATH/config
    echo 0x31E02744 4 > $DCC_PATH/config
    echo 0x31FC0010 14 > $DCC_PATH/config
    echo 0x31a00080 1  > $DCC_PATH/config
    echo 0x31a00304 1  > $DCC_PATH/config
    echo 0x31a00310 1  > $DCC_PATH/config
    echo 0x31a004bc 1  > $DCC_PATH/config
    echo 0x31a00700 1  > $DCC_PATH/config
    echo 0x31a00708 5 > $DCC_PATH/config
    echo 0x31a00720 1  > $DCC_PATH/config
    echo 0x31a00740 1  > $DCC_PATH/config
    echo 0x31a00748 1  > $DCC_PATH/config
    echo 0x31a007b4 2 > $DCC_PATH/config
    echo 0x31a007d0 3 > $DCC_PATH/config
    echo 0x31a007e0 2 > $DCC_PATH/config
    echo 0x31a007f0 2 > $DCC_PATH/config
    echo 0x31a01418 4 > $DCC_PATH/config
    echo 0x31a0142c 2 > $DCC_PATH/config
    echo 0x31a01550 1  > $DCC_PATH/config
    echo 0x31a02700 2 > $DCC_PATH/config
    echo 0x31a02710 1  > $DCC_PATH/config
    echo 0x31a02718 1  > $DCC_PATH/config
    echo 0x31a02720 9 > $DCC_PATH/config
    echo 0x31a02754 9 > $DCC_PATH/config
    echo 0x31a02780 2 > $DCC_PATH/config
    echo 0x31a02790 1  > $DCC_PATH/config
    echo 0x31a03424 1  > $DCC_PATH/config
    echo 0x31a03480 1  > $DCC_PATH/config
    echo 0x31a05110 1  > $DCC_PATH/config
    echo 0x31a05130 1  > $DCC_PATH/config
    echo 0x31a05150 1  > $DCC_PATH/config
    echo 0x31a05170 1  > $DCC_PATH/config
    echo 0x31a05190 1  > $DCC_PATH/config
    echo 0x31a05210 1  > $DCC_PATH/config
    echo 0x31a05230 1  > $DCC_PATH/config
    echo 0x31a053b0 2 > $DCC_PATH/config
    echo 0x31a05804 1  > $DCC_PATH/config
    echo 0x31a0590c 1  > $DCC_PATH/config
    echo 0x31a05a14 1  > $DCC_PATH/config
    echo 0x31a05bc8 1  > $DCC_PATH/config
    echo 0x31a05be0 6 > $DCC_PATH/config
    echo 0x31a05c04 8 > $DCC_PATH/config
    echo 0x31a05c2c 8 > $DCC_PATH/config
    echo 0x31a05c50 6 > $DCC_PATH/config
    echo 0x31a05c74 22 > $DCC_PATH/config
    echo 0x31a05cdc 4 > $DCC_PATH/config
    echo 0x31a05cfc 7 > $DCC_PATH/config
    echo 0x31a06114 3 > $DCC_PATH/config
    echo 0x31a06130 4 > $DCC_PATH/config
    echo 0x31a06150 4 > $DCC_PATH/config
    echo 0x31a06170 4 > $DCC_PATH/config
    echo 0x31a06190 4 > $DCC_PATH/config
    echo 0x31a061b0 4 > $DCC_PATH/config
    echo 0x31a061d0 4 > $DCC_PATH/config
    echo 0x31a061f0 4 > $DCC_PATH/config
    echo 0x31a06728 13 > $DCC_PATH/config
    echo 0x31a0d400 1  > $DCC_PATH/config
    echo 0x31b82190 1  > $DCC_PATH/config
    echo 0x31b821dc 1  > $DCC_PATH/config
    echo 0x31b822e4 3 > $DCC_PATH/config
    echo 0x31b85190 1  > $DCC_PATH/config
    echo 0x31b851dc 1  > $DCC_PATH/config
    echo 0x31b852e4 3 > $DCC_PATH/config
    echo 0x31b865f8 1  > $DCC_PATH/config
    echo 0x31b86614 1  > $DCC_PATH/config
    echo 0x31b869fc 1  > $DCC_PATH/config
    echo 0x31b86a04 1  > $DCC_PATH/config
    echo 0x31b86a3c 1  > $DCC_PATH/config
    echo 0x31b86a44 1  > $DCC_PATH/config
    echo 0x31b86a4c 1  > $DCC_PATH/config
    echo 0x31b86a7c 1  > $DCC_PATH/config
    echo 0x31b86a84 1  > $DCC_PATH/config
    echo 0x31b86a8c 1  > $DCC_PATH/config
    echo 0x31b86b3c 1  > $DCC_PATH/config
    echo 0x31b86b44 1  > $DCC_PATH/config
    echo 0x31b86b7c 1  > $DCC_PATH/config
    echo 0x31b86c48 2 > $DCC_PATH/config
    echo 0x31b86ecc 1  > $DCC_PATH/config
    echo 0x31b86edc 1  > $DCC_PATH/config
    echo 0x31b86f10 1  > $DCC_PATH/config
    echo 0x31b86f18 1  > $DCC_PATH/config
    echo 0x31b86f20 1  > $DCC_PATH/config
    echo 0x31b86f28 1  > $DCC_PATH/config
    echo 0x31b86f58 2 > $DCC_PATH/config
    echo 0x31b86f90 1  > $DCC_PATH/config
    echo 0x31b86f98 1  > $DCC_PATH/config
    echo 0x31b86fd0 1  > $DCC_PATH/config
    echo 0x31b86fd8 1  > $DCC_PATH/config
    echo 0x31b87010 1  > $DCC_PATH/config
    echo 0x31b87444 1  > $DCC_PATH/config
    echo 0x31b8744c 2 > $DCC_PATH/config
    echo 0x31bc00c8 1  > $DCC_PATH/config
    echo 0x31bc0710 11 > $DCC_PATH/config
    echo 0x31bc0740 2 > $DCC_PATH/config
    echo 0x31bc0750 4 > $DCC_PATH/config
    echo 0x31bc0770 1  > $DCC_PATH/config
    echo 0x31bc0780 4 > $DCC_PATH/config
    echo 0x31c00004 1  > $DCC_PATH/config
    echo 0x31c01004 1  > $DCC_PATH/config
    echo 0x31c02004 1  > $DCC_PATH/config
    echo 0x31c03004 1  > $DCC_PATH/config
    echo 0x31c04004 1  > $DCC_PATH/config
    echo 0x31c05004 1  > $DCC_PATH/config
    echo 0x31c06004 1  > $DCC_PATH/config
    echo 0x31c07004 1  > $DCC_PATH/config
    echo 0x31c08004 1  > $DCC_PATH/config
    echo 0x31c09004 1  > $DCC_PATH/config
    echo 0x31c0a004 1  > $DCC_PATH/config
    echo 0x31c0b004 1  > $DCC_PATH/config
    echo 0x31c0c004 1  > $DCC_PATH/config
    echo 0x31c0d004 1  > $DCC_PATH/config
    echo 0x31c0e004 1  > $DCC_PATH/config
    echo 0x31c0f004 1  > $DCC_PATH/config
    echo 0x31c10004 1  > $DCC_PATH/config
    echo 0x31c11004 1  > $DCC_PATH/config
    echo 0x31c12004 1  > $DCC_PATH/config
    echo 0x31c13004 1  > $DCC_PATH/config
    echo 0x31c14004 1  > $DCC_PATH/config
    echo 0x31c15004 1  > $DCC_PATH/config
    echo 0x31c16004 1  > $DCC_PATH/config
    echo 0x31c17004 1  > $DCC_PATH/config
    echo 0x31c18004 1  > $DCC_PATH/config
    echo 0x31c19004 1  > $DCC_PATH/config
    echo 0x31c1a004 1  > $DCC_PATH/config
    echo 0x31c1b004 1  > $DCC_PATH/config
    echo 0x31c1c004 1  > $DCC_PATH/config
    echo 0x31c1d004 1  > $DCC_PATH/config
    echo 0x31c1e004 1  > $DCC_PATH/config
    echo 0x31c1f004 1  > $DCC_PATH/config
    echo 0x31c20004 1  > $DCC_PATH/config
    echo 0x31c21004 1  > $DCC_PATH/config
    echo 0x31c22004 1  > $DCC_PATH/config
    echo 0x31c23004 1  > $DCC_PATH/config
    echo 0x31c43350 2 > $DCC_PATH/config
    echo 0x31c433f4 50 > $DCC_PATH/config
    echo 0x31c434c0 6 > $DCC_PATH/config
    echo 0x31c43600 1  > $DCC_PATH/config
    echo 0x31c4360c 1  > $DCC_PATH/config
    echo 0x31c45040 1  > $DCC_PATH/config
    echo 0x31c45048 1  > $DCC_PATH/config
    echo 0x31c45050 1  > $DCC_PATH/config
    echo 0x31c45058 1  > $DCC_PATH/config
    echo 0x31c45060 1  > $DCC_PATH/config
    echo 0x31c45068 1  > $DCC_PATH/config
    echo 0x31c45070 4 > $DCC_PATH/config
    echo 0x31c45240 1  > $DCC_PATH/config
    echo 0x31c452a0 1  > $DCC_PATH/config
    echo 0x31c45300 1  > $DCC_PATH/config
    echo 0x31c45310 1  > $DCC_PATH/config
    echo 0x31c45320 1  > $DCC_PATH/config
    echo 0x31c47404 1  > $DCC_PATH/config
    echo 0x31c4740c 3 > $DCC_PATH/config
    echo 0x31c47448 1  > $DCC_PATH/config
    echo 0x31c47450 1  > $DCC_PATH/config
    echo 0x31c47458 2 > $DCC_PATH/config
    echo 0x31c47600 1  > $DCC_PATH/config
    echo 0x31c49000 1  > $DCC_PATH/config
    echo 0x31c49010 1  > $DCC_PATH/config
    echo 0x31c4b010 1  > $DCC_PATH/config
    echo 0x31c4c010 1  > $DCC_PATH/config
    echo 0x31c4d010 1  > $DCC_PATH/config
    echo 0x31c4e010 1  > $DCC_PATH/config
    echo 0x31c4f010 1  > $DCC_PATH/config
    echo 0x31c50010 1  > $DCC_PATH/config
    echo 0x31c51010 1  > $DCC_PATH/config
    echo 0x31c64010 1  > $DCC_PATH/config
    echo 0x31c64020 1  > $DCC_PATH/config
    echo 0x31c64030 1  > $DCC_PATH/config
    echo 0x31c64040 1  > $DCC_PATH/config
    echo 0x31c64220 1  > $DCC_PATH/config
    echo 0x31c64228 1  > $DCC_PATH/config
    echo 0x31c64230 1  > $DCC_PATH/config
    echo 0x31c64238 1  > $DCC_PATH/config
    echo 0x31c6801c 8 > $DCC_PATH/config
    echo 0x31c68050 1  > $DCC_PATH/config
    echo 0x31c68060 1  > $DCC_PATH/config
    echo 0x31c68100 7 > $DCC_PATH/config
    echo 0x31c68120 5 > $DCC_PATH/config
    echo 0x31c68218 1  > $DCC_PATH/config
    echo 0x31c690fc 1  > $DCC_PATH/config
    echo 0x31c6c004 1  > $DCC_PATH/config
    echo 0x31c6c014 1  > $DCC_PATH/config
    echo 0x31c6c05c 3 > $DCC_PATH/config
    echo 0x31c6c088 1  > $DCC_PATH/config
    echo 0x31c6c0d0 1  > $DCC_PATH/config
    echo 0x31c6c0f0 1  > $DCC_PATH/config
    echo 0x31c6c100 1  > $DCC_PATH/config
    echo 0x31c6c114 1  > $DCC_PATH/config
    echo 0x31c6c134 1  > $DCC_PATH/config
    echo 0x31c6c160 2 > $DCC_PATH/config
    echo 0x31c6d064 1  > $DCC_PATH/config
    echo 0x31c70008 6 > $DCC_PATH/config
    echo 0x31c70028 5 > $DCC_PATH/config
    echo 0x31c70040 1  > $DCC_PATH/config
    echo 0x31c70048 5 > $DCC_PATH/config
    echo 0x31c70060 2 > $DCC_PATH/config
    echo 0x31c70070 8 > $DCC_PATH/config
    echo 0x31c7203c 14 > $DCC_PATH/config
    echo 0x31c7208c 1  > $DCC_PATH/config
    echo 0x31c72098 1  > $DCC_PATH/config
    echo 0x31c720b8 3 > $DCC_PATH/config
    echo 0x31c720f4 9 > $DCC_PATH/config
    echo 0x31c72324 14 > $DCC_PATH/config
    echo 0x31c72410 1  > $DCC_PATH/config
    echo 0x31c72444 1  > $DCC_PATH/config
    echo 0x31c730a8 1  > $DCC_PATH/config
    echo 0x31c74038 4 > $DCC_PATH/config
    echo 0x31c74060 7 > $DCC_PATH/config
    echo 0x31c78004 7 > $DCC_PATH/config
    echo 0x31c78024 1  > $DCC_PATH/config
    echo 0x31c78040 1  > $DCC_PATH/config
    echo 0x31c78048 1  > $DCC_PATH/config
    echo 0x31c78050 1  > $DCC_PATH/config
    echo 0x31c79064 1  > $DCC_PATH/config
    echo 0x31c7c030 8 > $DCC_PATH/config
    echo 0x31c7c054 2 > $DCC_PATH/config
    echo 0x31c7c078 1  > $DCC_PATH/config
    echo 0x31c7c108 2 > $DCC_PATH/config
    echo 0x31c80020 1  > $DCC_PATH/config
    echo 0x31c82044 2 > $DCC_PATH/config
    echo 0x31c82090 1  > $DCC_PATH/config
    echo 0x31c820f4 2 > $DCC_PATH/config
    echo 0x31c82150 1  > $DCC_PATH/config
    echo 0x31ca600c 1  > $DCC_PATH/config
    echo 0x31ca6014 1  > $DCC_PATH/config
    echo 0x31ca6020 3 > $DCC_PATH/config
    echo 0x31ca6034 2 > $DCC_PATH/config
    echo 0x31ca6040 1  > $DCC_PATH/config
    echo 0x31ca6050 1  > $DCC_PATH/config
    echo 0x31ca6058 1  > $DCC_PATH/config
    echo 0x31ca6060 1  > $DCC_PATH/config
    echo 0x31ca6068 2 > $DCC_PATH/config
    echo 0x31ca6120 1  > $DCC_PATH/config
    echo 0x31ca6200 1  > $DCC_PATH/config
    echo 0x31ca6214 1  > $DCC_PATH/config
    echo 0x31ca7020 1  > $DCC_PATH/config
    echo 0x31ca7030 2 > $DCC_PATH/config
    echo 0x31ca7078 2 > $DCC_PATH/config
    echo 0x31ca7084 1  > $DCC_PATH/config
    echo 0x31ca7090 5 > $DCC_PATH/config
    echo 0x31ca718c 1  > $DCC_PATH/config
    echo 0x31ca71b0 1  > $DCC_PATH/config
    echo 0x31ca7204 5 > $DCC_PATH/config
    echo 0x31d0009c 1  > $DCC_PATH/config
    echo 0x31d00168 1  > $DCC_PATH/config
    echo 0x31e00080 1  > $DCC_PATH/config
    echo 0x31e00304 1  > $DCC_PATH/config
    echo 0x31e00310 1  > $DCC_PATH/config
    echo 0x31e004bc 1  > $DCC_PATH/config
    echo 0x31e00700 1  > $DCC_PATH/config
    echo 0x31e00708 5 > $DCC_PATH/config
    echo 0x31e00720 1  > $DCC_PATH/config
    echo 0x31e00740 1  > $DCC_PATH/config
    echo 0x31e00748 1  > $DCC_PATH/config
    echo 0x31e007b4 2 > $DCC_PATH/config
    echo 0x31e007d0 3 > $DCC_PATH/config
    echo 0x31e007e0 2 > $DCC_PATH/config
    echo 0x31e007f0 2 > $DCC_PATH/config
    echo 0x31e01418 4 > $DCC_PATH/config
    echo 0x31e0142c 2 > $DCC_PATH/config
    echo 0x31e01550 1  > $DCC_PATH/config
    echo 0x31e02700 2 > $DCC_PATH/config
    echo 0x31e02710 1  > $DCC_PATH/config
    echo 0x31e02718 1  > $DCC_PATH/config
    echo 0x31e02720 9 > $DCC_PATH/config
    echo 0x31e02754 9 > $DCC_PATH/config
    echo 0x31e02780 2 > $DCC_PATH/config
    echo 0x31e02790 1  > $DCC_PATH/config
    echo 0x31e03424 1  > $DCC_PATH/config
    echo 0x31e03480 1  > $DCC_PATH/config
    echo 0x31e05110 1  > $DCC_PATH/config
    echo 0x31e05130 1  > $DCC_PATH/config
    echo 0x31e05150 1  > $DCC_PATH/config
    echo 0x31e05170 1  > $DCC_PATH/config
    echo 0x31e05190 1  > $DCC_PATH/config
    echo 0x31e05210 1  > $DCC_PATH/config
    echo 0x31e05230 1  > $DCC_PATH/config
    echo 0x31e053b0 2 > $DCC_PATH/config
    echo 0x31e05804 1  > $DCC_PATH/config
    echo 0x31e0590c 1  > $DCC_PATH/config
    echo 0x31e05a14 1  > $DCC_PATH/config
    echo 0x31e05bc8 1  > $DCC_PATH/config
    echo 0x31e05be0 6 > $DCC_PATH/config
    echo 0x31e05c04 8 > $DCC_PATH/config
    echo 0x31e05c2c 8 > $DCC_PATH/config
    echo 0x31e05c50 6 > $DCC_PATH/config
    echo 0x31e05c74 22 > $DCC_PATH/config
    echo 0x31e05cdc 4 > $DCC_PATH/config
    echo 0x31e05cfc 7 > $DCC_PATH/config
    echo 0x31e06114 3 > $DCC_PATH/config
    echo 0x31e06130 4 > $DCC_PATH/config
    echo 0x31e06150 4 > $DCC_PATH/config
    echo 0x31e06170 4 > $DCC_PATH/config
    echo 0x31e06190 4 > $DCC_PATH/config
    echo 0x31e061b0 4 > $DCC_PATH/config
    echo 0x31e061d0 4 > $DCC_PATH/config
    echo 0x31e061f0 4 > $DCC_PATH/config
    echo 0x31e06728 13 > $DCC_PATH/config
    echo 0x31e0d400 1  > $DCC_PATH/config
    echo 0x31f82190 1  > $DCC_PATH/config
    echo 0x31f821dc 1  > $DCC_PATH/config
    echo 0x31f822e4 3 > $DCC_PATH/config
    echo 0x31f85190 1  > $DCC_PATH/config
    echo 0x31f851dc 1  > $DCC_PATH/config
    echo 0x31f852e4 3 > $DCC_PATH/config
    echo 0x31f865f8 1  > $DCC_PATH/config
    echo 0x31f86614 1  > $DCC_PATH/config
    echo 0x31f869fc 1  > $DCC_PATH/config
    echo 0x31f86a04 1  > $DCC_PATH/config
    echo 0x31f86a3c 1  > $DCC_PATH/config
    echo 0x31f86a44 1  > $DCC_PATH/config
    echo 0x31f86a4c 1  > $DCC_PATH/config
    echo 0x31f86a7c 1  > $DCC_PATH/config
    echo 0x31f86a84 1  > $DCC_PATH/config
    echo 0x31f86a8c 1  > $DCC_PATH/config
    echo 0x31f86b3c 1  > $DCC_PATH/config
    echo 0x31f86b44 1  > $DCC_PATH/config
    echo 0x31f86b7c 1  > $DCC_PATH/config
    echo 0x31f86c48 2 > $DCC_PATH/config
    echo 0x31f86ecc 1  > $DCC_PATH/config
    echo 0x31f86edc 1  > $DCC_PATH/config
    echo 0x31f86f10 1  > $DCC_PATH/config
    echo 0x31f86f18 1  > $DCC_PATH/config
    echo 0x31f86f20 1  > $DCC_PATH/config
    echo 0x31f86f28 1  > $DCC_PATH/config
    echo 0x31f86f58 2 > $DCC_PATH/config
    echo 0x31f86f90 1  > $DCC_PATH/config
    echo 0x31f86f98 1  > $DCC_PATH/config
    echo 0x31f86fd0 1  > $DCC_PATH/config
    echo 0x31f86fd8 1  > $DCC_PATH/config
    echo 0x31f87010 1  > $DCC_PATH/config
    echo 0x31f87444 1  > $DCC_PATH/config
    echo 0x31f8744c 2 > $DCC_PATH/config
    echo 0x31fc00c8 1  > $DCC_PATH/config
    echo 0x31fc0710 11 > $DCC_PATH/config
    echo 0x31fc0740 2 > $DCC_PATH/config
    echo 0x31fc0750 4 > $DCC_PATH/config
    echo 0x31fc0770 1  > $DCC_PATH/config
    echo 0x31fc0780 4 > $DCC_PATH/config
    echo 0x32800004 1  > $DCC_PATH/config
    echo 0x32801004 1  > $DCC_PATH/config
    echo 0x32802004 1  > $DCC_PATH/config
    echo 0x32803004 1  > $DCC_PATH/config
    echo 0x32804004 1  > $DCC_PATH/config
    echo 0x32805004 1  > $DCC_PATH/config
    echo 0x32806004 1  > $DCC_PATH/config
    echo 0x32807004 1  > $DCC_PATH/config
    echo 0x32808004 1  > $DCC_PATH/config
    echo 0x32809004 1  > $DCC_PATH/config
    echo 0x3280a004 1  > $DCC_PATH/config
    echo 0x3280b004 1  > $DCC_PATH/config
    echo 0x3280c004 1  > $DCC_PATH/config
    echo 0x3280d004 1  > $DCC_PATH/config
    echo 0x3280e004 1  > $DCC_PATH/config
    echo 0x3280f004 1  > $DCC_PATH/config
    echo 0x32810004 1  > $DCC_PATH/config
    echo 0x32811004 1  > $DCC_PATH/config
    echo 0x32812004 1  > $DCC_PATH/config
    echo 0x32813004 1  > $DCC_PATH/config
    echo 0x32814004 1  > $DCC_PATH/config
    echo 0x32815004 1  > $DCC_PATH/config
    echo 0x32816004 1  > $DCC_PATH/config
    echo 0x32817004 1  > $DCC_PATH/config
    echo 0x32818004 1  > $DCC_PATH/config
    echo 0x32819004 1  > $DCC_PATH/config
    echo 0x3281a004 1  > $DCC_PATH/config
    echo 0x3281b004 1  > $DCC_PATH/config
    echo 0x3281c004 1  > $DCC_PATH/config
    echo 0x3281d004 1  > $DCC_PATH/config
    echo 0x3281e004 1  > $DCC_PATH/config
    echo 0x3281f004 1  > $DCC_PATH/config
    echo 0x32820004 1  > $DCC_PATH/config
    echo 0x32821004 1  > $DCC_PATH/config
    echo 0x32822004 1  > $DCC_PATH/config
    echo 0x32823004 1  > $DCC_PATH/config
    echo 0x32843350 2 > $DCC_PATH/config
    echo 0x328433f4 50 > $DCC_PATH/config
    echo 0x328434c0 6 > $DCC_PATH/config
    echo 0x32843600 1  > $DCC_PATH/config
    echo 0x3284360c 1  > $DCC_PATH/config
    echo 0x32845040 1  > $DCC_PATH/config
    echo 0x32845048 1  > $DCC_PATH/config
    echo 0x32845050 1  > $DCC_PATH/config
    echo 0x32845058 1  > $DCC_PATH/config
    echo 0x32845060 1  > $DCC_PATH/config
    echo 0x32845068 1  > $DCC_PATH/config
    echo 0x32845070 4 > $DCC_PATH/config
    echo 0x32845240 1  > $DCC_PATH/config
    echo 0x328452a0 1  > $DCC_PATH/config
    echo 0x32845300 1  > $DCC_PATH/config
    echo 0x32845310 1  > $DCC_PATH/config
    echo 0x32845320 1  > $DCC_PATH/config
    echo 0x32847404 1  > $DCC_PATH/config
    echo 0x3284740c 3 > $DCC_PATH/config
    echo 0x32847448 1  > $DCC_PATH/config
    echo 0x32847450 1  > $DCC_PATH/config
    echo 0x32847458 2 > $DCC_PATH/config
    echo 0x32847600 1  > $DCC_PATH/config
    echo 0x32849000 1  > $DCC_PATH/config
    echo 0x32849010 1  > $DCC_PATH/config
    echo 0x3284b010 1  > $DCC_PATH/config
    echo 0x3284c010 1  > $DCC_PATH/config
    echo 0x3284d010 1  > $DCC_PATH/config
    echo 0x3284e010 1  > $DCC_PATH/config
    echo 0x3284f010 1  > $DCC_PATH/config
    echo 0x32850010 1  > $DCC_PATH/config
    echo 0x32851010 1  > $DCC_PATH/config
    echo 0x32864010 1  > $DCC_PATH/config
    echo 0x32864020 1  > $DCC_PATH/config
    echo 0x32864030 1  > $DCC_PATH/config
    echo 0x32864040 1  > $DCC_PATH/config
    echo 0x32864220 1  > $DCC_PATH/config
    echo 0x32864228 1  > $DCC_PATH/config
    echo 0x32864230 1  > $DCC_PATH/config
    echo 0x32864238 1  > $DCC_PATH/config
    echo 0x3286801c 8 > $DCC_PATH/config
    echo 0x32868050 1  > $DCC_PATH/config
    echo 0x32868060 1  > $DCC_PATH/config
    echo 0x32868100 7 > $DCC_PATH/config
    echo 0x32868120 5 > $DCC_PATH/config
    echo 0x32868204 2 > $DCC_PATH/config
    echo 0x32868218 1  > $DCC_PATH/config
    echo 0x328690fc 1  > $DCC_PATH/config
    echo 0x32870008 6 > $DCC_PATH/config
    echo 0x32870028 5 > $DCC_PATH/config
    echo 0x32870040 1  > $DCC_PATH/config
    echo 0x32870048 5 > $DCC_PATH/config
    echo 0x32870060 2 > $DCC_PATH/config
    echo 0x32870070 8 > $DCC_PATH/config
    echo 0x3287203c 14 > $DCC_PATH/config
    echo 0x3287208c 1  > $DCC_PATH/config
    echo 0x32872098 1  > $DCC_PATH/config
    echo 0x328720b8 3 > $DCC_PATH/config
    echo 0x328720f4 9 > $DCC_PATH/config
    echo 0x32872324 14 > $DCC_PATH/config
    echo 0x32872410 1  > $DCC_PATH/config
    echo 0x32872444 1  > $DCC_PATH/config
    echo 0x328730a8 1  > $DCC_PATH/config
    echo 0x32874038 4 > $DCC_PATH/config
    echo 0x32874060 7 > $DCC_PATH/config
    echo 0x32878004 7 > $DCC_PATH/config
    echo 0x32878024 1  > $DCC_PATH/config
    echo 0x32878040 1  > $DCC_PATH/config
    echo 0x32878048 1  > $DCC_PATH/config
    echo 0x32878050 1  > $DCC_PATH/config
    echo 0x32879064 1  > $DCC_PATH/config
    echo 0x3287c030 8 > $DCC_PATH/config
    echo 0x3287c054 2 > $DCC_PATH/config
    echo 0x3287c078 1  > $DCC_PATH/config
    echo 0x3287c108 2 > $DCC_PATH/config
    echo 0x32880020 1  > $DCC_PATH/config
    echo 0x32882044 2 > $DCC_PATH/config
    echo 0x32882090 1  > $DCC_PATH/config
    echo 0x328820f4 2 > $DCC_PATH/config
    echo 0x32882150 1  > $DCC_PATH/config
    echo 0x328a600c 1  > $DCC_PATH/config
    echo 0x328a6014 1  > $DCC_PATH/config
    echo 0x328a6020 3 > $DCC_PATH/config
    echo 0x328a6034 2 > $DCC_PATH/config
    echo 0x328a6040 1  > $DCC_PATH/config
    echo 0x328a6050 1  > $DCC_PATH/config
    echo 0x328a6058 1  > $DCC_PATH/config
    echo 0x328a6060 1  > $DCC_PATH/config
    echo 0x328a6068 2 > $DCC_PATH/config
    echo 0x328a6120 1  > $DCC_PATH/config
    echo 0x328a6200 1  > $DCC_PATH/config
    echo 0x328a6214 1  > $DCC_PATH/config
    echo 0x328a7020 1  > $DCC_PATH/config
    echo 0x328a7030 2 > $DCC_PATH/config
    echo 0x328a7078 2 > $DCC_PATH/config
    echo 0x328a7084 1  > $DCC_PATH/config
    echo 0x328a7090 5 > $DCC_PATH/config
    echo 0x328a718c 1  > $DCC_PATH/config
    echo 0x328a71b0 1  > $DCC_PATH/config
    echo 0x328a7204 5 > $DCC_PATH/config
    echo 0x3290009c 1  > $DCC_PATH/config
    echo 0x32900168 1  > $DCC_PATH/config
    echo 0x32A02744 4 > $DCC_PATH/config
    echo 0x32BC0010 14 > $DCC_PATH/config
    echo 0x32C68204 2 > $DCC_PATH/config
    echo 0x32E02744 4 > $DCC_PATH/config
    echo 0x32FC0010 14 > $DCC_PATH/config
    echo 0x32a00080 1  > $DCC_PATH/config
    echo 0x32a00304 1  > $DCC_PATH/config
    echo 0x32a00310 1  > $DCC_PATH/config
    echo 0x32a004bc 1  > $DCC_PATH/config
    echo 0x32a00700 1  > $DCC_PATH/config
    echo 0x32a00708 5 > $DCC_PATH/config
    echo 0x32a00720 1  > $DCC_PATH/config
    echo 0x32a00740 1  > $DCC_PATH/config
    echo 0x32a00748 1  > $DCC_PATH/config
    echo 0x32a007b4 2 > $DCC_PATH/config
    echo 0x32a007d0 3 > $DCC_PATH/config
    echo 0x32a007e0 2 > $DCC_PATH/config
    echo 0x32a007f0 2 > $DCC_PATH/config
    echo 0x32a01418 4 > $DCC_PATH/config
    echo 0x32a0142c 2 > $DCC_PATH/config
    echo 0x32a01550 1  > $DCC_PATH/config
    echo 0x32a02700 2 > $DCC_PATH/config
    echo 0x32a02710 1  > $DCC_PATH/config
    echo 0x32a02718 1  > $DCC_PATH/config
    echo 0x32a02720 9 > $DCC_PATH/config
    echo 0x32a02754 9 > $DCC_PATH/config
    echo 0x32a02780 2 > $DCC_PATH/config
    echo 0x32a02790 1  > $DCC_PATH/config
    echo 0x32a03424 1  > $DCC_PATH/config
    echo 0x32a03480 1  > $DCC_PATH/config
    echo 0x32a05110 1  > $DCC_PATH/config
    echo 0x32a05130 1  > $DCC_PATH/config
    echo 0x32a05150 1  > $DCC_PATH/config
    echo 0x32a05170 1  > $DCC_PATH/config
    echo 0x32a05190 1  > $DCC_PATH/config
    echo 0x32a05210 1  > $DCC_PATH/config
    echo 0x32a05230 1  > $DCC_PATH/config
    echo 0x32a053b0 2 > $DCC_PATH/config
    echo 0x32a05804 1  > $DCC_PATH/config
    echo 0x32a0590c 1  > $DCC_PATH/config
    echo 0x32a05a14 1  > $DCC_PATH/config
    echo 0x32a05bc8 1  > $DCC_PATH/config
    echo 0x32a05be0 6 > $DCC_PATH/config
    echo 0x32a05c04 8 > $DCC_PATH/config
    echo 0x32a05c2c 8 > $DCC_PATH/config
    echo 0x32a05c50 6 > $DCC_PATH/config
    echo 0x32a05c74 22 > $DCC_PATH/config
    echo 0x32a05cdc 4 > $DCC_PATH/config
    echo 0x32a05cfc 7 > $DCC_PATH/config
    echo 0x32a06114 3 > $DCC_PATH/config
    echo 0x32a06130 4 > $DCC_PATH/config
    echo 0x32a06150 4 > $DCC_PATH/config
    echo 0x32a06170 4 > $DCC_PATH/config
    echo 0x32a06190 4 > $DCC_PATH/config
    echo 0x32a061b0 4 > $DCC_PATH/config
    echo 0x32a061d0 4 > $DCC_PATH/config
    echo 0x32a061f0 4 > $DCC_PATH/config
    echo 0x32a06728 13 > $DCC_PATH/config
    echo 0x32a0d400 1  > $DCC_PATH/config
    echo 0x32b82190 1  > $DCC_PATH/config
    echo 0x32b821dc 1  > $DCC_PATH/config
    echo 0x32b822e4 3 > $DCC_PATH/config
    echo 0x32b85190 1  > $DCC_PATH/config
    echo 0x32b851dc 1  > $DCC_PATH/config
    echo 0x32b852e4 3 > $DCC_PATH/config
    echo 0x32b865f8 1  > $DCC_PATH/config
    echo 0x32b86614 1  > $DCC_PATH/config
    echo 0x32b869fc 1  > $DCC_PATH/config
    echo 0x32b86a04 1  > $DCC_PATH/config
    echo 0x32b86a3c 1  > $DCC_PATH/config
    echo 0x32b86a44 1  > $DCC_PATH/config
    echo 0x32b86a4c 1  > $DCC_PATH/config
    echo 0x32b86a7c 1  > $DCC_PATH/config
    echo 0x32b86a84 1  > $DCC_PATH/config
    echo 0x32b86a8c 1  > $DCC_PATH/config
    echo 0x32b86b3c 1  > $DCC_PATH/config
    echo 0x32b86b44 1  > $DCC_PATH/config
    echo 0x32b86b7c 1  > $DCC_PATH/config
    echo 0x32b86c48 2 > $DCC_PATH/config
    echo 0x32b86ecc 1  > $DCC_PATH/config
    echo 0x32b86edc 1  > $DCC_PATH/config
    echo 0x32b86f10 1  > $DCC_PATH/config
    echo 0x32b86f18 1  > $DCC_PATH/config
    echo 0x32b86f20 1  > $DCC_PATH/config
    echo 0x32b86f28 1  > $DCC_PATH/config
    echo 0x32b86f58 2 > $DCC_PATH/config
    echo 0x32b86f90 1  > $DCC_PATH/config
    echo 0x32b86f98 1  > $DCC_PATH/config
    echo 0x32b86fd0 1  > $DCC_PATH/config
    echo 0x32b86fd8 1  > $DCC_PATH/config
    echo 0x32b87010 1  > $DCC_PATH/config
    echo 0x32b87444 1  > $DCC_PATH/config
    echo 0x32b8744c 2 > $DCC_PATH/config
    echo 0x32bc00c8 1  > $DCC_PATH/config
    echo 0x32bc0710 11 > $DCC_PATH/config
    echo 0x32bc0740 2 > $DCC_PATH/config
    echo 0x32bc0750 4 > $DCC_PATH/config
    echo 0x32bc0770 1  > $DCC_PATH/config
    echo 0x32bc0780 4 > $DCC_PATH/config
    echo 0x32c00004 1  > $DCC_PATH/config
    echo 0x32c01004 1  > $DCC_PATH/config
    echo 0x32c02004 1  > $DCC_PATH/config
    echo 0x32c03004 1  > $DCC_PATH/config
    echo 0x32c04004 1  > $DCC_PATH/config
    echo 0x32c05004 1  > $DCC_PATH/config
    echo 0x32c06004 1  > $DCC_PATH/config
    echo 0x32c07004 1  > $DCC_PATH/config
    echo 0x32c08004 1  > $DCC_PATH/config
    echo 0x32c09004 1  > $DCC_PATH/config
    echo 0x32c0a004 1  > $DCC_PATH/config
    echo 0x32c0b004 1  > $DCC_PATH/config
    echo 0x32c0c004 1  > $DCC_PATH/config
    echo 0x32c0d004 1  > $DCC_PATH/config
    echo 0x32c0e004 1  > $DCC_PATH/config
    echo 0x32c0f004 1  > $DCC_PATH/config
    echo 0x32c10004 1  > $DCC_PATH/config
    echo 0x32c11004 1  > $DCC_PATH/config
    echo 0x32c12004 1  > $DCC_PATH/config
    echo 0x32c13004 1  > $DCC_PATH/config
    echo 0x32c14004 1  > $DCC_PATH/config
    echo 0x32c15004 1  > $DCC_PATH/config
    echo 0x32c16004 1  > $DCC_PATH/config
    echo 0x32c17004 1  > $DCC_PATH/config
    echo 0x32c18004 1  > $DCC_PATH/config
    echo 0x32c19004 1  > $DCC_PATH/config
    echo 0x32c1a004 1  > $DCC_PATH/config
    echo 0x32c1b004 1  > $DCC_PATH/config
    echo 0x32c1c004 1  > $DCC_PATH/config
    echo 0x32c1d004 1  > $DCC_PATH/config
    echo 0x32c1e004 1  > $DCC_PATH/config
    echo 0x32c1f004 1  > $DCC_PATH/config
    echo 0x32c20004 1  > $DCC_PATH/config
    echo 0x32c21004 1  > $DCC_PATH/config
    echo 0x32c22004 1  > $DCC_PATH/config
    echo 0x32c23004 1  > $DCC_PATH/config
    echo 0x32c43350 2 > $DCC_PATH/config
    echo 0x32c433f4 50 > $DCC_PATH/config
    echo 0x32c434c0 6 > $DCC_PATH/config
    echo 0x32c43600 1  > $DCC_PATH/config
    echo 0x32c4360c 1  > $DCC_PATH/config
    echo 0x32c45040 1  > $DCC_PATH/config
    echo 0x32c45048 1  > $DCC_PATH/config
    echo 0x32c45050 1  > $DCC_PATH/config
    echo 0x32c45058 1  > $DCC_PATH/config
    echo 0x32c45060 1  > $DCC_PATH/config
    echo 0x32c45068 1  > $DCC_PATH/config
    echo 0x32c45070 4 > $DCC_PATH/config
    echo 0x32c45240 1  > $DCC_PATH/config
    echo 0x32c452a0 1  > $DCC_PATH/config
    echo 0x32c45300 1  > $DCC_PATH/config
    echo 0x32c45310 1  > $DCC_PATH/config
    echo 0x32c45320 1  > $DCC_PATH/config
    echo 0x32c47404 1  > $DCC_PATH/config
    echo 0x32c4740c 3 > $DCC_PATH/config
    echo 0x32c47448 1  > $DCC_PATH/config
    echo 0x32c47450 1  > $DCC_PATH/config
    echo 0x32c47458 2 > $DCC_PATH/config
    echo 0x32c47600 1  > $DCC_PATH/config
    echo 0x32c49000 1  > $DCC_PATH/config
    echo 0x32c49010 1  > $DCC_PATH/config
    echo 0x32c4b010 1  > $DCC_PATH/config
    echo 0x32c4c010 1  > $DCC_PATH/config
    echo 0x32c4d010 1  > $DCC_PATH/config
    echo 0x32c4e010 1  > $DCC_PATH/config
    echo 0x32c4f010 1  > $DCC_PATH/config
    echo 0x32c50010 1  > $DCC_PATH/config
    echo 0x32c51010 1  > $DCC_PATH/config
    echo 0x32c64010 1  > $DCC_PATH/config
    echo 0x32c64020 1  > $DCC_PATH/config
    echo 0x32c64030 1  > $DCC_PATH/config
    echo 0x32c64040 1  > $DCC_PATH/config
    echo 0x32c64220 1  > $DCC_PATH/config
    echo 0x32c64228 1  > $DCC_PATH/config
    echo 0x32c64230 1  > $DCC_PATH/config
    echo 0x32c64238 1  > $DCC_PATH/config
    echo 0x32c6801c 8 > $DCC_PATH/config
    echo 0x32c68050 1  > $DCC_PATH/config
    echo 0x32c68060 1  > $DCC_PATH/config
    echo 0x32c68100 7 > $DCC_PATH/config
    echo 0x32c68120 5 > $DCC_PATH/config
    echo 0x32c68218 1  > $DCC_PATH/config
    echo 0x32c690fc 1  > $DCC_PATH/config
    echo 0x32c6c004 1  > $DCC_PATH/config
    echo 0x32c6c014 1  > $DCC_PATH/config
    echo 0x32c6c05c 3 > $DCC_PATH/config
    echo 0x32c6c088 1  > $DCC_PATH/config
    echo 0x32c6c0d0 1  > $DCC_PATH/config
    echo 0x32c6c0f0 1  > $DCC_PATH/config
    echo 0x32c6c100 1  > $DCC_PATH/config
    echo 0x32c6c114 1  > $DCC_PATH/config
    echo 0x32c6c134 1  > $DCC_PATH/config
    echo 0x32c6c160 2 > $DCC_PATH/config
    echo 0x32c6d064 1  > $DCC_PATH/config
    echo 0x32c70008 6 > $DCC_PATH/config
    echo 0x32c70028 5 > $DCC_PATH/config
    echo 0x32c70040 1  > $DCC_PATH/config
    echo 0x32c70048 5 > $DCC_PATH/config
    echo 0x32c70060 2 > $DCC_PATH/config
    echo 0x32c70070 8 > $DCC_PATH/config
    echo 0x32c7203c 14 > $DCC_PATH/config
    echo 0x32c7208c 1  > $DCC_PATH/config
    echo 0x32c72098 1  > $DCC_PATH/config
    echo 0x32c720b8 3 > $DCC_PATH/config
    echo 0x32c720f4 9 > $DCC_PATH/config
    echo 0x32c72324 14 > $DCC_PATH/config
    echo 0x32c72410 1  > $DCC_PATH/config
    echo 0x32c72444 1  > $DCC_PATH/config
    echo 0x32c730a8 1  > $DCC_PATH/config
    echo 0x32c74038 4 > $DCC_PATH/config
    echo 0x32c74060 7 > $DCC_PATH/config
    echo 0x32c78004 7 > $DCC_PATH/config
    echo 0x32c78024 1  > $DCC_PATH/config
    echo 0x32c78040 1  > $DCC_PATH/config
    echo 0x32c78048 1  > $DCC_PATH/config
    echo 0x32c78050 1  > $DCC_PATH/config
    echo 0x32c79064 1  > $DCC_PATH/config
    echo 0x32c7c030 8 > $DCC_PATH/config
    echo 0x32c7c054 2 > $DCC_PATH/config
    echo 0x32c7c078 1  > $DCC_PATH/config
    echo 0x32c7c108 2 > $DCC_PATH/config
    echo 0x32c80020 1  > $DCC_PATH/config
    echo 0x32c82044 2 > $DCC_PATH/config
    echo 0x32c82090 1  > $DCC_PATH/config
    echo 0x32c820f4 2 > $DCC_PATH/config
    echo 0x32c82150 1  > $DCC_PATH/config
    echo 0x32ca600c 1  > $DCC_PATH/config
    echo 0x32ca6014 1  > $DCC_PATH/config
    echo 0x32ca6020 3 > $DCC_PATH/config
    echo 0x32ca6034 2 > $DCC_PATH/config
    echo 0x32ca6040 1  > $DCC_PATH/config
    echo 0x32ca6050 1  > $DCC_PATH/config
    echo 0x32ca6058 1  > $DCC_PATH/config
    echo 0x32ca6060 1  > $DCC_PATH/config
    echo 0x32ca6068 2 > $DCC_PATH/config
    echo 0x32ca6120 1  > $DCC_PATH/config
    echo 0x32ca6200 1  > $DCC_PATH/config
    echo 0x32ca6214 1  > $DCC_PATH/config
    echo 0x32ca7020 1  > $DCC_PATH/config
    echo 0x32ca7030 2 > $DCC_PATH/config
    echo 0x32ca7078 2 > $DCC_PATH/config
    echo 0x32ca7084 1  > $DCC_PATH/config
    echo 0x32ca7090 5 > $DCC_PATH/config
    echo 0x32ca718c 1  > $DCC_PATH/config
    echo 0x32ca71b0 1  > $DCC_PATH/config
    echo 0x32ca7204 5 > $DCC_PATH/config
    echo 0x32d0009c 1  > $DCC_PATH/config
    echo 0x32d00168 1  > $DCC_PATH/config
    echo 0x32e00080 1  > $DCC_PATH/config
    echo 0x32e00304 1  > $DCC_PATH/config
    echo 0x32e00310 1  > $DCC_PATH/config
    echo 0x32e004bc 1  > $DCC_PATH/config
    echo 0x32e00700 1  > $DCC_PATH/config
    echo 0x32e00708 5 > $DCC_PATH/config
    echo 0x32e00720 1  > $DCC_PATH/config
    echo 0x32e00740 1  > $DCC_PATH/config
    echo 0x32e00748 1  > $DCC_PATH/config
    echo 0x32e007b4 2 > $DCC_PATH/config
    echo 0x32e007d0 3 > $DCC_PATH/config
    echo 0x32e007e0 2 > $DCC_PATH/config
    echo 0x32e007f0 2 > $DCC_PATH/config
    echo 0x32e01418 4 > $DCC_PATH/config
    echo 0x32e0142c 2 > $DCC_PATH/config
    echo 0x32e01550 1  > $DCC_PATH/config
    echo 0x32e02700 2 > $DCC_PATH/config
    echo 0x32e02710 1  > $DCC_PATH/config
    echo 0x32e02718 1  > $DCC_PATH/config
    echo 0x32e02720 9 > $DCC_PATH/config
    echo 0x32e02754 9 > $DCC_PATH/config
    echo 0x32e02780 2 > $DCC_PATH/config
    echo 0x32e02790 1  > $DCC_PATH/config
    echo 0x32e03424 1  > $DCC_PATH/config
    echo 0x32e03480 1  > $DCC_PATH/config
    echo 0x32e05110 1  > $DCC_PATH/config
    echo 0x32e05130 1  > $DCC_PATH/config
    echo 0x32e05150 1  > $DCC_PATH/config
    echo 0x32e05170 1  > $DCC_PATH/config
    echo 0x32e05190 1  > $DCC_PATH/config
    echo 0x32e05210 1  > $DCC_PATH/config
    echo 0x32e05230 1  > $DCC_PATH/config
    echo 0x32e053b0 2 > $DCC_PATH/config
    echo 0x32e05804 1  > $DCC_PATH/config
    echo 0x32e0590c 1  > $DCC_PATH/config
    echo 0x32e05a14 1  > $DCC_PATH/config
    echo 0x32e05bc8 1  > $DCC_PATH/config
    echo 0x32e05be0 6 > $DCC_PATH/config
    echo 0x32e05c04 8 > $DCC_PATH/config
    echo 0x32e05c2c 8 > $DCC_PATH/config
    echo 0x32e05c50 6 > $DCC_PATH/config
    echo 0x32e05c74 22 > $DCC_PATH/config
    echo 0x32e05cdc 4 > $DCC_PATH/config
    echo 0x32e05cfc 7 > $DCC_PATH/config
    echo 0x32e06114 3 > $DCC_PATH/config
    echo 0x32e06130 4 > $DCC_PATH/config
    echo 0x32e06150 4 > $DCC_PATH/config
    echo 0x32e06170 4 > $DCC_PATH/config
    echo 0x32e06190 4 > $DCC_PATH/config
    echo 0x32e061b0 4 > $DCC_PATH/config
    echo 0x32e061d0 4 > $DCC_PATH/config
    echo 0x32e061f0 4 > $DCC_PATH/config
    echo 0x32e06728 13 > $DCC_PATH/config
    echo 0x32e0d400 1  > $DCC_PATH/config
    echo 0x32f82190 1  > $DCC_PATH/config
    echo 0x32f821dc 1  > $DCC_PATH/config
    echo 0x32f822e4 3 > $DCC_PATH/config
    echo 0x32f85190 1  > $DCC_PATH/config
    echo 0x32f851dc 1  > $DCC_PATH/config
    echo 0x32f852e4 3 > $DCC_PATH/config
    echo 0x32f865f8 1  > $DCC_PATH/config
    echo 0x32f86614 1  > $DCC_PATH/config
    echo 0x32f869fc 1  > $DCC_PATH/config
    echo 0x32f86a04 1  > $DCC_PATH/config
    echo 0x32f86a3c 1  > $DCC_PATH/config
    echo 0x32f86a44 1  > $DCC_PATH/config
    echo 0x32f86a4c 1  > $DCC_PATH/config
    echo 0x32f86a7c 1  > $DCC_PATH/config
    echo 0x32f86a84 1  > $DCC_PATH/config
    echo 0x32f86a8c 1  > $DCC_PATH/config
    echo 0x32f86b3c 1  > $DCC_PATH/config
    echo 0x32f86b44 1  > $DCC_PATH/config
    echo 0x32f86b7c 1  > $DCC_PATH/config
    echo 0x32f86c48 2 > $DCC_PATH/config
    echo 0x32f86ecc 1  > $DCC_PATH/config
    echo 0x32f86edc 1  > $DCC_PATH/config
    echo 0x32f86f10 1  > $DCC_PATH/config
    echo 0x32f86f18 1  > $DCC_PATH/config
    echo 0x32f86f20 1  > $DCC_PATH/config
    echo 0x32f86f28 1  > $DCC_PATH/config
    echo 0x32f86f58 2 > $DCC_PATH/config
    echo 0x32f86f90 1  > $DCC_PATH/config
    echo 0x32f86f98 1  > $DCC_PATH/config
    echo 0x32f86fd0 1  > $DCC_PATH/config
    echo 0x32f86fd8 1  > $DCC_PATH/config
    echo 0x32f87010 1  > $DCC_PATH/config
    echo 0x32f87444 1  > $DCC_PATH/config
    echo 0x32f8744c 2 > $DCC_PATH/config
    echo 0x32fc00c8 1  > $DCC_PATH/config
    echo 0x32fc0710 11 > $DCC_PATH/config
    echo 0x32fc0740 2 > $DCC_PATH/config
    echo 0x32fc0750 4 > $DCC_PATH/config
    echo 0x32fc0770 1  > $DCC_PATH/config
    echo 0x32fc0780 4 > $DCC_PATH/config
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
    echo 6 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 0 > $DCC_PATH/ap_ns_qad_override_en
    config_dcc_timer
    config_dcc_ddr_nonsecure
    config_dcc_qup
    config_dcc_smmu
    config_dcc_eva
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
    enable_dcc
    enable_cpuss_register
    #cpuss_spr_setup
    #sf_tracing_disablement
}

enable_debug
