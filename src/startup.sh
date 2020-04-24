#!/bin/bash

### Envrionment config
export HOME=/home/vncuser
export NO_VNC_HOME=/home/vncuser/noVNC
export LOG_HOME=/home/vncuser
export VNC_PORT=5901
export NO_VNC_PORT=8080
export VNC_COL_DEPTH=24
export VNC_RESOLUTION=1280x720
export DEBUG=false

## start vncserver and noVNC webclient
echo "\n------------------ start noVNC  ----------------------------"
nohup sh $NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT & > $LOG_HOME/no_vnc_startup.log 

echo "\n------------------ start VNC server ------------------------"
echo "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."
nohup vncserver :1 -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION & > $LOG_HOME/vnc_startup.log

## log connect options
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= :1 \n\t=> connect via VNC viewer with 127.0.0.1:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://YOUR_IP:$NO_VNC_PORT/?password=...\n"

echo "startup scripts will be exit after 10 sec!"
sleep 10
exit;
