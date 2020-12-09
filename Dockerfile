FROM --platform=$BUILDPLATFORM ubuntu:18.04 as builder

ARG BUILDPLATFORM
ARG TARGETPLATFORM
ENV ver=0.1
LABEL maintainer="Jacky <cheungyong@gmail.com>"

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log

WORKDIR /root
RUN mkdir -p /etc/ntripcaster
COPY config.json /etc/ntripcaster


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
  && rm -R /root/ntripcaster

FROM ubuntu:18.04

ENV ver=0.1
LABEL maintainer="Jacky <cheungyong@gmail.com>"

RUN apt-get update \
  && apt-get install -y libev-dev
  
COPY --from=builder /usr/local/bin/ntripcaster /usr/local/bin/

  
#default port:2101,json config file
EXPOSE 2101
VOLUME /etc/ntripcaster
CMD [ "/usr/local/bin/ntripcaster", "/etc/ntripcaster/config.json", ""]
