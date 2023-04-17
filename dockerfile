FROM ubuntu:22.04

RUN  apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*

ENV RPC_PORT 8030
ENV WS_PORT 38330
ENV P2P_PORT 22556
ENV RPC_USER rostislav
ENV RPC_PASS hakerman
ENV COIN_VERSION 24.0.1

WORKDIR /opt

RUN wget -O coin.tar.gz https://bitcoincore.org/bin/bitcoin-core-${COIN_VERSION}/bitcoin-${COIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && tar -xvf coin.tar.gz \
  && mkdir /coin \
  && mv bitcoin-${COIN_VERSION}/bin/bitcoind /coin/ \
  && chmod +x /coin/bitcoind \
  && rm -rf /opt/*

VOLUME [ "/coin/data" ]

WORKDIR /coin

COPY ./src/coin.conf /coin/coin.conf
COPY ./src/run.sh /coin/run.sh

RUN chmod +x run.sh

ENTRYPOINT [ "./run.sh" ]

EXPOSE ${RPC_PORT} ${WS_PORT} ${P2P_PORT}
