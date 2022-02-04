
if [ -f "/dnsearch/.build" ]; then
 go run /dnsearch/dnsearch.go
 exit
fi

apt-get update && apt-get upgrade -y

export DEBIAN_FRONTEND=noninteractive
apt-get install -y tzdata
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

apt-get install golang mongodb wget pigz jq -y

go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,https://gocenter.io,https://goproxy.io,direct

service mongodb start

echo "start download file"
# update the download url here!
wget -q -O fdns.json.gz https://opendata.rapid7.com/sonar.fdns_v2/2022-01-28-1643328400-fdns_a.json.gz
wget -q -O rdns.json.gz https://opendata.rapid7.com/sonar.rdns_v2/2022-01-26-1643155568-rdns.json.gz

echo "start parsing file"
pigz -dc fdns.json.gz | grep "cname\"" -v | jq -r '"}\"" + .value + "\":\"pi\",\"" + .name + "\":\"niamod\"{"' | tr '[:upper:]' '[:lower:]' | rev | pigz > tmp.json.gz
pigz -dc rdns.json.gz | grep "cname\"" -v | jq -r '"}\"" + .name + "\":\"pi\",\"" + .value + "\":\"niamod\"{"' | tr '[:upper:]' '[:lower:]' | rev | pigz >> tmp.json.gz

rm rdns.json.gz fdns.json.gz

echo "start de-duplication"
# speed up options for sort: --parallel=8 --buffer-size=30G
pigz -dc tmp.json.gz | grep -E '^\{"domain":"[-a-z0-9.]+","ip":"([0-9]{1,3}\.){3}[0-9]{1,3}"}$' | sort -u | pigz > result.json.gz

echo "start import to mongodb"
pigz -dc result.json.gz | mongoimport -d dns -c dns --quiet

rm tmp.json.gz result.json.gz

echo "start createIndex"
mongo dns --eval "db.dns.createIndex({domain: 1});db.dns.createIndex({ip: 1})"

echo "Build completed!"

echo 1 > /dnsearch/.build

go run /dnsearch/dnsearch.go

