#!/bin/bash

# Set the genesis file path
GENESIS_FILE="$HOME/.elys/config/genesis.json"

# Update price expiry time and lifetime in blocks
jq '.app_state.oracle.params.price_expiry_time = "86400000000"' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE
jq '.app_state.oracle.params.life_time_in_blocks = "1000000000"' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE



# # Add CCV Consumer state
# jq '.app_state.ccvconsumer = {
#   "params": {
#     "enabled": true,
#     "blocks_per_distribution_transmission": "1000",
#     "distribution_transmission_channel": "",
#     "provider_fee_pool_addr_str": "elys10d07y265gmmuvt4z0w9aw880jnsr700j6z2zm3",
#     "ccv_timeout_period": "2419200s",
#     "transfer_timeout_period": "3600s",
#     "consumer_redistribution_fraction": "0.75",
#     "historical_entries": "10000",
#     "unbonding_period": "1728000s"
#   },
#   "provider_client_state": {
#     "chain_id": "elys-mainnet",
#     "trust_level": {
#       "numerator": "1",
#       "denominator": "3"
#     },
#     "trusting_period": "1209600s",
#     "unbonding_period": "1728000s",
#     "max_clock_drift": "10s",
#     "frozen_height": {
#       "revision_number": "0",
#       "revision_height": "0"
#     },
#     "latest_height": {
#       "revision_number": "0",
#       "revision_height": "1"
#     },
#     "proof_specs": null,
#     "upgrade_path": ["upgrade", "upgradedIBCState"],
#     "allow_update_after_expiry": true,
#     "allow_update_after_misbehaviour": true
#   },
#   "provider_consensus_state": {
#     "timestamp": "2024-02-21T00:00:00Z",
#     "root": {
#       "hash": ""
#     },
#     "next_validators_hash": ""
#   },
#   "new_chain": true
# }' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE

# # Add ICA Controller state
# jq '.app_state.interchainaccounts = {
#   "controller_genesis_state": {
#     "active_channels": [],
#     "interchain_accounts": [],
#     "ports": ["icacontroller-elys"],
#     "params": {
#       "controller_enabled": true
#     }
#   },
#   "host_genesis_state": {
#     "active_channels": [],
#     "interchain_accounts": [],
#     "port": "icahost",
#     "params": {
#       "host_enabled": true,
#       "allow_messages": ["*"]
#     }
#   }
# }' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE

# ...existing code...
# Add asset profiles
jq '.app_state.assetprofile.entry_list = [
  {
    "address": "",
    "authority": "elys10d07y265gmmuvt4z0w9aw880jnsr700j6z2zm3",
    "baseDenom": "uelys",
    "decimals": "6",
    "denom": "uelys",
    "displayName": "ELYS",
    "displaySymbol": "",
    "externalSymbol": "",
    "ibcChannelId": "",
    "ibcCounterpartyChainId": "",
    "ibcCounterpartyChannelId": "",
    "ibcCounterpartyDenom": "",
    "network": "",
    "path": "",
    "permissions": [],
    "transferLimit": "",
    "unitDenom": ""
  },
  {
    "address": "",
    "authority": "elys10d07y265gmmuvt4z0w9aw880jnsr700j6z2zm3",
    "baseDenom": "uusdc",
    "decimals": "6",
    "denom": "uusdc",
    "displayName": "USDC",
    "displaySymbol": "",
    "externalSymbol": "",
    "ibcChannelId": "",
    "ibcCounterpartyChainId": "",
    "ibcCounterpartyChannelId": "",
    "ibcCounterpartyDenom": "",
    "network": "",
    "path": "",
    "permissions": [],
    "transferLimit": "",
    "unitDenom": ""
  },
  {
    "address": "",
    "authority": "elys10d07y265gmmuvt4z0w9aw880jnsr700j6z2zm3",
    "baseDenom": "ueden",
    "decimals": "6",
    "denom": "ueden",
    "displayName": "EDEN",
    "displaySymbol": "",
    "externalSymbol": "",
    "ibcChannelId": "",
    "ibcCounterpartyChainId": "",
    "ibcCounterpartyChannelId": "",
    "ibcCounterpartyDenom": "",
    "network": "",
    "path": "",
    "permissions": [],
    "transferLimit": "",
    "unitDenom": ""
  },
  {
    "address": "",
    "authority": "elys10d07y265gmmuvt4z0w9aw880jnsr700j6z2zm3",
    "baseDenom": "uedenb",
    "decimals": "6",
    "denom": "uedenb",
    "displayName": "EDENB",
    "displaySymbol": "",
    "externalSymbol": "",
    "ibcChannelId": "",
    "ibcCounterpartyChainId": "",
    "ibcCounterpartyChannelId": "",
    "ibcCounterpartyDenom": "",
    "network": "",
    "path": "",
    "permissions": [],
    "transferLimit": "",
    "unitDenom": ""
  }
]' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE

