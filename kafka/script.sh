    #!/bin/bash
    #create another folder for permittion config map
    mkdir /app
    cp /home/server.properties /app
    cp /home/myid /app
    cp /home/zoo.cfg /app

    echo "oke create app"

    # Get index host pod
    number=${HOSTNAME//[!0-9]/}

    # set hostname pod base
    host_pod=kafka-ss-

    # set range pod
    range=2

    # port zookeeper map kafka
    port_z=":2181"

    # port broker map cluster kafka
    port_broker=":9092"

    # port for zoo.conf specify all zookeeper servers
    port_zconf=":2888:3888"

    # dns name service
    dns_name=".kafka-svc.default.svc.cluster.local"

    # init list string ip
    list_ip=""

    # init list string ip kafka
    list_ip_broker=""

    # loop set ip 
    for (( index=0; index<$range; index++ ))
    do  
       # get hostname with index
       hostname_pod="$host_pod$index"

       # get hostname with dns-name ex:kafka-ss-0.kafka-svc.default.svc.cluster.local
       resolve_name="$hostname_pod$dns_name"

       # get resolve ip
       ip="$(getent hosts $resolve_name | awk '{ print $1 }')"
       echo "oke get ip $ip"

       # complete ip with port zookeeper map kafka
       ipmap_z="$ip$port_z"
        # complete ip with port zookeeper conf
       ipmap_zconf="$ip$port_zconf"

       # complete ip with port kafka 
       ipmap__kafka_broker="$ip$port_broker"

        # function concat string
        function join_by() { 
            local d=$1; 
            shift; 
            echo -n "$1"; 
            shift; 
            printf "%s" "${@/#/$d}"; 
        }

       # join string ex:192.168.1.191:2181,192.168.1.192:2181
       list_ip=$(join_by , $list_ip $ipmap_z)
       
       # join string ex:192.168.1.191:9092,192.168.1.192:9092
       list_ip_broker=$(join_by , $list_ip_broker $ipmap__kafka_broker)

       # add specify all zookeeper servers
       server="server.$index=$ipmap_zconf"
       echo -e "\n$server" >> /app/zoo.cfg
       echo $server
    done

    # replace ip_host by ip of host node for consumer listeners
    sed -i "s/node_ip/$NODE_IP/g" /app/server.properties
    echo "oke replace node_ip $NODE_IP"
    
    # replace pod_ip by ip of pod ip for consumer listeners
    sed -i "s/pod_ip/$POD_IP/g" /app/server.properties
    echo "oke replace pod_ip $POD_IP"
    
    # replace id broker
    sed -i "s/id_kafka/$number/g" /app/server.properties
    echo "oke replace id_broker $number"

    # replace list_ip_connect
    sed -i "s/list_ip_connect/$list_ip/g" /app/server.properties
    echo "oke replace list_ip_connect $list_ip"

    # replace list_broker_ip
    sed -i "s/list_broker_ip/$list_ip_broker/g" /app/server.properties
    echo "oke replace list_broker_ip $list_ip_broker"

    # replace id_broker myid zookeeper
    sed -i "s/id_broker/$number/g" /app/myid
    echo "oke replace id_broker myid $number"
    # -------- done replace string------ 

    # replace zookeeper first
    bash /opt/kafka/bin/kafka-server-stop.sh /opt/kafka/config/server.properties

    # rm old file conf
    rm /etc/zookeeper/conf/zoo.cfg

    # copy new file
    cp /app/myid /data/
    cp /app/zoo.cfg /etc/zookeeper/conf

    # replace kafka
    # rm ole file conf
    bash /etc/zookeeper/bin/zkCli.sh -server localhost:2181 delete /brokers/ids/0
    rm -rf /tmp/kafka-logs/.lock
    rm -rf /tmp/kafka-logs/meta.properties
    bash /opt/kafka/bin/kafka-server-stop.sh /opt/kafka/config/server.properties
    echo "remove folder kafka-logs and remove broker id 0"

    # restart service
    # restart zookeeper
    cd /etc/zookeeper/conf
    bash /etc/zookeeper/bin/zkServer.sh restart /etc/zookeeper/conf/zoo.cfg

    # copy new file kafka
    cp /app/server.properties /opt/kafka/config/

    chmod -R 777 /opt/kafka/bin/kafka-server-start.sh
    bash /opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties
    echo "starting kafka "
    exit 0