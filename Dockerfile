
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

# Install Oracle XE
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


ADD disk1/jdk-8u73-linux-x64.rpm  /tmp/jdk-8u73-linux-x64.rpm
RUN yum localinstall -y  /tmp/jdk-8u73-linux-x64.rpm

ADD disk1/scala-2.11.8.rpm /tmp/scala-2.11.8.rpm
RUN yum localinstall -y /tmp/scala-2.11.8.rpm

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install sbt -y

RUN yum install epel-release -y
RUN yum clean all
RUN yum update -y

RUN yum install nodejs -y

RUN yum install npm -y

RUN yum install ruby -y
RUN yum install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel -y -t
RUN yum install rubygems -y

RUN npm install -g grunt-cli
RUN npm install grunt --save-dev

RUN yum install yum-utils bzip2 bzip2-devel wget curl tar -y -t
RUN yum groupinstall "Development Tools" -y -t

RUN npm install bower -g
RUN npm install gulp -g

RUN yum install cmake -y

RUN yum install zlib-devel -y
RUN yum install bzip2-devel -y
RUN yum install openssl-devel -y
RUN yum install ncurses-devel -y
RUN yum install sqlite-devel -y


RUN yum install -y centos-release-SCL
RUN yum install -y python27

RUN yum install mysql -y

RUN yum clean all
RUN yum update -y

RUN yum -y install python-pip

RUN yum install git -y

RUN yum install golang -y

RUN pip install --upgrade setuptools
RUN pip install --upgrade pip

RUN pip install supervisor

RUN git clone https://automyse:Aw3s0m32@github.com/Fincore/FDM3-dev.git /var/automyse

RUN yum clean all
RUN yum update -y

COPY supervisord.conf /etc/supervisord.conf
EXPOSE 3306
EXPOSE 1521
EXPOSE 8080
EXPOSE 80
#CMD mysql --user=AUTOMYSE --password='Aw3s0m32' --host=127.0.0.1
#CMD mysql --user=AUTOMYSE --password='Aw3s0m32' --host=172.17.42.1
#CMD mysql --user=AUTOMYSE --password='Aw3s0m32' --host=217.174.253.94 
#CMD mysql --user=AUTOMYSE --password='Aw3s0m32' --host=217.174.253.94 < /u01/app/oracle/product/11.2.0/xe/config/scripts/test.sql
#CMD /start.sh
#CMD ["/usr/bin/supervisord"]
CMD bash /var/automyse/portal/queryhub/activator "run Dhttp.address=0.0.0.0 -Dhttp.port=80"
 