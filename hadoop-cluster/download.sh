#!/usr/bin/expect -f

# 第一个参数为ip地址
set addr [lrange $argv 0 0]
# 第二个参数为 要下载的文件的完整路径名
set source_name [lrange $argv 1 1]
# 保存到本地的位置或者是新名字
set dist_name [lrange $argv 2 2]
set password hadoop

spawn scp root@$addr:$source_name ./$dist_name
set timeout 30
expect {
  "yes/no" { send "yes\r"; exp_continue}
  "password:" { send "$password\r" }
}
send "exit\r"
expect eof 
