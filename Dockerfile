FROM ubuntu:18.04

ENV ver=1.0
LABEL maintainer="Jacky <cheungyong@gmail.com>"

WORKDIR /root
RUN mkdir -p /etc/ntripcaster
COPY config.json /etc/ntripcaster

RUN apt-get install git libev-dev -y

RUN git clone https://github.com/tisyang/ntripcaster.git \
  && cd ntripcaster \
  && git submodule update --init \
  && mkdir build && cd build \
  && cmake .. \
  && make \
  && cp ntripcaster /usr/local/bin/

RUN rm -R /root/ntripcaster
  


EXPOSE 2101
VOLUME /etc/ntripcaster
CMD [ "/usr/local/bin/ntripcaster", "/etc/ntripcaster/config.json", ""]
