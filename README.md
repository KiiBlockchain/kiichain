<h1 align="center"> Kiichain </h1>

*This project has been forked from [Berachain's Polaris](https://github.com/berachain/polaris).*


## Pre-requisite

- Golang 1.20+
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
   make build-clean
   nano e2e/app/entrypoint.sh

   # in nano, modify the variables between the sections:
   # START CONFIGURATION and END CONFIGURATION
   ```

## Start Node
   ```sh
   # the first time you start the node, it's a good idea to stream the output into a file (like logs.txt in this case).  You will need to find the seed phrase of your validator account in this log file.  You can find this easily by searching the output: **Important**
   make start > logs.txt

   # if you already have your seed, simply run:
   make start
   ```

## Connecting to Testnet
   ```sh
   # Once you've successfully started your node with make start, stop your node

   # replace the genesis file with the command:
   mv genesis/genesis.json .tmp/kiichaind/config/genesis.json

   # start your node again
   make start
   ```

## Node Syncing
There are two types of node syncing methods available.  Fast Sync and State Sync.  For fast sync, you simply replace the genesis file (as mentioned in the above step for connecting to testnet) and start your node.  Depending on the current block height, your node might take a while to catch up.  Depending on how many blocks your node needs to catch up to, the process can take hours or even days.

If you do not have the patience for this, the second method to syncing your node is state sync.  For a more information, please visit [State Sync in Tendermint's Documentation](https://docs.tendermint.com/v0.34/tendermint-core/state-sync.html).

## Convert Node to Validator
   ```sh
   # ENSURE: 
   # 1) you have kii coins in your validator wallet
   # 2) your node is fully synced with the blockchain
   # 3) your golang environment is enabled

   ./build/bin/kiichaind tx staking create-validator \
      --amount=10000000000tkii \
      --pubkey=$(./build/bin/kiichaind tendermint show-validator) \
      --moniker=<name of your validator> \
      --commission-rate=0.1 \ #this represents 10%
      --commission-max-rate=0.2 \ #this represents 20%
      --commission-max-change-rate=0.01 \
      --min-self-delegation=1 \
      --gas=auto --gas-adjustment=1.2 \
      --gas-prices=10.0tkii \
      --from <the name of your validator wallet, KEYS[0] in entrypoint.sh configuration>

   # Pro tip: if you do not want to keep including the full path to kiichaind, consider creating a symlink for it
   ```

## 🚧 WARNING: UNDER CONSTRUCTION 🚧

This project is work in progress and subject to frequent changes as we are still working on wiring up the final system.
It has not been audited for security purposes and should not be used in production yet.

The network will have an Ethereum JSON-RPC server running at `http://localhost:8545` and a Tendermint RPC server running at `http://localhost:26657`.
