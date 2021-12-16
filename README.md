# dnsearch

using rapid7 open dns data search subdomain and reverse ip

## note

- It is recommended to use https://github.com/Cgboal/SonarSearch
- The process of constructing the data will cost 30+ hours(maybe more) on a normal disk, make sure you have 300G free disk space

## using docker

1. `git clone --depth 1 https://github.com/p7e4/dnsearch`

2. update the download url in the `build.sh`, which can be obtained from https://opendata.rapid7.com/

3. ```docker run -d -e TZ=Asia/Shanghai -p 80:80 --name dnsearch -v `pwd`/dnsearch:/dnsearch ubuntu bash -c "bash /dnsearch/build.sh >> log.txt"```

check the status:

`docker exec -it dnsearch tail log.txt`

## search subdomains

`curl http://localhost/?domain=baidu.com`

## reverse ip

`curl http://localhost/?ip=8.8.8.8`

## ref

- https://p7e4.js.org/2021/04/05/using-rapid7-opendata/
- https://opendata.rapid7.com/

