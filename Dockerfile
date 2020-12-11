FROM ubuntu:18.04 as builder

ENV ver=0.1
LABEL maintainer="Jacky <cheungyong@gmail.com>"

WORKDIR /root

RUN apt-get update \
  && apt-get install -y apt-utils \
  && apt-get install -y git cmake libev-dev g++ \
  && git clone https://github.com/tisyang/ntripcaster.git \
  && cd /root/ntripcaster \
  && git submodule update --init \ 
  && mkdir -p /root/ntripcaster/build \ 
  && (cd /root/ntripcaster/build; cmake ..) \
  && (cd /root/ntripcaster/build; make) \
  && cp /root/ntripcaster/build/ntripcaster /usr/local/bin/ \
  && mkdir -p /etc/ntripcaster \
  && cp /root/config.json /etc/ntripcaster/ \
  && rm -R /root/ntripcaster

FROM ubuntu:18.04

ENV ver=0.1
#LABEL maintainer="Jacky <cheungyong@gmail.com>"

RUN apt-get update \
  && apt-get install -y libev-dev \
  && mkdir -p /etc/ntripcaster \
  && apt-get clean
  
#COPY --from=builder /usr/local/bin/ntripcaster /usr/local/bin/
COPY config.json /etc/ntripcaster/
  
#default port:2101,json config file
EXPOSE 2101
VOLUME /etc/ntripcaster
ENTRYPOINT [ "/usr/local/bin/ntripcaster", "/etc/ntripcaster/config.json", ""]
