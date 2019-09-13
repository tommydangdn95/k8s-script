#!/bin/sh

# number of container
# run this file after create all pods

range=3
for (( index=$range-1; index>=0; index-- ))
do
   	pod_name="kafka-ss-$index"
    kubectl exec -it $pod_name /home/script.sh
    echo "done pod $pod_name"
done

