**Application**

[Deluge](http://deluge-torrent.org/)

**Description**

Deluge is a full-featured ​BitTorrent client for Linux, OS X, Unix and Windows. It uses ​libtorrent in its backend and features multiple user-interfaces including: GTK+, web and console. It has been designed using the client server model with a daemon process that handles all the bittorrent activity. The Deluge daemon is able to run on headless machines with the user-interfaces being able to connect remotely from any platform.

**Build notes**

Latest stable Deluge release from Arch Linux repo.

**Usage**
```
docker run -d \
    -p 8112:8112 \
    -p 58846:58846 \
    -p 58946:58946 \
    --name=<container name> \
    -v <path for data files>:/media \
    -v <path for config files>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e PUID=<uid for user> \
    -e PGID=<gid for user> \
    -e PIPEWORK_WAIT=yes \ # <-- optional
    binhex/arch-deluge
```

Please replace all user variables in the above command defined by <> with the
correct values.  If you set the environment variable `PIPEWORK_WAIT`, then the
container's startup script will wait for the network interface eth1 to come up.
This is useful in cases where the container is run with an IP on the LAN. Due
to limitations imposed currently by Docker, the container needs to be
configured with `--net=none` and then have the interface configured using
netns. The [pipework](https://github.com/jpetazzo/pipework) script handles this
nicely, but, since the setup is external to the container, this option forces
the container to wait until the interface is configured adequately.

**Access application**<br>

`http://<host ip>:8112`

**Example**
```
docker run -d \
    -p 8112:8112 \
    -p 58846:58846 \
    -p 58946:58946 \
    --name=deluge \
    -v /apps/docker/deluge/media:/media \
    -v /apps/docker/deluge/config:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e PUID=0 \
    -e PGID=0 \
    binhex/arch-deluge
```

**Notes**<br>

User ID (PUID) and Group ID (PGID) can be found by issuing the following command for the user you want to run the container as:-

```
id <username>
```

Default password for the webui is "deluge"
___
If you appreciate my work, then please consider buying me a beer  :D

[![PayPal donation](https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MM5E27UX6AUU4)

[Support forum](http://lime-technology.com/forum/index.php?topic=45820.0)
