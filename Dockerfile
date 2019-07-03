FROM library/ubuntu:16.04
RUN apt-get update && apt-get install -y -f \
    wget \
    openjdk-8-jre-headless \
    gnupg \
    curl \
    libcap2 \
    binutils \
    jsvc \
    mongodb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo exit 0 > /usr/sbin/policy-rc.d
#RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
RUN export DEBIAN_FRONTEND="noninteractive"
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
RUN wget https://dl.ubnt.com/unifi/5.10.25/unifi_sysvinit_all.deb; \ 
    dpkg -i unifi_sysvinit_all.deb

#COPY unifi.init /usr/lib/unifi/bin/unifi.init
#RUN chmod +x /usr/lib/unifi/bin/unifi.init
#RUN mkdir /var/log/unifi
RUN ln -s /dev/stdout /var/log/unifi/server.log
RUN ln -s /dev/stdout /var/log/unifi/mongod.log

EXPOSE 3478/udp
EXPOSE 8080
EXPOSE 8443
EXPOSE 8880
EXPOSE 8843
EXPOSE 6789
EXPOSE 27117
EXPOSE 5656-5699/udp
EXPOSE 10001/udp
EXPOSE 1900/udp


CMD ["/usr/bin/jsvc", "-nodetach" , "-home", "/usr/lib/jvm/java-8-openjdk-amd64", "-cp", "/usr/share/java/commons-daemon.jar:/usr/lib/unifi/lib/ace.jar", "-pidfile", "/var/run/unifi/unifi.pid", "-procname", "unifi", "-outfile", "SYSLOG", "-errfile", "SYSLOG", "-Djava.awt.headless=true", "-Dfile.encoding=UTF-8", "-Xmx1024M", "com.ubnt.ace.Launcher", "start"]