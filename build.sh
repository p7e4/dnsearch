apt-get update && apt-get upgrade -y

apt-get install golang mongodb wget pigz jq -y

wget -O fdns.json.gz https://opendata.rapid7.com/sonar.fdns_v2/2021-03-26-1616717346-fdns_a.json.gz
wget -O rdns.json.gz https://opendata.rapid7.com/sonar.rdns_v2/2021-03-24-1616544312-rdns.json.gz

pigz -dc fdns.json.gz | grep "cname\"" -v | jq -r '"}\"" + .value + "\":\"pi\",\"" + .name + "\":\"niamod\"{"' | tr '[:upper:]' '[:lower:]' | rev > tmp.json
pigz -dc rdns.json.gz | jq -r '"}\"" + .name + "\":\"pi\",\"" + .value + "\":\"niamod\"{"' | tr '[:upper:]' '[:lower:]' | rev >> tmp.json

rm -f rdns.json.gz fdns.json.gz

grep -E '^\{"domain":"[-a-z0-9\.]+","ip":"([0-9]{1,3}\.){3}[0-9]{1,3}"}$' tmp.json | sort | uniq | mongoimport -d dns -c dns

rm tmp.json

mongo dns --eval "db.dns.createIndex({domain: 1});db.dns.createIndex({ip: 1})"

echo "Build completed!"
