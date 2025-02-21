#!/bin/bash
set -e  # Exit on error

# Initialize the chain
elysd init mynode --chain-id=elys-local --home /root/.elys

# Replace "stake" with "uelys"
sed -i 's/"stake"/"uelys"/g' /root/.elys/config/genesis.json

# Add uusdc asset profile
jq '.masterchef.assetProfiles += [{"denom": "uusdc","decimals":6,"description":"USDC bridging or liquidity asset"}]' \
  /root/.elys/config/genesis.json > /root/.elys/config/genesis.tmp && \
  mv /root/.elys/config/genesis.tmp /root/.elys/config/genesis.json

# Run custom genesis updates
/root/update_genesis.sh

# Create validator key
elysd keys add validator --keyring-backend test --home /root/.elys

# Fund validator
elysd add-genesis-account validator 2000000000000uelys --home /root/.elys --keyring-backend test

# Generate gentx (capture output for debugging)
elysd gentx validator 1000000000000uelys --chain-id=elys-local --home /root/.elys --keyring-backend test || {
  echo " gentx failed. Check logs above."
  exit 1
}

# Check if gentx file exists
if [ ! -f /root/.elys/config/gentx/*.json ]; then
  echo "No gentx file generated!"
  exit 1
fi

# Collect gentxs
elysd collect-gentxs --home /root/.elys

# Start the chain
exec elysd start --home /root/.elys
