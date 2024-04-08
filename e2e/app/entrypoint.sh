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
KEYS[0]="genesis"
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
INITIAL_BALANCES[0]=1800000000000000
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
INITIAL_EVM_ACCOUNT[0]=37654766bf1483Fc71149ad19F084E1b0E68E8C4
INITIAL_EVM_ACCOUNT[1]=676A5cC10B6a45eF7E5594EcA61962FFD3Be2355
INITIAL_EVM_ACCOUNT[2]=88e48951BFdCBDE4E65D5f4403cbCf76f3fE18f5
INITIAL_EVM_ACCOUNT[3]=f61aE263853B62Ce4847D8b1FB32cde1C469DAC6
INITIAL_EVM_ACCOUNT[4]=6CF61447A110DaF59cDaD16ECF2D131A8978b48c
INITIAL_EVM_ACCOUNT[5]=927aE31D20654B2f709ADF12dd837144aA948e3a
INITIAL_EVM_ACCOUNT[6]=9623D5CA88eA590E6faFA97E4Aa7b2ff927C180c
INITIAL_EVM_ACCOUNT[7]=f32565A1A8e83DB48c4117eD9a8503Bf3D40AEaC
INITIAL_EVM_ACCOUNT[8]=c2f3f5ca1F6B41B9f06Ad6c94c3D66958be620E1
INITIAL_EVM_ACCOUNT[9]=1c90BA3CdB3963149Bd1e3c27bfdF10907FFE368
INITIAL_EVM_ACCOUNT_BALANCE[0]=54000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[1]=126000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[2]=180000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[3]=180000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[4]=356000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[5]=900000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[6]=1000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[7]=1000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[8]=1000000000000000000000000
INITIAL_EVM_ACCOUNT_BALANCE[9]=1000000000000000000000000

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
# VALUES ARE CURRENTLY Kiichain's PUBLIC SENTRY NODES.  FEEL FREE TO NOT USE THEM IF YOU WOULD RATHER USE DIFFERENT PEERS.
###################
PEER_ADDRESSES="55e356acc8de09092128eceb2803958d6dc1e991@18.118.138.89:26656,2f97ccda517b870c46cb996880539c5d90d31130@3.141.193.41:26656"

###################
# FILE PATHS
# different variables containing directory and file paths
###################
HOMEDIR="./.tmp/kiichaind"
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
		if [[ -z ${PHRASE[@]} ]]
		then
			./build/bin/kiichaind keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --home "$HOMEDIR"
		else
			echo "${PHRASE[KEY_PHRASE_INDEX]}" | ./build/bin/kiichaind keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --home "$HOMEDIR" --recover
		fi
		let KEY_PHRASE_INDEX=KEY_PHRASE_INDEX+1
	done

	# Change parameter token denominations to tkii
	jq '.app_state["staking"]["params"]["bond_denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["crisis"]["constant_fee"]["denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["minter"]["inflation"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["inflation_max"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["inflation_min"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["inflation_rate_change"]="0.0"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["mint"]["params"]["mint_denom"]="tkii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	jq '.app_state["evm"]["config"]["chainId"]=123454321' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"		
	jq '.app_state["evm"]["params"]["evm_denom"]="tekii"' "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"	

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
		let KEY_BALANCE_INDEX=KEY_BALANCE_INDEX+1
	done

	INITIAL_EVM_ACCOUNT_INDEX=0
	for INITIAL_EVM_ACCOUNT in "${INITIAL_EVM_ACCOUNT[@]}"; do
		if [[ -z ${INITIAL_EVM_ACCOUNT_BALANCE[@]} ]]
		then
			echo "EVM Initial Balances Required"
			exit
		else
			HEX_BALANCE=$(bc <<< "obase=16;${INITIAL_EVM_ACCOUNT_BALANCE[INITIAL_EVM_ACCOUNT_INDEX]}")
			jq '.app_state["evm"]["alloc"]['\""$INITIAL_EVM_ACCOUNT"\"']["balance"]='\"0x$HEX_BALANCE\" "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
		fi
		let INITIAL_EVM_ACCOUNT_INDEX=INITIAL_EVM_ACCOUNT_INDEX+1
	done

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

# Start the node
./build/bin/kiichaind start --pruning=default "$TRACE" --log_level $LOGLEVEL --api.enabled-unsafe-cors --api.enable --api.swagger --minimum-gas-prices=1tkii --home "$HOMEDIR"
