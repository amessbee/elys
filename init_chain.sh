#!/bin/bash
set -e  # Exit on error

echo "Initializing Elys local chain..."

# Initialize the chain
elysd init mynode --chain-id=elys-local --home /root/.elys
echo "Chain initialized."

# Replace "stake" with "uelys"
sed -i 's/"stake"/"uelys"/g' /root/.elys/config/genesis.json
jq '.' /root/.elys/config/genesis.json > /dev/null || { echo "Genesis file invalid after sed"; exit 1; }
echo "Staking denom updated."

# Add uusdc to masterchef asset profiles
jq '.masterchef.assetProfiles += [{"denom": "uusdc","decimals":6,"description":"USDC bridging or liquidity asset"}]' \
  /root/.elys/config/genesis.json > temp.json && mv temp.json /root/.elys/config/genesis.json
jq '.' /root/.elys/config/genesis.json > /dev/null || { echo "Genesis file invalid after masterchef update"; exit 1; }
echo "Masterchef asset profile updated."

# Run custom genesis updates
/root/update_genesis.sh
jq '.' /root/.elys/config/genesis.json > /dev/null || { echo "Genesis file invalid after update_genesis.sh"; exit 1; }
echo "Custom genesis updates applied."

# Create validator key
echo "Creating validator key..."
elysd keys add validator --keyring-backend test --home /root/.elys
VALIDATOR_ADDRESS=$(elysd keys show validator --keyring-backend test --home /root/.elys -a)
echo "Validator address: $VALIDATOR_ADDRESS"

# Fund validator
echo "Funding validator..."
elysd add-genesis-account "$VALIDATOR_ADDRESS" 2000000000000uelys --home /root/.elys --keyring-backend test

# Generate gentx
echo "Generating gentx..."
elysd gentx validator 1000000000000uelys --chain-id=elys-local --home /root/.elys --keyring-backend test || {
  echo "gentx failed. Check logs above."
  exit 1
}

# Check if gentx file exists
GENTX_FILE=$(ls /root/.elys/config/gentx/*.json 2>/dev/null || true)
if [ -z "$GENTX_FILE" ]; then
  echo "No gentx file generated in /root/.elys/config/gentx/!"
  exit 1
fi
echo "gentx generated: $GENTX_FILE"
cat "$GENTX_FILE"  # Output the gentx file for debugging

# Collect gentxs
echo "Collecting gentxs..."
elysd collect-gentxs --home /root/.elys

# Check if validators are present in genesis.json
echo "Checking validator set..."
VALIDATOR_COUNT=$(jq '.app_state.staking.validators | length' /root/.elys/config/genesis.json)
if [ "$VALIDATOR_COUNT" -eq 0 ]; then
  echo "Error: No validators found in genesis.json after collect-gentxs!"
  jq '.app_state.staking' /root/.elys/config/genesis.json  # Dump staking state for debugging
  exit 1
fi
echo "Validator set populated with $VALIDATOR_COUNT validator(s)."

# Start the chain
echo "Starting Elys chain..."
exec elysd start --home /root/.elys