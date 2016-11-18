FROM centos:7
 
#install Package
RUN yum install -y wget vim
RUN wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
RUN yum -y groupinstall development
RUN yum install -y openssh-server lrzsz unzip net-tools bind-utils python-pip
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install python35u-3.5.2 python35u-pip python35u-devel
RUN mkdir -p ~/.pip
ADD pip.conf ~/.pip
RUN pip install -U pip
RUN pip install -U supervisor

#set sshd
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh
RUN echo 'root:docker' | chpasswd

#set hole
ADD holed /usr/bin
RUN chmod +x /usr/bin/holed

#set supervisor
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisord.conf

#set port
EXPOSE 22
EXPOSE 5188
  
#run supervisor
CMD ["/usr/bin/supervisord"]
