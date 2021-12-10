apt-get update && apt-get upgrade -y

apt-get install golang mongodb wget pigz jq -y

go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,https://gocenter.io,https://goproxy.io,direct

service mongodb start

wget -O fdns.json.gz https://opendata.rapid7.com/sonar.fdns_v2/2021-03-26-1616717346-fdns_a.json.gz
wget -O rdns.json.gz https://opendata.rapid7.com/sonar.rdns_v2/2021-03-24-1616544312-rdns.json.gz

pigz -dc fdns.json.gz | grep "cname\"" -v | jq -r '"}\"" + .value + "\":\"pi\",\"" + .name + "\":\"niamod\"{"' | tr '[:upper:]' '[:lower:]' | rev | pigz > tmp.json.gz
pigz -dc rdns.json.gz | grep "cname\"" -v | jq -r '"}\"" + .name + "\":\"pi\",\"" + .value + "\":\"niamod\"{"' | tr '[:upper:]' '[:lower:]' | rev | pigz >> tmp.json.gz

rm rdns.json.gz fdns.json.gz

# speed up options for sort: --parallel=8 --buffer-size=30G
pigz -dc tmp.json.gz | grep -E '^\{"domain":"[-a-z0-9.]+","ip":"([0-9]{1,3}\.){3}[0-9]{1,3}"}$' | sort -u | pigz > result.json.gz

pigz -dc result.json.gz | mongoimport -d dns -c dns

rm tmp.json.gz result.json.gz

mongo dns --eval "db.dns.createIndex({domain: 1});db.dns.createIndex({ip: 1})"

echo "Build completed!"
