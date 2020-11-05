FROM ubuntu:18.04

ENV ver=0.1
LABEL maintainer="Jacky <cheungyong@gmail.com>"

WORKDIR /root
RUN mkdir -p /etc/ntripcaster
COPY config.json /etc/ntripcaster

RUN cd /root

RUN apt-get update -y 

RUN apt-get install -y apt-utils

RUN apt-get install -y git cmake libev-dev

RUN git clone https://github.com/tisyang/ntripcaster.git

RUN cd /root/ntripcaster \
  && git submodule update --init 

RUN mkdir -p /root/ntripcaster/build && cd /root/ntripcaster/build

RUN cmake .. && make 

RUN cp /root/ntripcaster/build/ntripcaster /usr/local/bin/

#clear 
RUN rm -R /root/ntripcaster
  
#default port:2101,json config file
EXPOSE 2101
VOLUME /etc/ntripcaster
CMD [ "/usr/local/bin/ntripcaster", "/etc/ntripcaster/config.json", ""]
