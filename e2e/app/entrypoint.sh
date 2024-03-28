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

# Genesis Accounts
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

# Initial balances corresponding to the genesis accounts
# MUST BE THE SAME NUMBER OF GENESIS ACCOUNTS
INITIAL_BALANCES[0]=100000000000000000000000000
# INITIAL_BALANCES[1]=100000000000000000000000000
# INITIAL_BALANCES[2]=100000000000000000000000000
# INITIAL_BALANCES[3]=100000000000000000000000000
# INITIAL_BALANCES[4]=100000000000000000000000000
# INITIAL_BALANCES[5]=100000000000000000000000000
# INITIAL_BALANCES[6]=100000000000000000000000000
# INITIAL_BALANCES[7]=100000000000000000000000000
# INITIAL_BALANCES[8]=100000000000000000000000000
# INITIAL_BALANCES[9]=100000000000000000000000000

# Seed Phrase for corresponding keys
# MUST BE THE SAME NUMBER OF KEYS
# Skip this if you want to create new wallets
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

INITIAL_EVM_ACCOUNT[0]=cb9935EcfFC56c38d9ed739069fB2512A90eb6C4

CHAINID="kiichain-1"
MONIKER="kiiventador"
# Remember to change to other types of keyring like 'file' in-case exposing to outside world,
# otherwise your balance will be wiped quickly
# The keyring test does not require private key to steal tokens from you
KEYRING="test"
KEYALGO="eth_secp256k1"
LOGLEVEL="info"
# Set dedicated home directory for the ./build/bin/kiichaind instance
HOMEDIR="./.tmp/kiichaind"
# to trace evm
TRACE="--trace"
# TRACE=""

# Path variables
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
	./build/bin/kiichaind init $MONIKER -o --chain-id $CHAINID --home "$HOMEDIR"

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

	for INITIAL_EVM_ACCOUNT in "${INITIAL_EVM_ACCOUNT[@]}"; do
		dec=1800000000000000000000000000
		HEX_BALANCE=$(bc <<< "obase=16;$dec")
		jq '.app_state["evm"]["alloc"]["cb9935EcfFC56c38d9ed739069fB2512A90eb6C4"]["balance"]='\"0x$HEX_BALANCE\" "$GENESIS" >"$TMP_GENESIS" && mv "$TMP_GENESIS" "$GENESIS"
	done

	# Sign genesis transaction
	./build/bin/kiichaind genesis gentx ${KEYS[0]} 1000000000000000000000tkii --keyring-backend $KEYRING --chain-id $CHAINID --home "$HOMEDIR"
	## In case you want to create multiple validators at genesis
	## 1. Back to `./build/bin/kiichaind keys add` step, init more keys
	## 2. Back to `./build/bin/kiichaind add-genesis-account` step, add balance for those
	## 3. Clone this ~/../build/bin/kiichaind home directory into some others, let's say `~/.cloned./build/bin/kiichaind`
	## 4. Run `gentx` in each of those folders
	## 5. Copy the `gentx-*` folders under `~/.cloned./build/bin/kiichaind/config/gentx/` folders into the original `~/../build/bin/kiichaind/config/gentx`

	# Collect genesis tx
	./build/bin/kiichaind genesis collect-gentxs --home "$HOMEDIR"

	# Run this to ensure everything worked and that the genesis file is setup correctly
	./build/bin/kiichaind genesis validate-genesis --home "$HOMEDIR"

	if [[ $1 == "pending" ]]; then
		echo "pending mode is on, please wait for the first block committed."
	fi
fi

# Start the node (remove the --pruning=nothing flag if historical queries are not needed)m
./build/bin/kiichaind start --pruning=nothing "$TRACE" --log_level $LOGLEVEL --api.enabled-unsafe-cors --api.enable --api.swagger --minimum-gas-prices=0.0001tkii --home "$HOMEDIR"