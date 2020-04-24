FROM kingma/ubuntu-xfce-vnc:beta

MAINTAINER Marvell "kingwinma@gmail.com"
ENV REFRESHED_AT 2020-04-24

ADD ./src/ /home/vncuser/
RUN chmod +x /home/vncuser/startup.sh && chown vncuser /home/vncuser/startup.sh

EXPOSE 6080

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
