FROM ubuntu:20.04
RUN apt update &&\
    apt install -y\
    tzdata &&\
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime &&\
    dpkg-reconfigure -f noninteractive tzdata
RUN apt install -y \
    curl net-tools mc telnet vim \
    tor \
    tor-geoipdb \
    ##для dns
    bind-dig \
    privoxy \
    squid3 \
    supervisor \
    obfs4proxy &&\
    rm -rf /var/lib/apt/lists/*
COPY torrc /etc/tor/torrc
COPY privoxy.conf /etc/privoxy/config
COPY squid.conf /etc/squid/squid.conf
COPY redirect-to-tor.txt /etc/squid/redirect-to-tor.dat
# supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/tor_proxy.conf

CMD ["/usr/bin/supervisord"]