FROM apsl/circusbase:latest

# Upload and install Oracle JDK 1.6.0_22.
ADD jdk-6u22-linux-x64.bin /
RUN chmod a+x jdk-6u22-linux-x64.bin
RUN ./jdk-6u22-linux-x64.bin
RUN mkdir /opt/jdk && mv jdk1.6.0_22 /opt/jdk

# Set environment variables.
ENV JAVA_HOME /opt/jdk/jdk1.6.0_22
ENV PATH $PATH:$JAVA_HOME/bin

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TOMCAT_MAJOR_VERSION 6
ENV TOMCAT_MINOR_VERSION 6.0.26
ENV CATALINA_HOME /opt/tomcat

# INSTALL TOMCAT
WORKDIR /
ADD https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz /
RUN \
    tar zxf apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    rm apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_MINOR_VERSION} /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin
VOLUME ["/opt/tomcat/logs", "/opt/tomcat/work", "/opt/tomcat/temp", "/tmp/hsperfdata_root" ]

# Remove unneeded apps
RUN \
   rm -rf /opt/tomcat/webapps/host-manager ; \
   rm -rf /opt/tomcat/webapps/examples  ;\
   rm -rf /opt/tomcat/webapps/docs/ ;\
   rm -rf /opt/tomcat/webapps/ROOT

# tomcat conf
ADD conf/tomcat-users.xml.tpl /opt/tomcat/conf/
ADD conf/server.xml.tpl /opt/tomcat/conf/
# tomcat wrapper called from circus
ADD tomcat_wrapper.sh /opt/tomcat/bin/
# circusd tomcat conf
ADD circus.d/tomcat.ini.tpl /etc/circus.d/
# tomcat and circus setup script
ADD setup.d/setup-tomcat /etc/setup.d/

RUN \
    useradd -u 500 -d /opt/tomcat -s /usr/sbin/nologin tomcat && \
    chown tomcat.tomcat /opt/tomcat -R 

ADD app /app

EXPOSE 8080
