#
# Originally written for Fincore by
#   Marcelle von Wendland <mvw@fincore.com>

FROM centos:centos6
MAINTAINER Fincore Ltd - Marcelle von Wendland <mvw@fincore.com>

# Pre-requirements
RUN mkdir -p /run/lock/subsys

RUN yum install -y libaio 
RUN yum clean all
RUN yum update -y

### Install Oracle XE
ADD disk1/oracle-xe-11.2.0-1.0.x86_64.rpm /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm

RUN yum localinstall -y /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm
RUN rm -rf /tmp/img/oracle-xe-11.2.0-1.0.x86_64.rpm

ADD test.sql init.ora initXETemp.ora disk1/response/xe.rsp /u01/app/oracle/product/11.2.0/xe/config/scripts/

RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
RUN chmod 755        /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

RUN /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

# Run script
ADD start.sh /
RUN chmod +x  start.sh

### Install JDK
ADD disk1/jdk-8u101-linux-x64.rpm  /tmp/jdk-8u101-linux-x64.rpm
RUN yum localinstall -y  /tmp/jdk-8u101-linux-x64.rpm

### Install Scala
ADD disk1/scala-2.11.8.rpm /tmp/scala-2.11.8.rpm
RUN yum localinstall -y /tmp/scala-2.11.8.rpm

### Install sbt
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install sbt -y

### Install epel
RUN yum install epel-release -y

### Cleanup/update
RUN yum clean all
RUN yum update -y

### Install node-js
RUN yum install nodejs -y

### Install npm
RUN yum install npm -y

### Install ruby
RUN yum install ruby -y
RUN yum install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel -y -t
RUN yum install rubygems -y

### Install grunt
RUN npm install -g grunt-cli
RUN npm install grunt --save-dev

###
RUN yum install yum-utils bzip2 bzip2-devel wget curl tar -y -t
RUN yum groupinstall "Development Tools" -y -t

### Install bower
RUN npm install bower -g

### Install gulp
RUN npm install gulp -g

### Install cmake
RUN yum install cmake -y

### Install 
RUN yum install zlib-devel -y

### Install 
RUN yum install bzip2-devel -y

### Install 
RUN yum install openssl-devel -y

### Install 
RUN yum install ncurses-devel -y

### Install 
RUN yum install sqlite-devel -y

### Install 
RUN yum install -y centos-release-SCL

### Install 
RUN yum install -y python27

### Install mysql - commented out
#RUN yum install mysql -y

### Cleanup/update
RUN yum clean all
RUN yum update -y

### Install 
RUN yum -y install python-pip

### Install 
RUN yum install git -y

### Install 
RUN yum install golang -y

### Install 
RUN pip install --upgrade setuptools
RUN pip install --upgrade pip

#RUN pip install supervisor

### Cleanup/update
RUN yum clean all
RUN yum update -y

### Install maven
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install apache-maven -y

### Cleanup/update
RUN yum clean all
RUN yum update -y

### Ports
EXPOSE 3306
EXPOSE 1521
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084
EXPOSE 80
EXPOSE 4040
EXPOSE 4041
EXPOSE 7076
EXPOSE 7077
EXPOSE 9000

RUN mvn -version
RUN java -version

### Spark
RUN git clone https://automyse:Aw3s0m32@github.com/Fincore/autospark.git /var/autospark

ADD autospark.sh /var/autospark
WORKDIR /var/autospark
RUN chmod +x  /var/autospark/autospark.sh
RUN bash /var/autospark/autospark.sh

### Oracle repo
RUN mkdir -p /var/oracle
RUN chown oracle:dba /var/oracle

USER oracle

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

RUN git clone https://automyse:Aw3s0m32@github.com/Fincore/autorepo.git /var/oracle/autorepo

WORKDIR /var/oracle/autorepo
RUN /var/oracle/autorepo/install_xe_docker.sh init

USER root
WORKDIR /
ADD sudoers /
RUN chown -R root:root sudoers
RUN groupadd fincore
RUN useradd -g fincore  fincore
RUN yum update -y
RUN yum install sudo -y
RUN yum update -y
RUN cp sudoers /etc/sudoers

#ADD ivy2/  /tmp/ivy2/
#RUN cp -r /tmp/ivy2  /home/fincore/.ivy2

### Query hub
RUN git clone https://automyse:Aw3s0m32@github.com/Fincore/FDM3-dev.git /var/automyse

USER fincore
WORKDIR /var/automyse/portal/queryhub/ui/
RUN npm update
#RUN bower install  --allow-root
#RUN bower update  --allow-root
WORKDIR /var/automyse/portal/queryhub/

#ADD .ivy2/  /tmp/ivy22/
#RUN cp -r /tmp/ivy22  /home/fincore/.ivy2
#RUN chown -R fincore:fincore /var/automyse
#RUN chown -R fincore:fincore /home/fincore

#RUN pwd
#RUN id

USER root
WORKDIR /

ADD bash_profile /
COPY bash_profile /home/fincore/.bash_profile

ADD automyse.sh /
COPY automyse.sh /var/automyse/portal/queryhub/automyse.sh
RUN chmod +x /automyse.sh

WORKDIR /var/automyse/

ENV HOME /home/fincore

WORKDIR /var/
RUN git clone https://github.com/vonwenm/play-yeoman.git
WORKDIR /var/play-yeoman/play-yeoman
RUN sbt clean publishLocal
WORKDIR /var/play-yeoman/sbt-yeoman
RUN sbt clean publishLocal

#WORKDIR /
#RUN bash prepjar.sh

#WORKDIR /var/automyse/portal/queryhub/
#RUN chmod +x  activator
#ENV HOME /home/fincore
#RUN ./activator reload plugins
#RUN ./activator update
#RUN ./activator clean
#RUN ./activator publishLocal 

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID XE
ENV PATH        $ORACLE_HOME/bin:$PATH
ENV SPARK_HOME /var/autospark/
ENV SPARK_CLASSPATH /var/autospark/assembly/target/scala-2.11/jars/
ENV SPARK_LOCAL_HOSTNAME localhost
ENV JAVA_OPTS "-Duser.timezone=GMT -Djavax.xml.parsers.DocumentBuilderFactory=com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl -Djavax.xml.parsers.SAXParserFactory=com.sun.org.apache.xerces.internal.jaxp.SAXParserFactoryImpl -Djavax.xml.transform.TransformerFactory=com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl"

#WORKDIR /var/automyse/portal/queryhub/ui/
#RUN npm update
#RUN bower install  --allow-root
#RUN bower update  --allow-root

WORKDIR /
#ADD supd3.conf  /
#COPY supd3.conf /etc/supervisord.conf

#ADD   listener.ora  /
#COPY  listener.ora  /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
#ADD   tnsnames.ora  /
#COPY  tnsnames.ora  /u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora

RUN pip install supervisor

RUN chmod +x  /var/autospark/sbin/*
RUN chmod +x  /var/autospark/bin/*

RUN cp /var/autospark/assembly/target/scala-2.11/jars/* /var/automyse/portal/queryhub/lib
RUN cp -f /var/automyse/portal/queryhub/conf/application.conf.docker /var/automyse/portal/queryhub/conf/application.conf

RUN chmod +x  /var/automyse/portal/queryhub/*
WORKDIR /var/automyse/portal/queryhub/
RUN ./activator compile

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]

