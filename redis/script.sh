	#!/bin/sh
    # Get index hostname
    number=${HOSTNAME//[!0-9]/}
    # Save hostname
    hostname=redis-ss-master-0.redis-svc-master.default.svc.cluster.local

    # Get ip from master
    ip="$(getent hosts $hostname | awk '{ print $1 }')"
    # cp redis-sentinel to data folder
    cp /mnt/sentinel.conf /data
    cp /mnt/slave.conf /data
    cp /mnt/master.conf /data
    # replace string ip_master sentinel.conf and slave.conf
    sed -i "s/ip_master/$ip/g" /data/sentinel.conf
    sed -i "s/ip_master/$ip/g" /data/slave.conf

    # if Pod is even copy master.conf and odd copy slave.conf
    if [ $number -eq 0 ]; 
    then
        redis-server /data/master.conf;
    else
        redis-server /data/slave.conf;
    fi

    # run redis-sentinel
    redis-sentinel /data/sentinel.conf;
