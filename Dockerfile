#
# Originally written for Fincore by
#   Marcelle von Wendland <mvw@fincore.com>

FROM centos:centos6
MAINTAINER Fincore Ltd - Marcelle von Wendland <mvw@fincore.com>

# Use the OEL6 base image
FROM oel6-base:6.5

# Maintainer of the image
MAINTAINER Rob den Braber

# Install the packages libaio and bc
RUN yum install -y libaio bc

# Copy the RPM file, modified init.ora, initXETemp.ora and the installation response file
# inside the image
ADD Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm
ADD init.ora /tmp/init.ora
ADD initXETemp.ora /tmp/initXETemp.ora
ADD Disk1/response/xe.rsp /tmp/xe.rsp

# Install the Oracle XE RPM
RUN yum localinstall -y /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm

# Delete the Oracle XE RPM
RUN rm -f /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm

# move the files init.ora and initXETemp.ora to the right directory
RUN mv /tmp/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
RUN mv /tmp/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts

# Configure the database
RUN /etc/init.d/oracle-xe configure responseFile=/tmp/xe.rsp

# Create entries for the database in the profile
RUN echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/profile.d/oracle_profile.sh
RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/profile.d/oracle_profile.sh
RUN echo 'export ORACLE_SID=XE' >> /etc/profile.d/oracle_profile.sh

# Create ssh keys and change some ssh settings
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

# Change the root and oracle password to oracle
RUN echo root:oracle | chpasswd
RUN echo oracle:oracle | chpasswd

# Expose ports 22, 1521 and 8080
EXPOSE 22
EXPOSE 1521
EXPOSE 8080

# Change the hostname in the listener.ora file, start Oracle XE and the ssh daemon
CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora; \
service oracle-xe start; \
/usr/sbin/sshd -D