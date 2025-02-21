# 1) Build stage: Download the precompiled elysd binary
ARG BASE_IMAGE=golang:1.21-bullseye
FROM ${BASE_IMAGE} AS build-env

ARG VERSION=v2.0.0
ENV BINARY_URL="https://github.com/elys-network/elys/releases/download/${VERSION}/elysd-${VERSION}-linux-amd64.tar.gz"

RUN apt-get update && apt-get install -y ca-certificates curl bash
WORKDIR /tmp/elys

# Download the precompiled tarball
ADD $BINARY_URL elysd.tar.gz
RUN tar xvf elysd.tar.gz \
    && rm elysd.tar.gz \
    && mv elysd /usr/local/bin/elysd


# 2) Final image: minimal Debian, copy elysd from build
FROM debian:stable-slim

# Install packages needed to run + modify genesis.json
RUN apt-get update && apt-get install -y ca-certificates sed jq && rm -rf /var/lib/apt/lists/*

# Copy binary from build stage
COPY --from=build-env /usr/local/bin/elysd /usr/local/bin/elysd

# Copy update_genesis script
COPY update_genesis.sh /root/update_genesis.sh
RUN chmod +x /root/update_genesis.sh

ENV HOME=/root
WORKDIR /root

# Initialize local chain
RUN elysd init mynode --chain-id=elys-local --home /root/.elys

# Replace "stake" with "uelys" (for staking denom)
RUN sed -i 's/"stake"/"uelys"/g' /root/.elys/config/genesis.json

# Create validator key
RUN elysd keys add validator --keyring-backend test --home /root/.elys

# Give validator enough tokens to exceed the large DefaultPowerReduction
RUN elysd add-genesis-account validator 2000000000000uelys \
    --home /root/.elys --keyring-backend test

# Self-delegate a large amount
RUN elysd gentx validator 1000000000000uelys \
    --chain-id=elys-local --home /root/.elys --keyring-backend test

# Collect gentxs
RUN elysd collect-gentxs --home /root/.elys


# Inject a uusdc asset profile with jq
# Adjust the JSON path if your module or field names differ
RUN jq '.masterchef.assetProfiles += [{"denom": "uusdc","decimals":6,"description":"USDC bridging or liquidity asset"}]' \
  /root/.elys/config/genesis.json > /root/.elys/config/genesis.tmp && \
  mv /root/.elys/config/genesis.tmp /root/.elys/config/genesis.json

# Run update_genesis script
RUN ./update_genesis.sh

# Expose typical Cosmos SDK ports
EXPOSE 26657 26656 1317 9090

# Start chain
CMD ["elysd", "start", "--home", "/root/.elys"]
