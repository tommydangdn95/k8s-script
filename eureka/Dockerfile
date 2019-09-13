FROM tomcat

LABEL maintainer="thuydt@greenglobal.vn"
RUN mkdir -p /usr/local/tomcat/webapps/eureka
ENV EUREKA_PORT=8761 \
	EUREKA_CONTEXT_PATH=/ \
	NODE_IP=localhost
COPY server.xml /usr/local/tomcat/conf/
ADD eureka-server /usr/local/tomcat/webapps/eureka/

EXPOSE 8761