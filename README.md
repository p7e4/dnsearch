# dnsearch

using rapid7 open dns data search subdomain and reverse ip

## note
+ It is recommended to use https://github.com/Cgboal/SonarSearch
+ You need to 

## using docker(not finished yet!)

1. `git clone --depth 1 https://github.com/p7e4/dnsearch && cd dnsearch`

2. update the download url in the `build.sh`, which can be obtained from https://opendata.rapid7.com/

3. `docker build -t dnsearch .`

4. `docker run -d -p 80 dnsearch`


## search subdomains

`curl http://localhost/?domain=baidu.com`

## reverse ip

`curl http://localhost/?ip=8.8.8.8`


## ref

- https://p7e4.js.org/2021/04/05/using-rapid7-opendata/
- https://opendata.rapid7.com/

