FROM ubuntu:20.04
COPY iptables.rules /etc/iptables.rules
COPY iptables /etc/network/if-up.d/iptables
RUN apt update &&\
    apt install -y\
    tzdata \
    iptables &&\
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime &&\
    dpkg-reconfigure -f noninteractive tzdata &&\
    # chmod +x /iptables.sh &&\
    chmod +x /etc/network/if-up.d/iptables
RUN apt install -y \
    curl \
    net-tools mc telnet vim iputils-ping \
    tor \
    tor-geoipdb \
 #   privoxy \
 #   squid3 \
     \
    supervisor \
    obfs4proxy &&\
    rm -rf /var/lib/apt/lists/*
COPY torrc /etc/tor/torrc
#COPY privoxy.conf /etc/privoxy/config
#COPY squid.conf /etc/squid/squid.conf
#COPY redirect-to-tor.txt /etc/squid/redirect-to-tor.dat
# supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/tor_proxy.conf

CMD ["/usr/bin/supervisord"]