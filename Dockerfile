# Installation procedure documented here:
# https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-and-Update-via-APT-on-Debian-or-Ubuntu

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# Install prerequisite packages
RUN apt-get update -qq && apt-get install -qq -y \
    ca-certificates \
    apt-transport-https \
    wget \
    gnupg2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add Ubiquiti repository source
RUN echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' > /etc/apt/sources.list.d/100-ubnt-unifi.list
# "ADD" would theoricaly do the job, but messes access rights
RUN wget -qO /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg 

# Add mongodb repository source
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | apt-key add -
RUN echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.4.list

# Prevent services from starting at installation
RUN echo exit 0 > /usr/sbin/policy-rc.d

# Install Unifi-Controller
RUN apt-get update -qq \
    && apt-mark hold openjdk-11-* openjdk-17-* \
    && apt-get install -qq -y \
       openjdk-8-jre-headless \
       unifi \
    && apt-get clean \
    && rm -rf /var/lib/apt/list/*

VOLUME /var/lib/unifi

EXPOSE 8080 8443
# Are these really needed?
# EXPOSE 3478/udp 8880 8843 6789 27117 5656-5699/udp 10001/udp 1900/udp

CMD ["/usr/bin/jsvc", "-nodetach" , "-home", "/usr/lib/jvm/java-8-openjdk-amd64", "-cp", "/usr/share/java/commons-daemon.jar:/usr/lib/unifi/lib/ace.jar", "-pidfile", "/var/run/unifi/unifi.pid", "-procname", "unifi", "-outfile", "/dev/stdout", "-errfile", "/dev/stderr", "-Djava.awt.headless=true", "-Dfile.encoding=UTF-8", "-Xmx1024M", "com.ubnt.ace.Launcher", "start"]
