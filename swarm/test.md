3.4.2 rng服务压力测试
```
介绍完负载均衡模式, 下面使用ab对我们的rng服务进行简单的压力测试.
测试之前, 我们要关掉所有的worker服务, 避免worker服务影响测试结果.
# docker service scale worker=0
worker scaled to 0
# docker service ls
ID            NAME      REPLICAS  IMAGE                                   COMMAND
...
d7g0estex65u  worker    0/0       localhost:5000/dockercoins_worker:v0.1

回到我们的debug容器中
a.模拟一个客户端,发送50个请求给rng服务
/ # ab -c 1 -n 50 http://rng/10
This is ApacheBench, Version 2.3 <$Revision: 1748469 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.NET/
Licensed to The Apache Software Foundation, http://www.apache.org/
Benchmarking rng (be patient).....done
Server Software:        Werkzeug/0.11.10
Server Hostname:        rng
Server Port:            80
Document Path:          /10
Document Length:        10 bytes
Concurrency Level:      1
Time taken for tests:   5.386 seconds
Complete requests:      50
Failed requests:        0
Total transferred:      8250 bytes
HTML transferred:       500 bytes
Requests per second:    9.28 [#/sec] (mean)
Time per request:       107.716 [ms] (mean)
Time per request:       107.716 [ms] (mean, across all concurrent requests)
Transfer rate:          1.50 [Kbytes/sec] received
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        1    2   0.6      1       3
Processing:   103  106   1.5    106     110
Waiting:      102  105   1.2    105     109
Total:        104  107   1.7    107     112
WARNING: The median and mean for the initial connection time are not within a normal deviation
        These results are probably not that reliable.
Percentage of the requests served within a certain time (ms)
  50%    107
  66%    108
  75%    108
  80%    108
  90%    110
  95%    110
  98%    112
  99%    112
 100%    112 (longest request)

b.模拟50个并发客户端, 发送50个请求
/ # ab -c 50 -n 50 http://rng/10
This is ApacheBench, Version 2.3 <$Revision: 1748469 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.Net/
Licensed to The Apache Software Foundation, http://www.apache.org/
Benchmarking rng (be patient).....done
Server Software:        Werkzeug/0.11.10
Server Hostname:        rng
Server Port:            80
Document Path:          /10
Document Length:        10 bytes
Concurrency Level:      50
Time taken for tests:   1.105 seconds
Complete requests:      50
Failed requests:        0
Total transferred:      8250 bytes
HTML transferred:       500 bytes
Requests per second:    45.23 [#/sec] (mean)
Time per request:       1105.436 [ms] (mean)
Time per request:       22.109 [ms] (mean, across all concurrent requests)
Transfer rate:          7.29 [Kbytes/sec] received
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        7    9   1.3      9      12
Processing:   103  590 313.4    627    1087
Waiting:      103  589 313.3    626    1087
Total:        115  599 312.2    637    1095
Percentage of the requests served within a certain time (ms)
  50%    637
  66%    764
  75%    869
  80%    946
  90%   1050
  95%   1092
  98%   1095
  99%   1095
 100%   1095 (longest request)
可以看出,单个客户端的时候rng的响应时间平均107.716ms, 多并发情况下增加到大约1000ms+.

3.4.3 hasher服务压力测试
hasher的服务测试稍微复杂点, 因为hasher服务需要POST一个随机的bytes数据.
所以我们需要先通过curl制作一个bytes数据文件:
/ # curl http://rng/10 > /tmp/random

a.模拟单客户端,发送50个请求给hasher服务
/ # ab -c 1 -n 50 -T application/octet-stream -p /tmp/random http://hasher/
This is ApacheBench, Version 2.3 <$Revision: 1748469 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/
Benchmarking hasher (be patient).....done
Server Software:        thin
Server Hostname:        hasher
Server Port:            80
Document Path:          /
Document Length:        64 bytes
Concurrency Level:      1
Time taken for tests:   5.323 seconds
Complete requests:      50
Failed requests:        0
Total transferred:      10450 bytes
Total body sent:        7250
HTML transferred:       3200 bytes
Requests per second:    9.39 [#/sec] (mean)
Time per request:       106.454 [ms] (mean)
Time per request:       106.454 [ms] (mean, across all concurrent requests)
Transfer rate:          1.92 [Kbytes/sec] received
                        1.33 kb/s sent
                        3.25 kb/s total
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        1    1   0.4      1       3
Processing:   103  105   0.8    105     107
Waiting:      103  104   0.8    104     107
Total:        104  106   1.0    106     109
Percentage of the requests served within a certain time (ms)
  50%    106
  66%    106
  75%    106
  80%    107
  90%    108
  95%    108
  98%    109
  99%    109
 100%    109 (longest request)

b.模拟50个并发客户端, 发送50个请求
/ # ab -c 50 -n 50 -T application/octet-stream -p /tmp/random http://hasher/
This is ApacheBench, Version 2.3 <$Revision: 1748469 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/
Benchmarking hasher (be patient).....done
Server Software:        thin
Server Hostname:        hasher
Server Port:            80
Document Path:          /
Document Length:        64 bytes
Concurrency Level:      50
Time taken for tests:   0.345 seconds
Complete requests:      50
Failed requests:        0
Total transferred:      10450 bytes
Total body sent:        7250
HTML transferred:       3200 bytes
Requests per second:    144.95 [#/sec] (mean)
Time per request:       344.937 [ms] (mean)
Time per request:       6.899 [ms] (mean, across all concurrent requests)
Transfer rate:          29.59 [Kbytes/sec] received
                        20.53 kb/s sent
                        50.11 kb/s total
Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        5   10   4.8      8      17
Processing:   131  214  71.5    238     323
Waiting:      126  207  72.2    231     322
Total:        147  224  67.2    246     328
Percentage of the requests served within a certain time (ms)
  50%    246
  66%    249
  75%    252
  80%    314
  90%    324
  95%    328
  98%    328
  99%    328
 100%    328 (longest request)
从结果可以看出, 单客户端hasher平均响应时间106.454ms, 50并发平均响应时间344.937ms.
hasher服务并发响应时间也慢, 不过比rng的1000+ms却好太多…



            
```
