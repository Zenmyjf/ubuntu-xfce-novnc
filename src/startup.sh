#!/bin/bash
### every exit != 0 fails the script
set -e

### Envrionment config
export HOME=/home/vncuser
export NO_VNC_HOME=/home/vncuser/noVNC
export LOG_HOME=/home/vncuser
export DISPLAY=:1
export VNC_PORT=5901
export NO_VNC_PORT=6080
export VNC_COL_DEPTH=24
export VNC_RESOLUTION=1280x720
export DEBUG=false

## print out help
help (){
echo "
USAGE:
docker run -it -p 6080:5901 kingma/<image>:<tag> <option>

IMAGES:
kingma/ubuntu-xfce-vnc

TAGS:
latest  stable version of branch 'master'
test     current development version of branch 'test'

OPTIONS:
-w, --wait      (default) keeps the UI and the vncserver up until SIGINT or SIGTERM will received
-s, --skip      skip the vnc startup and just execute the assigned command.
                example: docker run kingma/centos-xfce-vnc --skip bash
-d, --debug     enables more detailed startup output
                e.g. 'docker run kingma/centos-xfce-vnc --debug bash'
-h, --help      print out this help

Fore more information see: https://github.com/consol/docker-headless-vnc-container
"
}
if [[ $1 =~ -h|--help ]]; then
    help
    exit 0
fi

# add `--skip` to startup args, to skip the VNC startup procedure
if [[ $1 =~ -s|--skip ]]; then
    echo -e "\n\n------------------ SKIP VNC STARTUP -----------------"
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '${@:2}'"
    exec "${@:2}"
fi
if [[ $1 =~ -d|--debug ]]; then
    echo -e "\n\n------------------ DEBUG VNC STARTUP -----------------"
    export DEBUG=true
fi

## correct forwarding of shutdown signal
cleanup () {
    kill -s SIGTERM $!
    exit 0
}
trap cleanup SIGINT SIGTERM

if [[ -f $PASSWD_PATH ]]; then
    echo -e "\n---------  purging existing VNC password settings  ---------"
    rm -f $PASSWD_PATH
fi

## start vncserver and noVNC webclient
echo -e "\n------------------ start noVNC  ----------------------------"
if [[ $DEBUG == true ]]; then echo "$NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT"; fi
$NO_VNC_HOME/utils/launch.sh --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT &> $LOG_HOME/no_vnc_startup.log &
PID_SUB=$!

echo -e "\n------------------ start VNC server ------------------------"
echo "remove old vnc locks to be a reattachable container"
vncserver -kill $DISPLAY &> $LOG_HOME/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> $LOG_HOME/vnc_startup.log \
    || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."
if [[ $DEBUG == true ]]; then echo "vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION"; fi
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION &> $LOG_HOME/no_vnc_startup.log

## log connect options
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$VNC_IP:$NO_VNC_PORT/?password=...\n"


if [[ $DEBUG == true ]] || [[ $1 =~ -t|--tail-log ]]; then
    echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
    # if option `-t` or `--tail-log` block the execution and tail the VNC log
    tail -f $LOG_HOME/*.log $HOME/.vnc/*$DISPLAY.log
fi

if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
    wait $PID_SUB
else
    # unknown option ==> call command
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '$@'"
    exec "$@"
fi
