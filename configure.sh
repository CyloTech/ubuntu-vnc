#!/bin/bash
if [ ! -f /etc/app_configures ]; then
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
    echo "SETTING UP SUPERVISOR"
    echo "************************************************************************"
cat << EOF >> /etc/supervisor/conf.d/cron.conf
[program:cron]
command=/usr/sbin/cron -f
autostart=true
autorestart=true
priority=15
stdout_events_enabled=true
stderr_events_enabled=true
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF

    touch /root/.gtk-bookmarks

    #Tell Apex we're done installing.
    curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST "https://api.cylo.io/v1/apps/installed/$INSTANCE_ID"
    touch /etc/app_configured
fi


/usr/bin/supervisord
/usr/bin/vncserver :1 -geometry 1280x800 -depth 24
tail -f /root/.vnc/*:1.log