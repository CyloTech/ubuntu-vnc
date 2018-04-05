FROM ubuntu:17.10
MAINTAINER Gavin Hanson <gavin@cylo.io>

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

RUN apt-get update; \
    apt-get install -y ubuntu-desktop; \
    apt-get install -y tightvncserver; \
    mkdir -p /root/.vnc; \
    mkdir -p /root/.config/flexget

RUN apt-get install -y -f -m \
        firefox \
        gnome-panel \
        gnome-settings-daemon \
        metacity \
        nautilus \
        gnome-terminal \
        firefox \
        openssh-server \
        nano \
        rsync \
        ffmpeg \
        supervisor

RUN mkdir -p /root/.config/nautilus; \
    chown root:root /root/.config/nautilus; \
    chmod 755 /root/.config/nautilus

# RClone
RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip; \
    unzip rclone-current-linux-amd64.zip; \
    cd rclone-*-linux-amd64; \
    cp rclone /usr/bin/; \
    chown root:root /usr/bin/rclone; \
    chmod 755 /usr/bin/rclone; \
    mkdir -p /usr/local/share/man/man1; \
    cp rclone.1 /usr/local/share/man/man1/; \
    mandb

# RClone Browser
ADD rclone-browser_1.2_amd64.deb /root/
RUN cd /root; \
    dpkg -i rclone-browser_1.2_amd64.deb; \
    apt-get install -f -y; \
    rm -fr /root/rclone*; \
    cd /root

# Wine
RUN dpkg --add-architecture i386; \
    apt-add-repository -y 'https://dl.winehq.org/wine-builds/ubuntu/'; \
    apt-key adv --fetch-keys https://dl.winehq.org/wine-builds/Release.key; \
    apt-get update; \
    apt-get install -y --install-recommends winehq-stable -o Dpkg::Options::="--force-overwrite"; \
    cd /root

# Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF; \
    echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list; \
    apt-get update; \
    apt-get install -y mono-devel

# FlexGet
RUN apt update; \
    apt-get install -y python python-pip; \
    pip install flexget

# MKVTool
RUN sh -c 'echo "deb http://www.bunkus.org/ubuntu/zesty/ ./" >> /etc/apt/sources.list.d/mkvtoolnix.list'; \
    apt update; \
    apt -y install mkvtoolnix-gui

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd
ADD configure.sh /root/configure.sh
ADD sshd_config /sshd_config
ADD flexget-config.yml /root/.config/flexget/config.yml

ADD supervisord.conf /etc/supervisord.conf

RUN chmod +x /root/configure.sh
RUN chmod 600 /root/.vnc/passwd

RUN rm -fr /rclone*

WORKDIR /

EXPOSE 22 5901

CMD ["/root/configure.sh"]