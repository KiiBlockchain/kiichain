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

## Configure for Local Development

## Configure for Testnet Development

## Start Node
   ```sh
   git clone https://github.com/KiiBlockchain/kiichain.git
   cd kiichain
   make build-clean

   # the first time you start the node, it's a good idea to stream the output into a file (like logs.txt in this case).  You will need to find the seed phrase of your validator account in this log file.  You can find this easily by searching the output: **Important**
   make start > logs.txt

   # if you already have your seed, simply run:
   make start
   ```

## Convert Node to Validator

## 🚧 WARNING: UNDER CONSTRUCTION 🚧

This project is work in progress and subject to frequent changes as we are still working on wiring up the final system.
It has not been audited for security purposes and should not be used in production yet.

The network will have an Ethereum JSON-RPC server running at `http://localhost:8545` and a Tendermint RPC server running at `http://localhost:26657`.
