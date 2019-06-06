FROM fedora:27
LABEL author="roberto@edt M11"
LABEL description="extra Server pop "
RUN dnf -y install telnet xinetd iproute iputils nmap uw-imap procps net-tools passwd  openssh-server 
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh /opt/docker/install.sh
WORKDIR /opt/docker
CMD [ "/opt/docker/startup.sh" ]

