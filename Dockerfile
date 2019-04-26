FROM fabric8/java-centos-openjdk8-jdk:1.5.1

MAINTAINER rhuss@redhat.com

EXPOSE 8080

ENV TOMCAT_VERSION 8.5.32
ENV DEPLOY_DIR /maven

USER root

# Agent bond including Jolokia and jmx_exporter
ADD tomcat_conf/agent-bond-opts /opt/run-java-options
RUN mkdir -p /opt/agent-bond \
 && curl http://central.maven.org/maven2/io/fabric8/agent-bond-agent/1.2.0/agent-bond-agent-1.2.0.jar \
          -o /opt/agent-bond/agent-bond.jar \
 && chmod 444 /opt/agent-bond/agent-bond.jar \
 && chmod 755 /opt/run-java-options
ADD tomcat_conf/jmx_exporter_config.yml /opt/agent-bond/
EXPOSE 8778 9779


# Get and Unpack Tomcat
RUN curl http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -o /tmp/catalina.tar.gz \
 && tar xzf /tmp/catalina.tar.gz -C /opt \
 && ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat \
 && chown -R jboss /opt/tomcat /opt/apache-tomcat-${TOMCAT_VERSION} \
 && rm /tmp/catalina.tar.gz

# Add roles
ADD tomcat_conf/tomcat-users.xml /opt/apache-tomcat-${TOMCAT_VERSION}/conf/

# Change to remote host connection 
ADD tomcat_conf/context.xml /opt/apache-tomcat-${TOMCAT_VERSION}/webapps/manager/META-INF

# Add target war file in tomcat 
ADD target/petclinic*.war /opt/apache-tomcat-${TOMCAT_VERSION}/webapps/petclinic.war

# Startup script
ADD tomcat_conf/deploy-and-run.sh /opt/apache-tomcat-${TOMCAT_VERSION}/bin/

RUN chmod 755 /opt/apache-tomcat-${TOMCAT_VERSION}/bin/deploy-and-run.sh \
 && rm -rf /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs  \
 && chgrp -R 0 /opt/tomcat/webapps \
 && chmod -R g=u /opt/tomcat/webapps

VOLUME [ "/opt/tomcat/logs", "/opt/tomcat/work", "/opt/tomcat/temp", "/tmp/hsperfdata_root" ]

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

CMD /opt/tomcat/bin/deploy-and-run.sh

USER jboss
