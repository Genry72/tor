FROM ubuntu:20.04
RUN apt update &&\
    apt install -y\
    tzdata &&\
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime &&\
    dpkg-reconfigure -f noninteractive tzdata
RUN apt install -y \
    curl net-tools \
    tor \
    tor-geoipdb \
    privoxy \
    supervisor \
    obfs4proxy &&\
    rm -rf /var/lib/apt/lists/*
    # service tor stop
COPY torrc /etc/tor/torrc
COPY privoxy.conf /etc/privoxy/config
# supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/tor_proxy.conf
# RUN service privoxy restart
# EXPOSE 8118 9050 9051
# ENTRYPOINT ["tor"]
# CMD ["-f", "/etc/tor/torrc"]
CMD ["/usr/bin/supervisord"]