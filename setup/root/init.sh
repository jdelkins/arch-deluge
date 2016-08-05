#!/bin/bash

# exit script if return code != 0
set -e

# if uid not specified then use default uid for user nobody 
if [[ -z "${PUID}" ]]; then
	PUID="99"
fi

# if gid not specifed then use default gid for group users
if [[ -z "${PGID}" ]]; then
	PGID="100"
fi

# set user nobody to specified user id (non unique)
usermod -o -u "${PUID}" nobody
echo "[info] Env var PUID  defined as ${PUID}"

# set group users to specified group id (non unique)
groupmod -o -g "${PGID}" users
echo "[info] Env var PGID defined as ${PGID}"

# check for presence of perms file, if it exists then skip setting
# permissions, otherwise recursively set on /config and /media
if [[ ! -f "/config/perms.txt" ]]; then
	# set permissions for /config and /media volume mapping
	echo "[info] Setting permissions recursively on /config and /media..."
	find /config -type d -exec chown ${PUID}:${PGID} {} \; -exec chmod 02775 {} \;
	find /media  -type d -exec chown ${PUID}:${PGID} {} \; -exec chmod 02775 {} \;
	find /config -type f -exec chown ${PUID}:${PGID} {} \; -exec chmod 0664 {} \;
	find /media  -type f -exec chown ${PUID}:${PGID} {} \; -exec chmod 0664 {} \;
	echo "This file prevents permissions from being applied/re-applied to /config, if you want to reset permissions then please delete this file and restart the container." > /config/perms.txt
else
	echo "[info] Permissions already set for /config and /media"
fi

# set permissions inside container
chown -R "${PUID}":"${PGID}" /usr/bin/deluged /usr/bin/deluge-web /home/nobody
chmod -R 775 /usr/bin/deluged /usr/bin/deluge-web /home/nobody

# symlink /media to /data
if [[ ! -e /data ]]; then
	echo "[info] Symlinking /media to /data"
	ln -s /media /data
fi

# wait if necessary
if [[ -n $PIPEWORK_WAIT ]]; then
	echo "[info] Waiting on interface eth1 to come up"
	/root/pipework --wait
fi

echo "[info] Starting Supervisor..."

# run supervisor
# allow a moment for network setup
umask 002
"/usr/bin/supervisord" -c "/etc/supervisor.conf" -n
