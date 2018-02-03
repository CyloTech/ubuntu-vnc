#!/bin/bash

#echo " "
#echo "************************************************************************"
#echo "INSTALLING EXTRA COMPONENTS"
#echo "************************************************************************"
#apt-get install -y -f -m \
#    firefox \
#    gnome-panel \
#    gnome-settings-daemon \
#    metacity \
#    nautilus \
#    gnome-terminal \
#    firefox \
#    openssh-server \
#    nano \
#    rsync
#
#mkdir -p /root/.config/nautilus
#chown root:root /root/.config/nautilus
#chmod 755 /root/.config/nautilus

#echo " "
#echo "************************************************************************"
#echo "INSTALLING RCLONE"
#echo "************************************************************************"
#curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
#unzip rclone-current-linux-amd64.zip
#cd rclone-*-linux-amd64
#cp rclone /usr/bin/
#chown root:root /usr/bin/rclone
#chmod 755 /usr/bin/rclone
#mkdir -p /usr/local/share/man/man1
#cp rclone.1 /usr/local/share/man/man1/
#mandb
#
#wget https://github.com/mmozeiko/RcloneBrowser/releases/download/1.2/rclone-browser_1.2_amd64.deb
#dpkg -i rclone-browser_1.2_amd64.deb
#apt-get install -f -y
#rm -fr /root/rclone*
#cd /root

#echo " "
#echo "************************************************************************"
#echo "INSTALLING WINE"
#echo "************************************************************************"
#dpkg --add-architecture i386
#apt-add-repository -y 'https://dl.winehq.org/wine-builds/ubuntu/'
#apt-key adv --fetch-keys https://dl.winehq.org/wine-builds/Release.key
#apt-get update
#apt-get install -y --install-recommends winehq-stable -o Dpkg::Options::="--force-overwrite"
#cd /root

#echo " "
#echo "************************************************************************"
#echo "INSTALLING MONO"
#echo "************************************************************************"
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
#echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list
#apt-get update
#apt-get install -y mono-devel

#echo " "
#echo "************************************************************************"
#echo "INSTALLING FLEXGET"
#echo "************************************************************************"
#apt update
#apt-get install -y python python-pip
#pip install flexget

#echo " "
#echo "************************************************************************"
#echo "INSTALLING FFMPEG"
#echo "************************************************************************"
#apt update
#apt-get install -y ffmpeg

#echo " "
#echo "************************************************************************"
#echo "INSTALLING MKVTool"
#echo "************************************************************************"
#sh -c 'echo "deb http://www.bunkus.org/ubuntu/zesty/ ./" >> /etc/apt/sources.list.d/mkvtoolnix.list'
#apt update
#apt -y install mkvtoolnix-gui

echo " "
echo "************************************************************************"
echo "SETTING ROOT PASSWORD"
echo "************************************************************************"
echo "root:${ROOT_PASSWORD}" | chpasswd

echo " "
echo "************************************************************************"
echo "ENABLE ROOT LOGIN & SSH"
echo "************************************************************************"
rm -fr /etc/ssh/sshd_config
mv /sshd_config /etc/ssh/sshd_config
service ssh restart

echo " "
echo "************************************************************************"
echo "STARTING SUPERVISOR"
echo "************************************************************************"
mv /root/supervisor/* /etc/supervisor/conf.d/
/usr/bin/supervisord
rm -fr /root/supervisor

echo " "
echo "************************************************************************"
echo "STARTING VNC SERVER"
echo "************************************************************************"
/usr/bin/vncserver :1 -geometry 1280x800 -depth 24

# Prevent Exit
tail -f /var/log/supervisor/supervisord.log