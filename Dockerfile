FROM ubuntu:latest AS foundation

LABEL maintainer="Chuck Melanson <chuckmelanson@gmail.com>"

RUN apt-get update
RUN apt-get install -y unzip dos2unix wget

WORKDIR /root

RUN wget -q --progress=bar:force:noscroll --show-progress https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh -O install-ibgateway.sh
RUN chmod a+x install-ibgateway.sh

RUN wget -q --progress=bar:force:noscroll --show-progress https://github.com/IbcAlpha/IBC/releases/download/3.8.7/IBCLinux-3.8.7.zip -O ibc.zip
RUN unzip ibc.zip -d /opt/ibc
RUN chmod a+x /opt/ibc/*.sh /opt/ibc/*/*.sh
COPY run.sh run.sh
RUN dos2unix run.sh

# Application
FROM foundation

RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && apt-get install -y xvfb \
  && apt-get install -y libxtst6 \
  && apt-get install -y libxrender1 \
  && apt-get install -y libxi6 \
	&& apt-get install -y x11vnc \
  && apt-get install -y socat \
  && apt-get install -y software-properties-common \
  && apt-get install -y dos2unix
  
WORKDIR /root

COPY --from=foundation /root/install-ibgateway.sh install-ibgateway.sh
RUN yes "" | ./install-ibgateway.sh

RUN mkdir .vnc
RUN x11vnc -storepasswd 1234 .vnc/passwd

COPY --from=foundation /opt/ibc /opt/ibc
COPY --from=foundation /root/run.sh run.sh

COPY ibc_config.ini ibc/config.ini

ENV DISPLAY :0
ENV TRADING_MODE paper
ENV TWS_PORT 4003
ENV VNC_PORT 5903

EXPOSE $TWS_PORT
EXPOSE $VNC_PORT

CMD ./run.sh
