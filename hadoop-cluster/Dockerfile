# build a new hadoop image with basic  centos 
FROM centos
# who is the author  
MAINTAINER hshe

####################Configurate JDK################################
# 安装ssh(集群必要)，iproute（内涵各种网络命令），which（没有这个命令，在执行hadoop的一些命令的时候就会报错）
# 同时建立存放JDK的目录
RUN yum -y install openssh-server openssh-clients  iproute  which  &&  mkdir /usr/local/java

# 通过ADD指令将JDK复制到，ADD这个指令会将压缩包自动解压
ADD jdk-7u79-linux-x64.tar.gz /usr/local/java/

###################Configurate SSH#################################
# 生成必要的host key文件，否则，/usr/sbin/sshd将无法启动
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' &&  ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' &&  ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' 

# 配置无密码登陆到本机，首相生成公私钥对，然后建立authorized_keys文件
RUN ssh-keygen -f /root/.ssh/id_rsa -N '' &&  cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys


###################Configurate Hadoop##############################
# 将hadoop软件包copy到镜像中，同时会自动解压
ADD hadoop-2.6.5.tar.gz /usr/local/

# 建立hadoop文件夹的软连接
RUN ln -s /usr/local/hadoop-2.6.5 /usr/local/hadoop

# 复制编辑好的配置文件到镜像中去，会直接覆盖镜像中原有的文件
COPY core-site.xml /usr/local/hadoop/etc/hadoop/
COPY hdfs-site.xml /usr/local/hadoop/etc/hadoop/
COPY mapred-site.xml /usr/local/hadoop/etc/hadoop/
COPY yarn-site.xml /usr/local/hadoop/etc/hadoop/
COPY slaves /usr/local/hadoop/etc/hadoop/

# 重新设置hadoop-env.sh中的JAVA_HOME变量，否则将无法正常启动集群
# 配置ssh_config文件中： StrictHostKeyChecking no， 可以消除ssh，scp等访问时询问yes/no。
# 配置sshd_config 文件中， UseDNS no ， UseDNS 的默认值为 yes。 配置为no之后可以加速ssh，scp链接速度。
RUN sed -i "s?JAVA_HOME=\${JAVA_HOME}?JAVA_HOME=/usr/local/java/jdk?g" /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
 sed -i "s?#\s\+StrictHostKeyChecking\s\+ask?StrictHostKeyChecking no?g" /etc/ssh/ssh_config  && \
 sed -i "s?#UseDNS yes?UseDNS no?g" /etc/ssh/sshd_config 

################### Integration configuration #######################
# 这里配置镜像的环境变量，但是这样设置的环境变量只能在运行时使用/bin/bash时才会生效。当用ssh登录到容器后，这些变量将失效（坑爹的玩意）
ENV JAVA_HOME /usr/local/java/jdk
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH ${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${JAVA_HOME}/bin:$PATH
# 当用ssh登录到容器后，上述设置的变量将失效，为了能够在ssh登陆时也能使用这些变量，将这些变量加入到root账户的.bash_profile文件中。
# 而且还有比较坑的是，export JRE_HOME=/usr/local/java/jdk/jre 不能写成 export JRE_HOME=${JAVA_HOME}/jre。其它的也是同理，所以一下配置中都是从绝对路径写起。（多么痛的领悟）
RUN ln -s /usr/local/java/jdk1.7.0_79 /usr/local/java/jdk && \
 echo "export JAVA_HOME=/usr/local/java/jdk" >> /root/.bash_profile && \
 echo "export JRE_HOME=/usr/local/java/jdk/jre" >> /root/.bash_profile && \
 echo "export CLASSPATH=.:/usr/local/java/jdk/lib:/usr/local/java/jdk/jre/lib" >> /root/.bash_profile && \
 echo "export HADOOP_HOME=/usr/local/hadoop" >> /root/.bash_profile && \
 echo "export PATH=/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/java/jdk/bin:$PATH" >> /root/.bash_profile

# 设置root账户的密码
RUN echo "root:hadoop" | chpasswd
# 设置容器启动时未指定要执行的时候，默认要的执行的命令
CMD ["/usr/sbin/sshd","-D"]
