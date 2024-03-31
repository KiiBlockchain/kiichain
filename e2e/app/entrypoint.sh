#!/bin/bash
# SPDX-License-Identifier: BUSL-1.1
#
# Copyright (C) 2024, KII Global. All rights reserved.
# Use of this software is govered by the Business Source License included
# in the LICENSE file of this repository and at www.mariadb.com/bsl11.
#
# ANY USE OF THE LICENSED WORK IN VIOLATION OF THIS LICENSE WILL AUTOMATICALLY
# TERMINATE YOUR RIGHTS UNDER THIS LICENSE FOR THE CURRENT AND ALL OTHER
# VERSIONS OF THE LICENSED WORK.
#
# THIS LICENSE DOES NOT GRANT YOU ANY RIGHT IN ANY TRADEMARK OR LOGO OF
# LICENSOR OR ITS AFFILIATES (PROVIDED THAT YOU MAY USE A TRADEMARK OR LOGO OF
# LICENSOR AS EXPRESSLY REQUIRED BY THIS LICENSE).
#
# TO THE EXTENT PERMITTED BY APPLICABLE LAW, THE LICENSED WORK IS PROVIDED ON
# AN “AS IS” BASIS. LICENSOR HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS,
# EXPRESS OR IMPLIED, INCLUDING (WITHOUT LIMITATION) WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, AND
# TITLE.

############################################################################
# START CONFIGURATION
############################################################################

###################
# ACCOUNT KEYS
# Wallets that are initialized on node setup.
# if you're joining testnet or mainnet, you only need to set up 1 (your validator).
# for local development, these wallets are included in the genesis file.
###################
KEYS[0]="private_sale"
# KEYS[1]="public_sale"
# KEYS[2]="liquidity"
# KEYS[3]="community_development"
# KEYS[4]="team"
# KEYS[5]="rewards"
# KEYS[6]="kiiventadorwallet"
# KEYS[7]="kiiferrari458wallet"
# KEYS[8]="kiiuruswallet"
# KEYS[9]="kiipaganiwallet"

###################
# INITIAL BALANCES
# Balances that are initialized to the corresponding keys above (KEYS[0] will have a balance of INITIAL_BALANCES[0]).
# Note: this does not matter if you're joining testnet or mainnet
###################
INITIAL_BALANCES[0]=54000000000000
# INITIAL_BALANCES[1]=126000000000000
# INITIAL_BALANCES[2]=180000000000000
# INITIAL_BALANCES[3]=180000000000000
# INITIAL_BALANCES[4]=356000000000000
# INITIAL_BALANCES[5]=900000000000000
# INITIAL_BALANCES[6]=1000000000000
# INITIAL_BALANCES[7]=1000000000000
# INITIAL_BALANCES[8]=1000000000000
# INITIAL_BALANCES[9]=1000000000000

###################
# SEED PHRASES
# Seed phrases that are used to initialize a specific wallet.  Skip this configuration if creating completely new wallets.
# Phrases will correspond to keys (KEYS[0] will be derrived from phrase PHRASE[0]).
###################
# PHRASE[0]=""
# PHRASE[1]=""
# PHRASE[2]=""
# PHRASE[3]=""
# PHRASE[4]=""
# PHRASE[5]=""
# PHRASE[6]=""
# PHRASE[7]=""
# PHRASE[8]=""
# PHRASE[9]=""


###################
# EVM
# Configuration settings for evm module.  Skip this when joining testnet or mainnet.
# initial evm address without the "0x" prefix
# initial evm wallet balance in wei (10**18)
###################
INITIAL_EVM_ACCOUNT=cb9935EcfFC56c38d9ed739069fB2512A90eb6C4
INITIAL_EVM_ACCOUNT_BALANCE=1800000000000000000000000000

###################
# CHAIN INFO
# For local chain development.  Skip this step when joining testnet or mainnet.
###################
CHAINID="kiichain-1"
MONIKER="Kiichain Validator 1"
KEYRING="test"
KEYALGO="eth_secp256k1"
LOGLEVEL="info"
# to trace evm.  Blank string to disable the trace.
TRACE="--trace"

###################
# VALIDATOR SEED PEERS
# seed validators to join a network
# format comma separated: <node id 1>@<ip address>:26656,<node id 2>@<ip address>:26656
###################
PEER_ADDRESSES=""

