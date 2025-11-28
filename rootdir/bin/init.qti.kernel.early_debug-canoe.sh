#=============================================================================
# Copyright (c) 2022-2025 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

create_instance()
{
    local instance_dir=$1
    if [ ! -d $instance_dir ]; then
        mkdir $instance_dir
    fi
}

enable_core_events()
{
    local instance=/sys/kernel/tracing/instances/main

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    enable_sched_events
    enable_timer_events
    enable_power_events
    enable_misc_events

    echo 1 > $instance/tracing_on
}

enable_sched_events()
{
    echo 1 > $instance/events/sched/sched_migrate_task/enable
    echo 1 > $instance/events/sched/sched_pi_setprio/enable
    echo 1 > $instance/events/sched/sched_switch/enable
    echo 1 > $instance/events/sched/sched_wakeup/enable
    echo 1 > $instance/events/sched/sched_wakeup_new/enable
    if [ -d $instance/events/schedwalt ]; then
        echo 1 > $instance/events/schedwalt/halt_cpus/enable
        echo 1 > $instance/events/schedwalt/halt_cpus_start/enable
    fi
}

enable_timer_events()
{
    echo 1 > $instance/events/timer/timer_expire_entry/enable
    echo 1 > $instance/events/timer/timer_expire_exit/enable
    echo 1 > $instance/events/timer/hrtimer_cancel/enable
    echo 1 > $instance/events/timer/hrtimer_expire_entry/enable
    echo 1 > $instance/events/timer/hrtimer_expire_exit/enable
    echo 1 > $instance/events/timer/hrtimer_init/enable
    echo 1 > $instance/events/timer/hrtimer_start/enable
}

enable_power_events()
{
    echo 1 > $instance/events/power/clock_set_rate/enable
    echo 1 > $instance/events/power/clock_enable/enable
    echo 1 > $instance/events/power/clock_disable/enable
    echo 1 > $instance/events/power/cpu_frequency/enable
}

enable_misc_events()
{
    echo 1 > $instance/events/irq/enable
    echo 1 > $instance/events/workqueue/enable
    echo 1 > $instance/events/cpuhp/enable
}

enable_suspend_events()
{
    local instance=/sys/kernel/tracing/instances/suspend

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    echo 1 > $instance/events/power/suspend_resume/enable
    echo 1 > $instance/events/power/device_pm_callback_start/enable
    echo 1 > $instance/events/power/device_pm_callback_end/enable

    echo 1 > $instance/tracing_on
}

enable_cpufreq_limit_events()
{
    local instance=/sys/kernel/tracing/instances/cpufreq_limit

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    echo 1 > $instance/events/power/pm_qos_update_target/enable
    echo 1 > $instance/events/power/cpu_frequency_limits/enable

    echo 1 > $instance/tracing_on
}

enable_clock_reg_events()
{
    local instance=/sys/kernel/tracing/instances/clock_reg

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    echo 1 > $instance/events/clk/enable
    echo 1 > $instance/events/clk_qcom/enable
    echo 1 > $instance/events/interconnect/enable
    echo 1 > $instance/events/regulator/enable
    echo 1 > $instance/events/rpmh/enable

    echo 1 > $instance/tracing_on
}

enable_memory_events()
{
    local instance=/sys/kernel/tracing/instances/memory

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    #memory pressure events/oom
    #echo 1 > $instance/events/psi/psi_event/enable
    #echo 1 > $instance/events/psi/psi_window_vmstat/enable

    echo 1 > $instance/events/arm_smmu/enable

    echo 1 > $instance/tracing_on
}

enable_binder_events()
{
    local instance=/sys/kernel/tracing/instances/binder

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    echo 1 > $instance/events/binder/enable

    echo 1 > $instance/tracing_on
}

enable_rwmmio_events()
{
    if [ ! -d /sys/kernel/tracing/events/rwmmio ]
    then
        return
    fi

    local instance=/sys/kernel/tracing/instances/rwmmio

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    echo 1 > $instance/events/rwmmio/rwmmio_read/enable
    echo 1 > $instance/events/rwmmio/rwmmio_write/enable

    echo 1 > $instance/tracing_on
}

enable_thermal_events()
{
    local instance=/sys/kernel/tracing/instances/thermal

    create_instance $instance
    echo > $instance/trace
    echo > $instance/set_event

    echo 1 > $instance/events/thermal/enable
    echo 1 > $instance/tracing_on
}

find_build_type()
{
    linux_banner=`cat /proc/version`
    if [[ "$linux_banner" == *"-debug"* ]]; then
        debug_build=true
    fi
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
debug_build=false
enable_tracing_events()
{
    find_build_type
    if [ "$debug_build" = false ]; then
        return
    fi

    if [ ! -d /sys/kernel/tracing/events ]; then
        return
    fi

    if [ "$ftrace_disable" = "Yes" ]; then
        return
    fi

    enable_core_events
    enable_suspend_events
    enable_binder_events
    enable_clock_reg_events
    enable_memory_events
    enable_rwmmio_events
    enable_thermal_events
    enable_cpufreq_limit_events
}

enable_tracing_events
