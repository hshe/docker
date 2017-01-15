#!/usr/bin/expect -f

set addr [lrange $argv 0 0]
set source_name [lrange $argv 1 1]
set dist_name [lrange $argv 2 2]
set password hadoop

spawn scp $source_name  root@$addr:$dist_name
set timeout 30
expect {
  "yes/no" { send "yes\r"; exp_continue}
  "password:" { send "$password\r" }
}
send "exit\r"
expect eof 
