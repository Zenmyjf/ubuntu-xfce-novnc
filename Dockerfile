FROM kingma/ubuntu-xfce-vnc:beta

MAINTAINER Marvell "kingwinma@gmail.com"
ENV REFRESHED_AT 2020-04-24

ADD ./src/ /home/vncuser/
RUN chmod +x /home/vncuser/startup.sh && chown vncuser /home/vncuser/startup.sh

EXPOSE 6080
USER vncuser

ENTRYPOINT ["/home/vncuser/startup.sh"]
CMD ["--wait"]
