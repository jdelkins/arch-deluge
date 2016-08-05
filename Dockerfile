FROM binhex/arch-base:20160611-01
MAINTAINER jdelkins

# additional files
##################

# add supervisor conf file for app
ADD setup/*.conf /etc/supervisor/conf.d/

# add install bash script
ADD setup/root/*.sh /root/

# add my vpn-ip-responder script
ADD vpn-ip-responder /vpn-ip-responder/

# add pipework
ADD https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework /root/

# install app
#############

# make executable and run bash scripts to install app
RUN chmod +x /root/*.sh /root/pipework && \
	/bin/bash /root/install.sh

# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /data to host defined data path (used to store data from app)
VOLUME /data

# expose port for http
EXPOSE 8112

# expose port for deluge daemon
EXPOSE 58846

# expose port for incoming torrent data (tcp and udp)
EXPOSE 58946
EXPOSE 58946/udp

# expose port 8000 for the rpcxml server
EXPOSE 8108/tcp

# set environment variables for user nobody
ENV HOME /home/nobody

# set permissions
#################

# run script to set uid, gid and permissions
CMD ["/bin/bash", "/root/init.sh"]
