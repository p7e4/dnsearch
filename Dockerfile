FROM ubuntu
ADD . /root/
RUN bash /root/build.sh
ENTRYPOINT ["go", "run", "/root/dnsearch.go"]
