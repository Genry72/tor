FROM ubuntu:20.04
RUN apt update &&\
    apt install -y\
    tzdata &&\
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime &&\
    dpkg-reconfigure -f noninteractive tzdata
RUN apt install -y \
    # curl net-tools \
    tor \
    tor-geoipdb \
    privoxy \
    supervisor \
    obfs4proxy &&\
    rm -rf /var/lib/apt/lists/*
COPY torrc /etc/tor/torrc
COPY privoxy.conf /etc/privoxy/config
# supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/tor_proxy.conf

CMD ["/usr/bin/supervisord"]