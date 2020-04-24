This repository contains a Docker images with headless VNC environments.

Desktop environment :Xfce4</br>
VNC-Server :tigervnc-1.10.1.x86_64(default VNC port 5901)</br>
noVNC - HTML5 VNC client (default http port 6080)</br>

Usage:</br>
1.docker run -d -p 6080:6080 kingma/ubuntu-xfce-vnc:latest</br>
2.docker exec -it [container ID] /bin/bash</br>
3.You should set the vncuser password and modify the /home/vncuser/startup.sh scripts content inside</br>
4.connect via noVNC HTML5 full client: http://IP:6080/, default password: vncpasswd</br>
</br>
-----------------------------------------------------------------------------</br>

