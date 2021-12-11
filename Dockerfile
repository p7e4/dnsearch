FROM ubuntu
VOLUME /etc/localtime
ADD . /root/
RUN bash /root/build.sh
ENTRYPOINT ["bash", "/root/start.sh"]
