FROM tomcat

LABEL maintainer="thuydt@greenglobal.vn"
RUN mkdir -p /usr/local/tomcat/webapps/zuul
ENV ZUUL_PORT=8085 \
	EUREKA_IP=localhost
COPY server.xml /usr/local/tomcat/conf/
ADD zuul /usr/local/tomcat/webapps/zuul/

EXPOSE 8085