FROM openshift/base-centos7
#FROM nalaki/centos7-maven:v1

 #MAINTAINER Tobias Brunner <tobias.brunner@vshn.ch>

ENV MAVEN_VERSION=3.6.0
ARG S2IDIR="/home/s2i"
ARG APPDIR="/deployments"

# Docker Image Metadata
LABEL io.k8s.description="Platform for building (Maven) and running plain Java applications" \
      io.k8s.display-name="Java Applications" \
      io.openshift.tags="builder,java,maven" \
      io.openshift.expose-services="8080" \
      org.jboss.deployments-dir="/deployments"

# Install Java
RUN INSTALL_PKGS="java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/s2i/destination
RUN yum install maven -y
# S2I scripts
COPY ./s2i/bin/ /usr/libexec/s2i
# Install Maven
#RUN wget -q http://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz && \
#    mkdir /opt/maven && \
#    tar xzf apache-maven-3.6.0-bin.tar.gz -C /opt/maven && \
#    rm apache-maven-3.6.0-bin.tar.gz && \
#    ln -s /opt/maven/apache-maven-3.6.0/bin/mvn /usr/local/bin/mvn

# Maven settings.xml
#COPY ./settings.xml /opt/maven/apache-maven-3.6.0/conf
COPY ./settings.xml /usr/share/maven

RUN chown -R 1001:1001 ./
#opt/app-root
USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