###################
# FILE PATHS
# different variables containing directory and file paths
###################
HOMEDIR="~/.kiichaind"
CONFIG_TOML=$HOMEDIR/config/config.toml
APP_TOML=$HOMEDIR/config/app.toml
GENESIS=$HOMEDIR/config/genesis.json
TMP_GENESIS=$HOMEDIR/config/tmp_genesis.json


############################################################################
# END CONFIGURATION
############################################################################

# used to exit on first error (any non-zero exit code)
set -e

# Reinstall daemon
make build

overwrite="N"
# fi
if [ -d "$HOMEDIR" ]; then
	printf "\nAn existing folder at '%s' was found. You can choose to delete this folder and start a new local node with new keys from genesis. When declined, the existing local node is started. \n" "$HOMEDIR"
	echo "Overwrite the existing configuration and start a new local node? [y/n]"
	read -r overwrite
else	
overwrite="Y"
fi

# Setup local node if overwrite is set to Yes, otherwise skip setup
if [[ $overwrite == "y" || $overwrite == "Y" ]]; then
	# # Remove the previous folder
	rm -rf "$HOMEDIR"

	# # Set moniker and chain-id (Moniker can be anything, chain-id must be an integer)
	./build/bin/kiichaind init "$MONIKER" -o --chain-id $CHAINID --home "$HOMEDIR"

	# Set client config
	./build/bin/kiichaind config set client keyring-backend $KEYRING --home "$HOMEDIR"
	./build/bin/kiichaind config set client chain-id "$CHAINID" --home "$HOMEDIR"

	# If keys exist they should be deleted
	KEY_PHRASE_INDEX=0
	for KEY in "${KEYS[@]}"; do
		if [[ -v ${PHRASE[@]} ]]
		then
			echo "${PHRASE[KEY_PHRASE_INDEX]}" | ./build/bin/kiichaind keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --home "$HOMEDIR" --recover
		else
			./build/bin/kiichaind keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --home "$HOMEDIR"
		fi
		((KEY_PHRASE_INDEX++))
	done

	# Change parameter token denominations to tkii
	jq '.app_state["staking"]["params"]["bond_denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["crisis"]["constant_fee"]["denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["minter"]["inflation"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["inflation_max"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["inflation_min"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["inflation_rate_change"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["mint_denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["staking"]["params"]["bond_denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["evm"]["config"]["chainId"]=123454321' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"		
	jq '.app_state["evm"]["params"]["evm_denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"	

	# Allocate genesis accounts (kii formatted addresses)
	KEY_BALANCE_INDEX=0
	for KEY in "${KEYS[@]}"; do
		if [[ -z ${INITIAL_BALANCES[@]} ]]
		then
			echo "Initial Balances Required"
			exit
		else
			./build/bin/kiichaind genesis add-genesis-account $KEY ${INITIAL_BALANCES[KEY_BALANCE_INDEX]}tkii --keyring-backend $KEYRING --home "$HOMEDIR"
		fi
		((KEY_BALANCE_INDEX++))
	done

	HEX_BALANCE=$(bc <<< "obase=16;$INITIAL_EVM_ACCOUNT_BALANCE")
	jq '.app_state["evm"]["alloc"]['\""$INITIAL_EVM_ACCOUNT"\"']["balance"]='\"0x$HEX_BALANCE\" "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"

	# Sign genesis transaction
	./build/bin/kiichaind genesis gentx ${KEYS[0]} ${INITIAL_BALANCES[0]}tkii --keyring-backend $KEYRING --chain-id $CHAINID --home "$HOMEDIR"

	# Collect genesis tx
	./build/bin/kiichaind genesis collect-gentxs --home "$HOMEDIR"

	# Run this to ensure everything worked and that the genesis file is setup correctly
	./build/bin/kiichaind genesis validate-genesis --home "$HOMEDIR"

	if [[ $1 == "pending" ]]; then
		echo "pending mode is on, please wait for the first block committed."
	fi
fi

# add persistent peers
sed -i'' -e "s/^persistent_peers = .*/persistent_peers = \"$PEER_ADDRESSES\"/" "$CONFIG_TOML"

# Start the node (remove the --pruning=nothing flag if historical queries are not needed)m
./build/bin/kiichaind start --pruning=nothing "$TRACE" --log_level $LOGLEVEL --api.enabled-unsafe-cors --api.enable --api.swagger --minimum-gas-prices=0.0001tkii --home "$HOMEDIR"