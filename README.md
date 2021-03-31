# dnsearch
using rapid7 open data search subdomain and reverse ip

## run
```
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,https://gocenter.io,https://goproxy.io,direct
go run dnsearch.go
```


## search subdomains

`curl http://localhost/?q=baidu.com`


## reverse ip

`curl http://localhost/?ip=8.8.8.8`

