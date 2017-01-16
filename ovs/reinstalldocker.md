uninstall4centos7
```Ruby
rpm -qa | grep docker
rpm -e docker-common-1.10.3-59.el7.centos.x86_64
rpm -qa | grep container
rpm -e container-selinux-1.10.3-59.el7.centos.x86_64 (old version's dependency)

```
@update yum rep
```Ruby
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

```
then 
```Ruby
yum install docker-engine 
```