# Add price feeders
jq '.app_state.oracle.price_feeders = [
  {
    "feeder": "elys1g3qnq7apxv964cqj0hza0pnwsw3q920lcc5lyg",
    "is_active": true
  },
  {
    "feeder": "elys1ufelja7snayw39d0c2hepx0epcuwrmw6z5yg98",
    "is_active": true
  }
]' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE

# Add asset infos
jq '.app_state.oracle.asset_infos = [
  {
    "denom": "satoshi",
    "display": "BTC",
    "band_ticker": "BTC",
    "elys_ticker": "BTC",
    "decimal": "0"
  },
  {
    "denom": "wei",
    "display": "ETH",
    "band_ticker": "ETH",
    "elys_ticker": "ETH",
    "decimal": "0"
  },
  {
    "denom": "uelys",
    "display": "ELYS",
    "band_ticker": "ELYS",
    "elys_ticker": "ELYS",
    "decimal": "6"
  },
  {
    "denom": "ueden",
    "display": "EDEN",
    "band_ticker": "EDEN",
    "elys_ticker": "EDEN",
    "decimal": "6"
  },
  {
    "denom": "uedenb",
    "display": "EDENB",
    "band_ticker": "EDENB",
    "elys_ticker": "EDENB",
    "decimal": "6"
  },
  {
    "denom": "uusdt",
    "display": "USDT",
    "band_ticker": "USDT",
    "elys_ticker": "USDT",
    "decimal": "6"
  },
  {
    "denom": "uusdc",
    "display": "USDC",
    "band_ticker": "USDC",
    "elys_ticker": "USDC",
    "decimal": "6"
  }
]' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE

# Get current timestamp
CURRENT_TIMESTAMP=$(date +%s)

# Add prices
jq --arg timestamp "$CURRENT_TIMESTAMP" '.app_state.oracle.prices = [
  {
    "asset": "USDT",
    "price": "1.0",
    "provider": "elys1ufelja7snayw39d0c2hepx0epcuwrmw6z5yg98",
    "source": "elys",
    "timestamp": $timestamp
  },
  {
    "asset": "USDC",
    "price": "1.0",
    "provider": "elys1ufelja7snayw39d0c2hepx0epcuwrmw6z5yg98",
    "source": "elys",
    "timestamp": $timestamp
  },
  {
    "asset": "ELYS",
    "price": "3",
    "provider": "elys1ufelja7snayw39d0c2hepx0epcuwrmw6z5yg98",
    "source": "elys",
    "timestamp": $timestamp
  },
  {
    "asset": "EDEN",
    "price": "2",
    "provider": "elys1ufelja7snayw39d0c2hepx0epcuwrmw6z5yg98",
    "source": "elys",
    "timestamp": $timestamp
  },
  {
    "asset": "EDENB",
    "price": "2",
    "provider": "elys1ufelja7snayw39d0c2hepx0epcuwrmw6z5yg98",
    "source": "elys",
    "timestamp": $timestamp
  }
]' $GENESIS_FILE > temp.json && mv temp.json $GENESIS_FILE

# Make the script executable
chmod +x update_genesis.sh

echo "Genesis file has been updated successfully!"