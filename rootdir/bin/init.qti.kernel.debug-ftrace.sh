#Enable various subsystem ftrace debugging events
tracefs=/sys/kernel/tracing
version_mode=`getprop ro.oplus.image.my_engineering.type`

chmod 0755 /sys/kernel/tracing

if [ -d $tracefs ]; then
mkdir $tracefs/instances/main
testmodule=$tracefs/instances/main
testevents=$tracefs/instances/main/events
#disable
echo 0 > $testmodule/tracing_on
#set buffer size
echo 16384 > $testmodule/buffer_size_kb
if [ $version_mode = "preversion" ]; then
	echo 255 > $testmodule/buffer_size_kb
fi
echo "" > $testmodule/set_event
echo "" > $testmodule/trace

#set your ftrace options, ex:sched
#timer
echo 1 > $testevents/timer/timer_expire_entry/enable
echo 1 > $testevents/timer/timer_expire_exit/enable
echo 1 > $testevents/timer/hrtimer_cancel/enable
echo 1 > $testevents/timer/hrtimer_expire_entry/enable
echo 1 > $testevents/timer/hrtimer_expire_exit/enable
echo 1 > $testevents/timer/hrtimer_init/enable
echo 1 > $testevents/timer/hrtimer_start/enable

#schedular
echo 1 > $testevents/sched/sched_blocked_reason/enable
echo 1 > $testevents/sched/sched_stat_blocked/enable
echo 1 > $testevents/sched/sched_stat_iowait/enable
echo 1 > $testevents/sched/sched_wakeup/enable
echo 1 > $testevents/sched/sched_switch/enable
echo 1 > $testevents/sched/sched_migrate_task/enable
echo 1 > $testevents/sched/sched_pi_setprio/enable
echo 1 > $testevents/sched/sched_wakeup_new/enable

#softirq
echo 1 > $testevents/irq/enable

#workqueue
echo 1 > $testevents/workqueue/enable
echo 1 > $testevents/workqueue/workqueue_execute_start/enable

#power
echo 1 > $testevents/power/cpu_frequency/enable
echo 1 > $testevents/power/cpu_frequency_limits/enable
echo 1 > $testevents/thermal/thermal_power_cpu_limit/enable

#clock
echo 1 > $testevents/power/clock_set_rate/enable
echo 1 > $testevents/power/clock_enable/enable
echo 1 > $testevents/power/clock_disable/enable
echo 1 > $testevents/power/cpu_frequency/enable

#regulator
echo 1 > $testevents/regulator/enable

#fastrpc
echo 1 > $testevents/fastrpc/enable

#sched
echo 1 > $testevents/cpuhp/enable
echo 1 > $testevents/thermal/thermal_power_cpu_limit/enable
echo 1 > $testevents/thermal/thermal_temperature/enable
echo 1 > $testevents/thermal_pressure/enable

#enable
echo 1 > $testmodule/tracing_on
fi

