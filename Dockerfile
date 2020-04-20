FROM kingma/ubuntu-xfce-novnc:base

ENV HOME=/home/vncuser
WORKDIR $HOME

RUN apt update && \
    apt install -y firefox
RUN apt clean -y

ADD ./src/ $HOME/

RUN chmod 777 $HOME/vnc_startup.sh
    
EXPOSE 6080

USER vncuser

ENTRYPOINT ["/home/vncuser/vnc_startup.sh"]
CMD ["--wait"]
