FROM ubuntu:16.04

LABEL maintainer="thuydt@greenglobal.vn"
RUN apt-get -qq update && apt-get install -qqy wget 
RUN apt-get install -qqy default-jre net-tools iputils-ping netcat telnet curl dnsutils nano
# RUN apt-get install -qqy net-tools
# RUN apt-get install -qyy iputils-ping
# RUN apt-get install -qyy netcat
# RUN apt-get install -qyy telnet
# RUN apt-get install -qyy curl
# RUN apt-get install -qyy dnsutils
# RUN apt-get install -qqy nano

# get zookeeper file
RUN wget http://mirror.downloadvn.com/apache/zookeeper/stable/zookeeper-3.4.12.tar.gz
RUN mkdir -p /etc/zookeeper
RUN mkdir -p /data
RUN tar -xvzf zookeeper-3.4.12.tar.gz --directory /etc/zookeeper --strip-components 1
COPY zoo.cfg /etc/zookeeper/conf/zoo.cfg

# get kafka file
RUN wget http://mirror.downloadvn.com/apache/kafka/2.1.0/kafka_2.11-2.1.0.tgz
RUN mkdir /opt/kafka
RUN tar -xvzf kafka_2.11-2.1.0.tgz --directory /opt/kafka --strip-components 1

COPY kafka-script.sh kafka-script.sh
EXPOSE 9092
ENTRYPOINT ./kafka-script.sh && bash