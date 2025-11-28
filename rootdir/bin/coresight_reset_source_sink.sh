#!/vendor/bin/sh
#=============================================================================
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

disable_source()
{
    read value < $1
    if [ $value == "1" ]; then
       echo 0 > $1
       disable_source $1
    fi
}

dir_name="/sys/bus/coresight/devices/"
etm="coresight-ete"
if [ -d $dir_name"coresight-etm0" ]
then
	etm="coresight-etm"
elif [ -d $dir_name"ete0" ]
then
	etm="ete"
elif [ -d $dir_name"/etm0" ]
then
	etm="etm"
fi

files=$(ls -a $dir_name)
for file in $files
do
    if [ "$file" != "." ] && [ "$file" != ".." ]
    then
        if [ -e $dir_name$file"/enable_source" ]
        then
            enable_source_path=$dir_name$file"/enable_source"
            disable_source $enable_source_path
            case "$file" in
                $etm*)
                    echo 1 >$dir_name$file"/reset"
                    ;;
            esac
        fi

        if [ -e $dir_name$file"/enable_sink" ]
        then
            enable_sink_path=$dir_name$file"/enable_sink"
            echo 0 > $enable_sink_path
        fi
    fi
done

