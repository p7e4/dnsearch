# dnsearch
using rapid7 open data search subdomain and reverse ip

## build data
`bash build.sh`


## run
```
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,https://gocenter.io,https://goproxy.io,direct
go run dnsearch.go
```


## search subdomains

`curl http://localhost/?domain=baidu.com`


## reverse ip

`curl http://localhost/?ip=8.8.8.8`


## ref
https://p7e4.js.org/2021/04/05/using-rapid7-opendata/
