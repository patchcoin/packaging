FROM ubuntu:24.04 as build

ARG TARGETPLATFORM
COPY ${TARGETPLATFORM}/patchcoin*.tar.gz .

RUN set -ex \
  && tar -xzf patchcoin*.tar.gz -C /opt \
  && rm -rf /opt/patchcoin-*/bin/patchcoin-qt \
  && mv /opt/patchcoin-* /opt/patchcoin

FROM ubuntu:24.04

RUN useradd -r patchcoin \
  && apt-get update \
  && apt-get install -y gosu \
  && rm -rf /var/lib/apt/lists/*

ENV PTC_DATA=/home/patchcoin/.patchcoin
ENV PATCHCOIN_PREFIX=/opt/patchcoin
ENV PATH=${PATCHCOIN_PREFIX}/bin:$PATH
ENV RPC_PASSWORD=ptcpass
ENV RPC_USER=ptcuser

COPY --from=build /opt /opt
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["${PTC_DATA}"]
EXPOSE 7801 7802 7803 7804

ENTRYPOINT ["/entrypoint.sh"]
CMD ["patchcoind"]
