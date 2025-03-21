#!/bin/sh

if [ -f "/etc/samba/smb.conf" ]; then
   supervisord -c /etc/supervisord.conf -n
else
	echo "TODO: SETUP"
	sleep infinity
fi

