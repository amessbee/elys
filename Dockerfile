# 1) Build stage: Download the precompiled elysd binary
ARG BASE_IMAGE=golang:1.21-bullseye
FROM ${BASE_IMAGE} AS build-env
ARG VERSION=v2.0.0
ENV BINARY_URL="https://github.com/elys-network/elys/releases/download/${VERSION}/elysd-${VERSION}-linux-amd64.tar.gz"
RUN apt-get update && apt-get install -y ca-certificates curl bash
WORKDIR /tmp/elys
ADD $BINARY_URL elysd.tar.gz
RUN tar xvf elysd.tar.gz \
 && rm elysd.tar.gz \
 && mv elysd /usr/local/bin/elysd

# 2) Final image: minimal Debian, copy elysd from build
FROM debian:stable-slim
RUN apt-get update && apt-get install -y ca-certificates sed jq && rm -rf /var/lib/apt/lists/*
COPY --from=build-env /usr/local/bin/elysd /usr/local/bin/elysd
COPY update_genesis.sh /root/update_genesis.sh
COPY init_chain.sh /root/init_chain.sh
RUN chmod +x /root/update_genesis.sh /root/init_chain.sh
ENV HOME=/root
WORKDIR /root
EXPOSE 26657 26656 1317 9090
CMD ["/root/init_chain.sh"]