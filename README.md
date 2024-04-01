<h1 align="center"> Kiichain </h1>

*This project has been forked from [Berachain's Polaris](https://github.com/berachain/polaris).*


## Pre-requisite

- Golang 1.20+
- jq (sudo apt-get install jq)
- 100 GB storage (minimum for testnet)
- 4 GB RAM (minimum for testnet)
- 1 Gbps network speed (minimum for testnet)

## Disclaimer

The instructions below are meant as a starter guideline.  They are not meant to be followed strictly.  Please adjust values to suite your validator operation needs.  For any issues with validator operations, please refer to the following channels for support:

- [Kii Discord #validator-support](https://discord.com/invite/fUcfeYYtVF)
- [Kiichain Repository Issues](https://github.com/KiiBlockchain/kiichain/issues)
- [Cosmos SDK Documentation](https://docs.cosmos.network/v0.50/learn)

## Configure Node
   ```sh
   git clone https://github.com/KiiBlockchain/kiichain.git
   cd kiichain

   # foundry installer
   curl -L https://foundry.paradigm.xyz | bash

   # re-invoke shell or simply close and re-open your session
   exec $SHELL

   # install foundry
   foundryup

   make build-clean
   nano e2e/app/entrypoint.sh

   # in nano, modify the variables between the sections:
   # START CONFIGURATION and END CONFIGURATION
   ```

## Start Node
   ```sh
   # the first time you start the node, it's a good idea to stream the output into a file (like logs.txt in this case).  You will need to find the seed phrase of your validator account in this log file.  You can find this easily by searching the output: **Important**
   make start > logs.txt 2>&1

   # if you already have your seed, simply run:
   make start
   ```

## Connecting to Testnet
   ```sh
   # NOTE: When starting the node, you may run into the error:
   # failed to execute message; message index: 0: invalid coin denomination: got tkii, expected stake: invalid request
   # this is because you need to replace the automatically generated genesis file with the genesis file in the repo:

   # if home directory is set to .tmp/kiichaind
   cp genesis/genesis.json .tmp/kiichaind/config/genesis.json

   # reset any created blockchain state
   ./build/bin/kiichaind comet unsafe-reset-all --home .tmp/kiichaind

   # start your node via kiichaind
   ./build/bin/kiichaind start --pruning=default --trace --log_level info --api.enabled-unsafe-cors --api.enable --api.swagger --minimum-gas-prices=1tkii --home .tmp/kiichaind
   ```

## Node Syncing
There are two types of node syncing methods available.  Fast Sync and State Sync.  For fast sync, you simply replace the genesis file (as mentioned in the above step for connecting to testnet) and start your node.  Depending on the current block height, your node might take a while to catch up.  Depending on how many blocks your node needs to catch up to, the process can take hours or even days.

If you do not have the patience for this, the second method to syncing your node is state sync.  For a more information, please visit [State Sync in Tendermint's Documentation](https://docs.tendermint.com/v0.34/tendermint-core/state-sync.html).

## Create Validator.json
NOTE: to get pubkey, execute the command:
```
./build/bin/kiichaind comet show-validator --home .tmp/kiichaind
```
```json
{
        "pubkey": <YOUR PUBKEY>,
        "amount": "10000000000tkii",
        "moniker": "YOUR VALIDATOR NAME",
        "identity": "YOUR KEYBASE IDENTITY",
        "website": "YOUR VALIDATOR WEBSITE",
        "security": "YOUR VALIDATOR EMAIL",
        "details": "YOUR VALIDATOR DESCRIPTION",
        "commission-rate": "0.1",
        "commission-max-rate": "0.2",
        "commission-max-change-rate": "0.01",
        "min-self-delegation": "10000000000"
}
```

## Convert Node to Validator
   ```sh
   # ENSURE: 
   # 1) you have kii coins in your validator wallet
   # 2) your node is fully synced with the blockchain
   # 3) your golang environment is enabled
   # 4) make sure you have your validator.json

   ./build/bin/kiichaind tx staking create-validator \
  validator.json \
  --from <your validator wallet from entrypoint.sh> \
  --keyring-backend test \
  --chain-id kiichain-1 \
  --home .tmp/kiichaind

   # Pro tip: if you do not want to keep including the full path to kiichaind, consider creating a symlink for it
   ```

## 🚧 WARNING: UNDER CONSTRUCTION 🚧

This project is work in progress and subject to frequent changes as we are still working on wiring up the final system.
It has not been audited for security purposes and should not be used in production yet.

The network will have an Ethereum JSON-RPC server running at `http://localhost:8545` and a Tendermint RPC server running at `http://localhost:26657`.
