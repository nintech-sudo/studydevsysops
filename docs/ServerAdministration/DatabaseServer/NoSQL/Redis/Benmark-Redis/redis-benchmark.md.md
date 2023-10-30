
Demo Redis cache + nodejs


``` bash
mvn spring-boot:run

#springboot-no-caching
http://103.126.163.19:8030/products/search?name=Iphone

#springboot-caching
http://103.126.163.19:8040/products/search?name=Iphone
```


## benchmark redis

``` bash
redis-benchmark -h 10.10.100.100 -p 6379 -c 100 -n 1000000 -a 'P@ssw0rd@2023
```

## benchmark mysql

``` bash
sysbench --db-driver=mysql --mysql-user=sbtest_user --mysql_password=password --mysql-db=sbtest --mysql-host=0.0.0.0 --mysql-port=3306 --tables=16 --table-size=100000 --threads=100 --time=60 --events=0 --report-interval=1 --rate=10000 /usr/share/sysbench/oltp_read_write.lua run
```

  `mysql -u root -p'8cae272adb86a3e2 ' `

## Demo PUB/SUB

``` bash
redis-cli -h 10.10.100.100 -p 6379 -a 'P@ssw0rd!@#2023'

subscribe mychanel

publish mychanel 'Nguyen Van A da oder goi dich vu VPS PROSSD'
```



### Redis HAProxy

Read
``` bash
redis-cli -h 10.10.100.10 -p 6379 -a 'P@ssw0rd!@#2023'
```


Write
``` bash
redis-cli -h 10.10.100.10 -p 6380 -a 'P@ssw0rd!@#2023'
```



## Check HAProxy + Repliaction

``` bash
for i in {1..3}; do redis-cli -h 10.10.100.10 -p 6379 -a 'P@ssw0rd!@#2023' info replication; done

for i in {1..3}; do redis-cli -h 10.10.100.10 -p 6380 -a 'P@ssw0rd!@#2023' info replication; done
```





1. Hashes:
    
    - Để set giá trị cho một trường trong một hash: `HSET key field value`
    - Ví dụ: `HSET myhash field1 "Hello"`
    - Để xem giá trị của một trường trong một hash: `HGET key field`
    - Ví dụ: `HGET myhash field1`
2. Lists:
    
    - Để thêm giá trị vào một list: `LPUSH key value`
    - Ví dụ: `LPUSH mylist "World"`
    - Để xem giá trị của một list: `LRANGE key start stop`
    - Ví dụ: `LRANGE mylist 0 -1`
3. Strings:
    
    - Để set giá trị cho một chuỗi: `SET key value`
    - Ví dụ: `SET mystring "Hello"`
    - Để xem giá trị của một chuỗi: `GET key`
    - Ví dụ: `GET mystring`
4. Sets:
    
    - Để thêm giá trị vào một set: `SADD key member`
    - Ví dụ: `SADD myset "Value1"`
    - Để xem giá trị của một set: `SMEMBERS key`
    - Ví dụ: `SMEMBERS myset`
5. Bits:
    
    - Để set giá trị cho một bit trong một chuỗi bits: `SETBIT key offset value`
    - Ví dụ: `SETBIT mybits 0 1`
    - Để xem giá trị của một chuỗi bits: `GETBIT key offset`
    - Ví dụ: `GETBIT mybits 0`



# Heading 1
Ví dụ: `GETBIT mybits 0`

## Heading 2
Ví dụ: `GETBIT mybits 0`
### Heading 3
Ví dụ: `GETBIT mybits 0`
#### Heading 4





